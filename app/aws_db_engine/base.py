import json
import os

import boto3
from django.core.exceptions import ImproperlyConfigured
from django.db.backends.postgresql import base


class DatabaseWrapper(base.DatabaseWrapper):
    # This method returns the latest password stored in the secret
    def get_most_recent_password(self):
        try:
            secret_name = os.getenv("RDS_PASSWORD_KMS_ID")
            region_name = os.getenv("AWS_DEFAULT_REGION")
            session = boto3.session.Session()
            client = session.client(
                service_name="secretsmanager", region_name=region_name
            )
            secrets = client.get_secret_value(SecretId=secret_name)
            password = json.loads(secrets["SecretString"])["password"]
            username = json.loads(secrets["SecretString"])["username"]
        except Exception as e:
            raise Exception("Failed to retrieve credentials from Secrets Manager", e)

        return username, password

    """
    This method is overriden from the base DatabaseWrapper class
    in a way to allow the usage of dynamic, rotating passwords.
    Note that the if statement that sets the password is commented out
    and a call to get_most_recent_password() is used to fetch the
    latest password from Secrets Manager.
    Everything else remains unchanged from the original code.
    """

    def get_connection_params(self):
        settings_dict = self.settings_dict
        # None may be used to connect to the default 'postgres' db
        if settings_dict["NAME"] == "":
            raise ImproperlyConfigured(
                "settings.DATABASES is improperly configured. "
                "Please supply the NAME value."
            )
        if len(settings_dict["NAME"] or "") > self.ops.max_name_length():
            raise ImproperlyConfigured(
                "The database name '%s' (%d characters) is longer than "
                "PostgreSQL's limit of %d characters. Supply a shorter NAME "
                "in settings.DATABASES."
                % (
                    settings_dict["NAME"],
                    len(settings_dict["NAME"]),
                    self.ops.max_name_length(),
                )
            )
        conn_params = {
            "database": settings_dict["NAME"] or "postgres",
            **settings_dict["OPTIONS"],
        }
        conn_params.pop("isolation_level", None)
        if settings_dict["HOST"]:
            conn_params["host"] = settings_dict["HOST"]
        if settings_dict["PORT"]:
            conn_params["port"] = settings_dict["PORT"]

        conn_params["user"], conn_params["password"] = self.get_most_recent_password()
        return conn_params

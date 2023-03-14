resource "aws_key_pair" "production" {
  key_name   = "${var.project_name}_${terraform.workspace}_key_pair"
  public_key = file(var.ssh_pubkey_file)
  tags = {
    "project" : var.project_name
    "type" : terraform.workspace
  }
}
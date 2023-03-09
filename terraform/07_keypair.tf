resource "aws_key_pair" "production" {
  key_name   = "${terraform.workspace}_key_pair"
  public_key = file(var.ssh_pubkey_file)
}
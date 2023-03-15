provider "aws" {
  region = var.region
}

provider "aws" {
  alias  = "replica"
  region = var.region_replica
}

provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

provider "aws" {
  alias  = "eu-west-1"
  region = "eu-west-1"
}

data "aws_availability_zones" "available" {
  for_each = toset(var.desired_regions)
  filter {
    name   = "region-name"
    values = [each.value]
  }
}
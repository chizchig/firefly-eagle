
variable "vpcs" {
  type = map(object({
    cidr_block       = string
    region           = string
    instance_tenancy = string
  }))
  default = {
    vpc1 = {
      cidr_block       = "10.0.0.0/16"
      region           = "us-east-1"
      instance_tenancy = "default"
    },
    vpc2 = {
      cidr_block       = "192.168.0.0/16"
      region           = "eu-west-1"
      instance_tenancy = "default"
    }
  }
}

variable "desired_regions" {
  type    = list(string)
  default = ["us-east-1", "eu-west-1"]
}

variable "ami_id" {
  type = string
  default = "ami-0f34c5ae932e6f0e4"
}
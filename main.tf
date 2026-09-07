provider "aws" {
    region = var.region
    # access_key_id = "<YOUR_ACCESS_KEY_ID>" # -> exposing keys this way.Use gitHub actions marketplace
    # secret_access_key = "<YOUR_SECRET_ACCESS_KEY>"
}

terraform {
  backend "s3" {
    bucket = "kaizen-dennis-backend"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}



data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "example" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  tags = {
    Name = var.instance_name
  }
}

variable "instance_type" {} # -> will be an error(vars value not defined - expected us to inpute value)as we dhave to define this vars in var.tfvars file, but it not be pushed to git
variable "instance_name" {} # -> have to provide in workflow_dispatch : user inputs
variable "region" {}
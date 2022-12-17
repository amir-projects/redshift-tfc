resource "aws_vpc" "redshift_vpc" {

  cidr_block = var.vpc_cidr

  instance_tenancy = "default"

  tags = {

    Name = "redshift-vpc"

  }

}
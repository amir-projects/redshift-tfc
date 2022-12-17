resource "aws_vpc" "redshift_vpc" {

  cidr_block = var.vpc_cidr

  instance_tenancy = "default"

  tags = {

    Name = "redshift-vpc"

  }

}


resource "aws_internet_gateway" "redshift_vpc_gw" {

 vpc_id = "${aws_vpc.redshift_vpc.id}"

depends_on = [

   aws_vpc.redshift_vpc

 ]

}
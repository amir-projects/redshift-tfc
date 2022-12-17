##Create the new VPC for our redshift cluster.##

resource "aws_vpc" "redshift_vpc" {

  cidr_block = var.vpc_cidr

  instance_tenancy = "default"

  tags = {

    Name = "redshift-vpc"

  }

}
##Now, We will define an internet gateway that we can attach to our VPC. After this, We can easily access this from the internet##

resource "aws_internet_gateway" "redshift_vpc_gw" {

  vpc_id = aws_vpc.redshift_vpc.id

  depends_on = [

    aws_vpc.redshift_vpc
  ]

  tags = {

    Name = "redshift-igw"

  }
}

##At this point, We will modify the default security group to only allow ingress from port 5439 which is the Redshift port##
##We will set the IP to the ingress cidr_blocks. I am using 0.0.0.0/0 so no one will know my IP##
##but this is not the best practice as it will allow anyone to connect to your cluster If they know the username and password##

resource "aws_default_security_group" "redshift_security_group" {

  vpc_id = aws_vpc.redshift_vpc.id

  ingress {

    from_port = 5439

    to_port = 5439

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

  }


  tags = {

    Name = "redshift-sg"

  }

  depends_on = [

    aws_vpc.redshift_vpc

  ]

}

##Next, we will create two subnets. These subnet will use when creating our Redshift Subnet Group##

resource "aws_subnet" "redshift_subnet_1" {

  vpc_id = aws_vpc.redshift_vpc.id

  cidr_block = var.redshift_subnet_cidr_first

  availability_zone = "ap-northeast-1a"

  map_public_ip_on_launch = "true"

  tags = {

    Name = "redshift-subnet-1"

  }

  depends_on = [

    aws_vpc.redshift_vpc

  ]

}

resource "aws_subnet" "redshift_subnet_2" {

  vpc_id = aws_vpc.redshift_vpc.id

  cidr_block = var.redshift_subnet_cidr_second

  availability_zone = "ap-northeast-1c"

  map_public_ip_on_launch = "true"

  tags = {

    Name = "redshift-subnet-2"

  }

  depends_on = [

    aws_vpc.redshift_vpc

  ]

}
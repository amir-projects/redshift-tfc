##Create the new VPC for our redshift cluster.##

resource "aws_vpc" "redshift_vpc" {

  cidr_block = var.vpc_cidr

  instance_tenancy = "default"

  tags = { Name = "redshift-vpc" }
}

##Now, We will define an internet gateway that we can attach to our VPC. After this, We can easily access this from the internet##

resource "aws_internet_gateway" "redshift_vpc_gw" {

  vpc_id = aws_vpc.redshift_vpc.id

  depends_on = [aws_vpc.redshift_vpc]

  tags = { Name = "redshift-igw" }
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


  tags = { Name = "redshift-sg" }

  depends_on = [aws_vpc.redshift_vpc]
}

##Next, we will create two subnets. These subnet will use when creating our Redshift Subnet Group##

resource "aws_subnet" "redshift_subnet_1" {

  vpc_id = aws_vpc.redshift_vpc.id

  cidr_block = var.redshift_subnet_cidr_first

  availability_zone = "ap-northeast-1a"

  map_public_ip_on_launch = "true"

  tags = { Name = "redshift-subnet-1" }

  depends_on = [aws_vpc.redshift_vpc]
}

resource "aws_subnet" "redshift_subnet_2" {

  vpc_id = aws_vpc.redshift_vpc.id

  cidr_block = var.redshift_subnet_cidr_second

  availability_zone = "ap-northeast-1c"

  map_public_ip_on_launch = "true"

  tags = { Name = "redshift-subnet-2" }

  depends_on = [aws_vpc.redshift_vpc]
}
##We will define the redshift subnet group resource##

resource "aws_redshift_subnet_group" "redshift_subnet_group" {

  name = "redshift-subnet-group"

  subnet_ids = ["${aws_subnet.redshift_subnet_1.id}", "${aws_subnet.redshift_subnet_2.id}"]

  tags = {

    environment = "dev"

    Name = "redshift-subnet-group"

  }

}

##We will create an IAM Role Policy. This role will allow our cluster to read and write to any of our S3 bucket##
resource "aws_iam_role_policy" "s3_full_access_policy" {
  name = "redshift_s3_policy"
  role = aws_iam_role.redshift_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role" "redshift_role" {
  name = "redshift_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "redshift.amazonaws.com"
        }
      },
    ]
  })
}

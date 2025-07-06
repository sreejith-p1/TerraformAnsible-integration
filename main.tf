provider "aws" {
  region = "us-east-2"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-2a"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_instance" "web" {
  ami           = "ami-0fc682b3a5d4a9a64" # Ubuntu 22.04 LTS AMI for us-east-2
  instance_type = "t2.micro"
  key_name      = "Terraform_learning" # Replace with your key pair
  subnet_id     = aws_subnet.main.id

  tags = {
    Name = "AnsibleDemo"
  }
}

output "instance_ip" {
  value = aws_instance.web.public_ip
}
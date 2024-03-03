provider "aws" {
  region     = "us-east-1"
 
}

resource "aws_vpc" "virtual" {
  cidr_block = "10.0.0.0/16"

  tags = {
    name = "virtualPC"
  }
}

resource "aws_subnet" "demo_subnet" {
  vpc_id     = aws_vpc.virtual.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "demo_subnet"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.virtual.id

  tags = {
    Name = "main"
  }
}

resource "aws_route_table" "rtb" {
  vpc_id = aws_vpc.virtual.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "main"
  }
}


resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.demo_subnet.id
  route_table_id = aws_route_table.rtb.id
}

resource "aws_security_group" "sg_1" {
  name = "HTTP, HTTPS and SSH"
  vpc_id = aws_vpc.virtual.id

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

   ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  
  tags = {
    name = "my_sg"
  }

}

data "aws_key_pair" "newpem" {
  key_name = "new"  # Replace with the actual name of your key pair
}


resource "aws_instance" "instance2" {
  ami           = "ami-0c7217cdde317cfec"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.demo_subnet.id
  vpc_security_group_ids = [ aws_security_group.sg_1.id ]
  associate_public_ip_address = true
  key_name = data.aws_key_pair.newpem.key_name
  count = 3
  user_data = <<-EOF
              #!/bin/bash

              sudo apt update -y
              sudo apt install nginx -y
              sudo systemctl start nginx 
              EOF               
  tags = {
    Name = "my-instance"
  }
}

output "public_ip" {
  value = aws_instance.instance2[*].public_ip
}







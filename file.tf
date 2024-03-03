provider "aws" {
  region     = "us-east-1"
  access_key = "AKIA5PW54AK52SBFXZAR"
  secret_key = "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"
}

resource "aws_vpc" "vpc1" {
  cidr_block = "10.0.0.0/16"

  tags = {
    name = "my_vpc"
  }
}

resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "my_subnet"
  }
}


resource "aws_internet_gateway" "gw1" {
  vpc_id = "${aws_vpc.vpc1.id}"

  tags = {
    Name = "my_gw"
  }
}


resource "aws_security_group" "sg_1" {
  name = "HTTP, HTTPS and SSH"
  vpc_id = aws_vpc.vpc1.id

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

resource "aws_instance" "instance1" {
  ami           = "ami-0c7217cdde317cfec"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet1.id
  vpc_security_group_ids = [ aws_security_group.sg_1.id ]
  associate_public_ip_address = true

  tags = {
    Name = "my_linux"
  }
}


resource "aws_instance" "instance2" {
  ami           = "ami-0a3c3a20c09d6f377"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet1.id
  vpc_security_group_ids = [ aws_security_group.sg_1.id ]
  associate_public_ip_address = true
  

  tags = {
    Name = "my_al"
  }
}

# resource "aws_instance" "instance3" {
#   ami           = "ami-0c7217cdde317cfec"
#   instance_type = "t2.micro"
#   subnet_id     = aws_subnet.subnet1.id
#   vpc_security_group_ids = resource aws_vpc" "virtual" {
  cidr_clock = "10.0.0.0/16"
  
}[ aws_security_group.sg_1.id ]
#   associate_public_ip_address = true

#   tags = {
#     Name = "my_linux3"
#   }
# }


resource "aws_instance" "instance2" {
  ami           = "ami-0c7217cdde317cfec"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet1.id
  vpc_security_group_ids = [ aws_security_group.sg_1.id ]
  associate_public_ip_address = true           

  tags = {
    Name = "my_al"
  }
}



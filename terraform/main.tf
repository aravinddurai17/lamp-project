provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "lamp_test_sg" {
  name = "lamp-test-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "lamp" {
  ami           = "ami-0ecb62995f68bb549"
  instance_type = var.instance_type
  key_name      = "lamp"

  security_groups = [aws_security_group.lamp_test_sg.name]

  tags = {
    Name = "LAMP-Server"
  }
}

output "ec2_public_ip" {
  value = aws_instance.lamp.public_ip
}

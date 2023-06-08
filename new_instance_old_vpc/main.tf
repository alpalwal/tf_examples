provider "aws" {
  region = var.properties.region
}

resource "aws_security_group" "project-iac-sg" {
  name = var.properties.secgroupname
  description = var.properties.secgroupname
  vpc_id = var.properties.vpc

  // To Allow SSH Transport
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = [var.properties.myIP]
  }

  // To Allow Port 80 Transport
  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = [var.properties.myIP]
  }
  // To Allow Port 443 Transport
  ingress {
    from_port = 443
    protocol = "tcp"
    to_port = 443
    cidr_blocks = [var.properties.myIP]
  }

  ingress {
    from_port = 8001
    protocol = "tcp"
    to_port = 8001
    cidr_blocks = [var.properties.myIP]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "project-iac" {
  ami = var.properties.ami
  instance_type = var.properties.itype
  subnet_id = var.properties.subnet
  associate_public_ip_address = var.properties.publicip
  key_name = var.properties.keyname

  
  vpc_security_group_ids = [
    aws_security_group.project-iac-sg.id
  ]
  root_block_device {
    delete_on_termination = true
    volume_size = 20
    volume_type = "gp2"
  }
  tags = {
    Name ="TariNode"
  }

  depends_on = [ aws_security_group.project-iac-sg ]
}


output "ec2instance" {
  value = aws_instance.project-iac.public_ip
}
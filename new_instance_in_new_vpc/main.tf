provider "aws" {
  region = var.properties.region
}

resource "aws_security_group" "vpn-sg" {
  name = var.properties.secgroupname
  description = var.properties.secgroupname
  vpc_id = aws_vpc.Main.id

  // To Allow SSH Transport
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = [var.properties.myIP1,var.properties.myIP2]
  }

  // To Allow Port 80 Transport
  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = [var.properties.myIP1,var.properties.myIP2]
  }
  // To Allow Port 443 Transport
  ingress {
    from_port = 443
    protocol = "tcp"
    to_port = 443
    cidr_blocks = [var.properties.myIP1,var.properties.myIP2]
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
  subnet_id = aws_subnet.publicsubnets.id
  associate_public_ip_address = var.properties.publicip
  key_name = var.properties.keyname
  user_data = var.properties.auth_token
  vpc_security_group_ids = [aws_security_group.vpn-sg.id]

  root_block_device {
    delete_on_termination = true
    volume_size = 20
    volume_type = "gp2"
  }
  tags = {
    Name ="Meraki vMX"
  }

  depends_on = [ aws_security_group.vpn-sg, aws_vpc.Main, aws_subnet.publicsubnets ]
}

output "ec2instance" {
  value = aws_instance.project-iac.public_ip
}

// Create the VPC
 resource "aws_vpc" "Main" {                # Creating VPC here
   cidr_block       = var.properties.main_vpc_cidr     # Defining the CIDR block use 10.0.0.0/24 for demo
   instance_tenancy = "default"
 }

 // Create Internet Gateway and attach it to VPC
 resource "aws_internet_gateway" "IGW" {    # Creating Internet Gateway
    vpc_id =  aws_vpc.Main.id               # vpc_id will be generated after we create VPC
 }

 // Create a Public Subnets.
 resource "aws_subnet" "publicsubnets" {    # Creating Public Subnets
   vpc_id =  aws_vpc.Main.id
   cidr_block = var.properties.public_subnets        # CIDR block of public subnets
 }
 
 // Create a Private Subnet                   # Creating Private Subnets
 resource "aws_subnet" "privatesubnets" {
   vpc_id =  aws_vpc.Main.id
   cidr_block = var.properties.private_subnets          # CIDR block of private subnets
 }

 // Route table for Public Subnet's
 resource "aws_route_table" "PublicRT" {    # Creating RT for Public Subnet
    vpc_id =  aws_vpc.Main.id
    route {
      cidr_block = "0.0.0.0/0"               # Traffic from Public Subnet reaches Internet via Internet Gateway
      gateway_id = aws_internet_gateway.IGW.id
    }
 }

 // Route table for Private Subnet's
 //# Creating RT for Private Subnet
 //# Traffic from Private Subnet reaches Internet via NAT Gateway
 resource "aws_route_table" "PrivateRT" {    
   vpc_id = aws_vpc.Main.id
   route {
   cidr_block = "0.0.0.0/0"             
   nat_gateway_id = aws_nat_gateway.NATgw.id
   }
 }

 // Route table Association with Public Subnet's
 resource "aws_route_table_association" "PublicRTassociation" {
    subnet_id = aws_subnet.publicsubnets.id
    route_table_id = aws_route_table.PublicRT.id
 }

 // Route table Association with Private Subnet's
 resource "aws_route_table_association" "PrivateRTassociation" {
    subnet_id = aws_subnet.privatesubnets.id
    route_table_id = aws_route_table.PrivateRT.id
 }

 resource "aws_eip" "nateIP" {
   vpc   = true
 }

//  Creating the NAT Gateway using subnet_id and allocation_id
 resource "aws_nat_gateway" "NATgw" {
   allocation_id = aws_eip.nateIP.id
   subnet_id = aws_subnet.publicsubnets.id
  }
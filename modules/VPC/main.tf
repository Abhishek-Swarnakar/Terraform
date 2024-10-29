
//VPC
resource "aws_vpc" "VPC" {
    cidr_block = var.VPC_CIDR

    tags = {
      Name = var.VPC_NAME
    }
  
}

//PUBLIS SUBNET
resource "aws_subnet" "PUBLIC_SUBNET" {
  count = length(var.PUBLIC_CIDR)

  vpc_id = aws_vpc.VPC.id
  cidr_block = var.PUBLIC_CIDR[count.index]
  availability_zone = var.PUBLIC_AZ[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = var.PUBLIC_SUBNET_NAME[count.index]
  }
}

//PRIVATE SUBNET

resource "aws_subnet" "PRIVATE_SUBNET" {
  count = length(var.PRIVATE_SUBNET_CIDR)

  vpc_id = aws_vpc.VPC.id
  cidr_block = var.PRIVATE_SUBNET_CIDR[count.index]
  availability_zone = var.PRIVATE_SUBNET_AZ[count.index]

  tags = {
    Name = var.PRIVATE_SUBNET_NAME[count.index]
  }
  
}

//INTERNET GATEWAY

resource "aws_internet_gateway" "IG" {
  vpc_id = aws_vpc.VPC.id

  tags = {
    Name = var.INTERNET_GATEWAY
  }
  
}

//PUBLIC ROUTE TABLE

resource "aws_route_table" "PUBLIC_ROUTE_TABLE" {
  count = length(var.PUBLIC_ROUTE_TABLE_NAME)

  vpc_id = aws_vpc.VPC.id
  route {
    cidr_block = var.PUBLIC_ROUTE_TABLE_CIDR
    gateway_id = aws_internet_gateway.IG.id
  }

  tags = {
    Name = var.PUBLIC_ROUTE_TABLE_NAME[count.index]
  }
  
}

resource "aws_route_table_association" "PUBLIC_ROUTE_TABLE" {
  count = length(aws_subnet.PUBLIC_SUBNET)

  subnet_id = aws_subnet.PUBLIC_SUBNET[count.index].id
  route_table_id = element(aws_route_table.PUBLIC_ROUTE_TABLE, count.index).id
  
}

//PRIVATE ROUTE TABLE

resource "aws_route_table" "PRIVATE_ROUTE_TABLE" {
  count = length(var.PRIVATE_ROUTE_TABLE_NAME)

  vpc_id = aws_vpc.VPC.id

  route {
    cidr_block = var.PRIVATE_ROUTE_TABLE_CIDR
    nat_gateway_id = aws_nat_gateway.NAT_GATEWAY.id
  }

  tags = {
    Name = var.PRIVATE_ROUTE_TABLE_NAME[count.index]
  }

  
}

resource "aws_route_table_association" "PRIVATE_ROUTE_TABLE" {
  count = length(var.PRIVATE_ROUTE_TABLE_NAME)

  subnet_id = aws_subnet.PRIVATE_SUBNET[count.index].id
  route_table_id = element(aws_route_table.PRIVATE_ROUTE_TABLE, count.index).id
  
}

//ELASTIC IP

resource "aws_eip" "EIP" {
  domain = "vpc"
  
}

//NAT GATEWAY

resource "aws_nat_gateway" "NAT_GATEWAY" {

  allocation_id = aws_eip.EIP.id
  subnet_id = aws_subnet.PUBLIC_SUBNET[0].id

  tags = {
    Name = var.NAT_GATEWAY
  }
   
  depends_on = [ aws_internet_gateway.IG ]

  
}


//OUTPUT OF VPC-ID & PUBLIC SUBNET IDs 

output "vpc_id" {
  value = aws_vpc.VPC.id
}

output "public_subnet_ids" {
  value = aws_subnet.PUBLIC_SUBNET.*.id
  
}

output "private_subnet_ids" {
  value = aws_subnet.PRIVATE_SUBNET.*.id
  
}

//==========================================================================================================================//

data "aws_key_pair" "example" {
  key_name = "LOGIN"
}

resource "aws_instance" "webserver1" {
    ami                    = "ami-0522ab6e1ddcc7055"
    instance_type          = "t2.micro"
    vpc_security_group_ids = [aws_security_group.bostanSg.id]
    subnet_id = aws_subnet.PUBLIC_SUBNET[0].id
    key_name = data.aws_key_pair.example.key_name
}

resource "aws_security_group" "bostanSg" {
  name   = "web"
  vpc_id = aws_vpc.VPC.id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "BOSTAN-SG"
  }
}


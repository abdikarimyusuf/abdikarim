resource "aws_vpc" "k8_vpc" {
    cidr_block =var.vpc_cidr
    tags = { Name ="${var.cluster_name}-vpc"}
  }

data "aws_availability_zones" "available" {}

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)
  vpc_id = aws_vpc.k8_vpc.id
  cidr_block = var.public_subnet_cidrs[count.index]
  map_public_ip_on_launch = true # If you set it to false OR don't declare at all, instances get only private IPs (internal to the VPC).
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = { Name = "${var.cluster_name}-public"}
}

resource "aws_subnet" "private" {
    count = length(var.private_subnet_cidrs)
    vpc_id = aws_vpc.k8_vpc.id
    cidr_block = var.private_subnet_cidrs[count.index]
    availability_zone = data.aws_availability_zones.available.names[count.index + 1]
    tags = {name = "${var.cluster_name}-private"}

  
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.k8_vpc.id
    tags = { Name ="${var.cluster_name}-internetgateway"}
    depends_on = [aws_vpc.k8_vpc]
  
}



resource "aws_route_table" "public" {
    vpc_id = aws_vpc.k8_vpc.id

    route  {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id 
    }
  
}

resource "aws_route_table_association" "public_ass" {
    count = length(var.public_subnet_cidrs)
    subnet_id = aws_subnet.public[count.index].id
    route_table_id = aws_route_table.public.id
    

  
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags = {
    Name = "${var.cluster_name}-nat-eip"
  }
}


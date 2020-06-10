



# Fetches all availability zones from aws
data "aws_availability_zones" "available" {}

####################
# VPC
####################
resource "aws_vpc" "rsrc01" {
    count = "${var.enable == "true" ? 1 : 0}"
    cidr_block = "${var.cidr_block}"

    tags = {
        Name = "ecs-vpc"
    }
}



#################
# SUBNETS
#################
resource "aws_subnet" "rsrc01_public" {
    count = "${var.enable == "true" ? var.num_subnet : 0}"
    vpc_id = "${aws_vpc.rsrc01.id}"
    cidr_block = "10.0.1${count.index}.0/24"#
    availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
    map_public_ip_on_launch = true

    tags = {
        Name = "public-ecs-subnet"
    }
  
}


resource "aws_subnet" "rsrc01_private" {
    count = "${var.enable == "true" ? var.num_subnet : 0}"
    vpc_id = "${aws_vpc.rsrc01.id}"
    cidr_block = "10.0.2${count.index}.0/24"
    availability_zone = "${data.aws_availability_zones.available.names[count.index]}"

    tags = {
        Name = "private-ecs-subnet"
    }
}


###########
# GATEWAYS #
###########
resource "aws_internet_gateway" "rsrc01" {

    count   = "${var.enable == "true" ? 1 : 0}"
    vpc_id  = "${aws_vpc.rsrc01.id}"

    tags = {
        Name = "ecs-internet-gateway",
        Service = "ecs"
    }

}


resource "aws_nat_gateway" "rsrc01" {
    count = "${var.enable == "true" ? var.num_subnet : 0}"
    allocation_id = "${aws_eip.rsrc01.*.id[count.index]}"
    subnet_id     = "${aws_subnet.rsrc01_public.*.id[count.index]}"

    tags = {
        Name = "ecs-nat-gateway",
        Service = "ecs"
    }

  
}



##########
# EIP     #
##########
resource "aws_eip" "rsrc01" {
    count = "${var.enable == "true" ? var.num_subnet : 0}"
    vpc     = true
    depends_on = [ "aws_internet_gateway.rsrc01" ]

    tags = {
        Name = "ecs-eip",
        Service = "ecs"
    }
  
}



###############
# ROUTE TABLES #
##############
resource "aws_route_table" "rsrc01_private" {
    count = "${var.enable == "true" ? var.num_subnet : 0}"
    vpc_id = "${aws_vpc.rsrc01.id}"
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${ aws_nat_gateway.rsrc01.*.id[count.index] }"
    }

    tags = {
        Name = "ecs-private-route-table"
        Service = "ecs"
    }
  
}


resource "aws_route_table" "rsrc01_public" {
    vpc_id = "${aws_vpc.rsrc01.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${ aws_internet_gateway.rsrc01.id }"
    }

    tags = {
        Name = "ecs-public-route-table"
        Service = "ecs"
    }
  
}


resource "aws_route_table_association" "rsrc01_private" {
    count = "${var.enable == "true" ? var.num_subnet : 0}"
    subnet_id = "${aws_subnet.rsrc01_private.*.id[count.index]}"
    route_table_id = "${aws_route_table.rsrc01_private.*.id[count.index]}"
  
}


resource "aws_route_table_association" "rsrc01_public" {
    count = "${var.enable == "true" ? var.num_subnet : 0}"
    subnet_id = "${aws_subnet.rsrc01_public.*.id[count.index]}"
    route_table_id = "${aws_route_table.rsrc01_public.id}"
  
}



###################
# SECURITY GROUPS  #
###################
resource "aws_security_group" "rsrc01_http" {
    name    = "http_security_group"
    vpc_id  = "${aws_vpc.rsrc01.id}"
    ingress {
        protocol    = "tcp"
        from_port   = 80
        to_port     = 80
        cidr_blocks = ["0.0.0.0/0"]
  }

    egress {
        from_port = 0
        to_port   = 0
        protocol  = "-1"
        cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "ecs_tasks" {
  name        = "ecs_security_group"
  description = "allow inbound access from the ALB only"
  vpc_id      = "${aws_vpc.rsrc01.id}"

  ingress {
    protocol        = "tcp"
    from_port       = "3000"
    to_port         = "3000"
    security_groups = ["${aws_security_group.rsrc01_http.id}"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}














  







  





resource "aws_s3_bucket" "licenta_bucket" {
    bucket="licentatestterraformbucket"
}
resource "aws_key_pair" "licenta_key_pair" {
    key_name=var.licenta_key_name
    public_key=file("${path.module}/test_key.pub")
}

resource "aws_vpc" "licenta_vpc" {
    cidr_block=var.licenta_vpc_cidr_block
}

resource "aws_security_group" "acces" {
    name="Porturile acceptate"
    description="Accepta acces pe porturile:${join(", ", var.ports)}"
    vpc_id=aws_vpc.licenta_vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "porturi" {
    for_each=var.ports
    security_group_id = aws_security_group.acces.id
    cidr_ipv4="0.0.0.0/0"
    from_port=tonumber(each.value)
    ip_protocol="tcp"
    to_port=tonumber(each.value)
}

resource "aws_vpc_security_group_egress_rule" "accepta_outbound" {
    security_group_id = aws_security_group.acces.id
    cidr_ipv4="0.0.0.0/0"
    ip_protocol="-1"
}

resource "aws_subnet" "licenta_subnet" {
    vpc_id=aws_vpc.licenta_vpc.id
    cidr_block=var.licenta_vpc_cidr_block
    map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "licenta_gateway" {
    vpc_id=aws_vpc.licenta_vpc.id
}

resource "aws_route_table" "licenta_public_route_table" {
    vpc_id=aws_vpc.licenta_vpc.id
}

resource "aws_route" "licenta_public_route" {
    route_table_id=aws_route_table.licenta_public_route_table.id
    destination_cidr_block="0.0.0.0/0"
    gateway_id=aws_internet_gateway.licenta_gateway.id
}

resource "aws_route_table_association" "licenta_association" {
  subnet_id=aws_subnet.licenta_subnet.id
  route_table_id=aws_route_table.licenta_public_route_table.id
}

resource "aws_instance" "licenta_VMRunner" {
    ami=var.licenta_ami
    instance_type=var.instance_type
    tags={
        Name=var.runner_name
        description=var.runner_desc
    }
    vpc_security_group_ids=[aws_security_group.acces.id]
    key_name=aws_key_pair.licenta_key_pair.key_name
    subnet_id=aws_subnet.licenta_subnet.id
}

resource "aws_instance" "licenta_VMapp" {
    ami=var.licenta_ami
    instance_type=var.instance_type
    tags={
        Name=var.app_name
        description=var.app_desc
    }
    vpc_security_group_ids=[aws_security_group.acces.id]
    key_name=aws_key_pair.licenta_key_pair.key_name
    subnet_id=aws_subnet.licenta_subnet.id
}
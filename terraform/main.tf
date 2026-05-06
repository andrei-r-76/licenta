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

resource "aws_security_group" "acces_ssh" {
    name="Accepta SSH"
    description="Accepta acces SSH (port 22)"
    vpc_id=aws_vpc.licenta_vpc.id
}

resource "aws_security_group" "acces_http" {
    name="Accepta HTTP"
    description="Accepta acces HTTP (port 80)"
    vpc_id=aws_vpc.licenta_vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "accepta_ssh" {
    security_group_id = aws_security_group.acces_ssh.id
    cidr_ipv4="0.0.0.0/0"
    from_port=22
    ip_protocol="tcp"
    to_port=22
}

resource "aws_vpc_security_group_egress_rule" "accepta_outbound" {
    security_group_id = aws_security_group.acces_ssh.id
    cidr_ipv4="0.0.0.0/0"
    ip_protocol="-1"
}

resource "aws_vpc_security_group_ingress_rule" "accepta_http" {
    security_group_id = aws_security_group.acces_http.id
    cidr_ipv4="0.0.0.0/0"
    from_port=80
    ip_protocol="tcp"
    to_port=80
}

resource "aws_vpc_security_group_ingress_rule" "accepta_9090" {
    security_group_id = aws_security_group.acces_http.id
    cidr_ipv4="0.0.0.0/0"
    from_port=9090
    ip_protocol="tcp"
    to_port=9090
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
    instance_type=var.runner_instance
    tags={
        Name=var.runner_name
        description=var.runner_desc
    }
    vpc_security_group_ids=[aws_security_group.acces_ssh.id]
    key_name=aws_key_pair.licenta_key_pair.key_name
    subnet_id=aws_subnet.licenta_subnet.id
}

resource "aws_instance" "licenta_VMapp" {
    ami=var.licenta_ami
    instance_type=var.licenta_instance_type
    tags={
        Name=var.app_name
        description=var.app_desc
    }
    vpc_security_group_ids=[aws_security_group.acces_ssh.id, aws_security_group.acces_http.id]
    key_name=aws_key_pair.licenta_key_pair.key_name
    subnet_id=aws_subnet.licenta_subnet.id
}
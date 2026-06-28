variable "licenta_key_name" {
    type=string
    default="test_key"
}
variable "licenta_vpc_cidr_block" {
    type=string
    default="192.168.0.0/16"
}
variable "licenta_ami" {
    type=string
    default="ami-080254318c2d8932f"
}
variable "runner_name" {
    type=string
    default="Runner VM"
}
variable "runner_desc" {
    type=string
    default="Creat cu terraform, va fi folosit ca si self hosted runner"
}
variable "app_name" {
    type=string
    default="App Container VM"
}
variable "app_desc" {
    type=string
    default="Creat cu terraform, va fi folosit pentru a rula aplicatia"
}
variable "instance_type" {
    type=string
    default="t3.small"
}
variable "ports" {
    type=set(string)
    default=["22", "80", "9090", "3000"]
}
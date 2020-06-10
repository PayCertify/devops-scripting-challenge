variable "fargate_cpu" {
    type = "string"
    default = "neglected-fargate-cpu"
}



variable "fargate_memory" {
    type = "string"
    default = "neglected-fargate-memory"
}


variable "internal_security_group" {
    type = "string"
    default = "neglected-internal-security-group"
  
}




variable "ecs_security_group" {
  type = "string"
  default = "neglected-ecs-security-group"
}



variable "public_subnet_id" {
    type = "list"
    default = []
}


variable "private_subnet_id" {
    type = "list"
    default = []
}

variable "vpc_id" {
    type = "string"
    default = "neglected-vpc-id"
}










variable "fargate_cpu" {
    type = "string"
    default = ""
}



variable "fargate_memory" {
    type = "string"
    default = ""
}


variable "internal_security_group" {
    type = "string"
    default = ""
  
}




variable "ecs_security_group" {
  type = "string"
  default = ""
}



variable "public_subnet_id" {
    type = "list"
}


variable "private_subnet_id" {
    type = "list"
}

variable "vpc_id" {
    type = "string"
}










provider "aws" {
  region                  = "us-west-1"
  shared_credentials_file = "/Users/smoloney/.aws/credentials"
  profile                 = "smoloney"
}


module "vpc"{
    source = "modules/vpc"

    enable = "true"
    cidr_block = "10.0.0.0/16"
    region = "us-west-1"
    num_subnet = 2

}



module "ecs" {

  source = "modules/ecs"
  vpc_id        = "${module.vpc.vpc_id}"
  fargate_cpu   = "256"
  fargate_memory = "512"
  public_subnet_id = "${module.vpc.public_subnet_id}"
  private_subnet_id = "${module.vpc.private_subnet_id}"
  internal_security_group = "${module.vpc.rsrc01_internal_id}"
  ecs_security_group      = "${module.vpc.ecs_security_group}"
  
  

}
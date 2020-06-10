###############
# ECS CLUSTER  #
##############
resource "aws_ecs_cluster" "application" {
    name = "ecs-cluster"

    tags = {
        Name = "ecs-application-cluster"
    }
  
}



#############
# ECS TASK   #
#############
resource "aws_ecs_task_definition" "app" {

    family                      = "app"
    network_mode                = "awsvpc"
    requires_compatibilities    = [ "FARGATE" ]
    cpu                         = "${var.fargate_cpu}"
    memory                      = "${var.fargate_memory}"
    

    container_definitions = <<EOF
    [
        {
            "cpu": 252,
            "memory": 512,
            "name": "app",
            "networkMode": "awsvpc",
            "image": "seanmoloney121/devops-helloworld:latest",
            "portMappings": [
                 {
                    "containerPort": 3000,
                    "hostPort": 3000
                 }
            ]


        }
    ]
    EOF


    tags = {
        Name = "app-task-definition",
        Cluster = "application"
    }
  
}


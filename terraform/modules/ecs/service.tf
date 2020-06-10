##############
# ECS SERVICE #
#############
resource "aws_ecs_service" "application" {

    name                = "ecs-service"
    cluster             = "${aws_ecs_cluster.application.id}"
    task_definition     = "${aws_ecs_task_definition.app.arn}"
    desired_count       = 1
    launch_type         = "FARGATE"


    network_configuration {
        security_groups = ["${var.ecs_security_group}"]
        subnets         = [ "${var.private_subnet_id}" ]
    }

    load_balancer {
        target_group_arn = "${aws_alb_target_group.app.id}"
        container_name = "app"
        container_port = "3000"
    }

    depends_on = [
    "aws_alb_listener.front_end",
    ]

  
}

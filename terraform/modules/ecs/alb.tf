##########
# ALB     #
#########


resource "aws_alb" "main" {
  name            = "tf-ecs-chat"
  subnets         = [ "${var.public_subnet_id}" ]
  security_groups = ["${var.internal_security_group}"]

  tags = {
    Name = "main",
    service = "ecs",

  }
}


resource "aws_alb_target_group" "app" {
  name        = "tf-ecs-chat"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = "${var.vpc_id}"
  target_type = "ip"

  tags = {
    Name = "app-target-group",
    service = "ecs",

  }
}


# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "front_end" {
  load_balancer_arn = "${aws_alb.main.id}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.app.id}"
    type             = "forward"
  }
}


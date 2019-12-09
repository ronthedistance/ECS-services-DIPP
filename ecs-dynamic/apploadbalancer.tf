## ALB
resource "aws_alb" "seniorDesignProject2_alb" {
  name            = "SeniorDesignProject2ALB"
  subnets         = ["${aws_subnet.seniorDesignProject2-public-1.id}", "${aws_subnet.seniorDesignProject2-public-2.id}", "${aws_subnet.seniorDesignProject2-public-3.id}"]
  security_groups = ["${aws_security_group.lb_sg.id}"]
  enable_http2    = "true"
  idle_timeout    = 600
}

output "alb_output" {
  value = "${aws_alb.seniorDesignProject2_alb.dns_name}"
}

resource "aws_alb_listener" "front_end" {
  load_balancer_arn = "${aws_alb.seniorDesignProject2_alb.id}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.apache2.id}"
    type             = "forward"
  }
}

resource "aws_alb_target_group" "apache2" {
  name       = "apache2"
  port       = 80
  protocol   = "HTTP"
  vpc_id     = "${aws_vpc.seniorDesignProject2-tf.id}"
  depends_on = ["aws_alb.seniorDesignProject2_alb"]

  stickiness {
    type            = "lb_cookie"
    cookie_duration = 86400
  }

  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    matcher             = "200,301,302"
  }
}

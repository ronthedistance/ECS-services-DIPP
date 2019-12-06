# apache2 Service
resource "aws_ecs_service" "apache2" {
  name            = "SeniorDesignProject2"
  cluster         = "${aws_ecs_cluster.demo.id}"
  task_definition = "${aws_ecs_task_definition.apache2.arn}"
  desired_count   = 4
  iam_role        = "${aws_iam_role.ecs-service-role.arn}"
  depends_on      = ["aws_iam_role_policy_attachment.ecs-service-attach"]

  load_balancer {
    target_group_arn = "${aws_alb_target_group.apache2.id}"
    container_name   = "apache2"
    container_port   = "80"
  }

  lifecycle {
    ignore_changes = ["task_definition"]
  }
}

resource "aws_ecs_task_definition" "apache2" {
  family = "apache2"
#use this resource to define the actual containers within the cluster
#we can use the "image" value to specify any dockerfile 
  container_definitions = <<EOF
[
  {
    "portMappings": [
      {
        "hostPort": 0,
        "protocol": "tcp",
        "containerPort": 80
      }
    ],
    "cpu": 256,
    "memory": 300,
    "image": "464696867679.dkr.ecr.us-west-1.amazonaws.com/terrawinchell:pleasework",
    "essential": true,
    "name": "apache2",
    "logConfiguration": {
    "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs-demo/apache2",
        "awslogs-region": "us-west-2",
        "awslogs-stream-prefix": "ecs"
      }
    }
  }
]
EOF
}

resource "aws_cloudwatch_log_group" "apache2" {
  name = "/ecs-demo/apache2"
}
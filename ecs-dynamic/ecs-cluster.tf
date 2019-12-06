# ECS cluster
resource "aws_ecs_cluster" "demo" {
  name = "demo"
}
#initialize an ecs_cluster resource to be further referred to in terraform as "demo"
#note that the declaration "demo" is different from name="demo"
#the latter refers to the name of the cluster in AWS. name ="examplecluster" would change the name in AWS console, but not in terraform
#Compute
resource "aws_autoscaling_group" "demo-cluster" {
  name                      = "demo-cluster"
  vpc_zone_identifier       = ["${aws_subnet.demo-public-1.id}", "${aws_subnet.demo-public-2.id}", "${aws_subnet.demo-public-3.id}"]
  #this portion specifies the portion of the VPC which will be used in the actual cluster compute resources
  min_size                  = "2"
  #minimum number of containers within the cluster
  max_size                  = "10"
  #maximum number of containers to spin up within the cluster
  desired_capacity          = "2"
  #set a number you'd like the resource to be around during runtime
  launch_configuration      = "${aws_launch_configuration.demo-cluster-lc.name}"
  #specify launch configs for the cluster as a whole. specified later in the ecs-cluster.tf file 
  health_check_grace_period = 120
  default_cooldown          = 30
  termination_policies      = ["OldestInstance"]

  tag {
    key                 = "Name"
    value               = "ECS-demo"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "demo-cluster" {
  name                      = "demo-ecs-auto-scaling"
  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = "90"
  adjustment_type           = "ChangeInCapacity"
  autoscaling_group_name    = "${aws_autoscaling_group.demo-cluster.name}"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 40.0
  }
}

resource "aws_launch_configuration" "demo-cluster-lc" {
  name_prefix     = "demo-cluster-lc"
  security_groups = ["${aws_security_group.instance_sg.id}"]

  # key_name                    = "${aws_key_pair.demodev.key_name}"
  image_id                    = "${data.aws_ami.latest_ecs.id}"
  instance_type               = "${var.instance_type}"
  iam_instance_profile        = "${aws_iam_instance_profile.ecs-ec2-role.id}"
  user_data                   = "${data.template_file.ecs-cluster.rendered}"
  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }
}
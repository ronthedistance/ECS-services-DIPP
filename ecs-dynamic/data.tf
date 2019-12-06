# Get the latest ECS AMI
data "aws_ami" "latest_ecs" {
  most_recent = true

  filter {
    name   = "name"
    values = ["*amazon-ecs-optimized"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
#HVM virtualization refers to Hardware Virtual Machines, as opposed to the other amazon virtualization type: "PV" or paravirtualization
#paravirtualized guests are potentially faster for things like storage or network operations, as they don't have to emulate network/disk hardware
  owners = ["591542846629"] # AWS
}
# User data for ECS cluster
# User data in an ECS cluster is similar to user data within ec2 instances
#these files are run as soon as the cluster or ec2 instance 
data "template_file" "ecs-cluster" {
  template = "${file("ecs-cluster.tpl.txt")}"
#this is a file that we're specifying. If we need certain things to run on startup, we can edit this file 
  vars = {
    ecs_cluster = "${aws_ecs_cluster.demo.name}"
  }
}
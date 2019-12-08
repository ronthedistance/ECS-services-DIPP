# ECS-services-DIPP

The following terraform files can be used to set an nginx serving ecs-cluster.

At the time of updating this README, it reads a container from an ECR called terrawinchell:pleasework.
We realize there is a separate created ECR in this repository, but in order to create the ECS, there needs to be an image in a repository to pull already.
But if the terraform is used to create the repository, how were we meant to push an image to ECR for use in the ECS?
Thus, there is one made manually, and one terraformed via the code here.

### Requirements:
- aws configure: used to set access key, secret key, and default availability zone.
- terraform binaries
- after using aws configure, it will ask for the access key to your management console. it is best practice that instead of using the one for the console itself that you create an IAM user, with it's own security policies to follow the principle of least privilege

### Implementation:
- clone the git repository
- change directory to terraform files
- terraform validate to syntax check ( depending on which version of terraform you are running, you may get deprecated syntax warnings )
- terraform init to initialize the aws plugin which is used in this terraform
- terraform plan to see which resources will be created upon running the file
- terraform apply then enter "Yes" at the prompt, this will spin up the infrastructure set by you the .tf files

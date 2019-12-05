# ECS-services-DIPP
 
The following terraform files can be used to set an nginx serving ecs-cluster.
At the current time, it simply pulls the base nginx:latest image. 

### Requirements:
aws configure: used to set access key, secret key, and default availability zone.
terraform binaries


### Implementation:
- clone the git repository
- change directory to terraform files
- terraform validate to syntax check ( depending on which version of terraform you are running, you may get deprecated syntax warnings )
- terraform init to initialize the aws plugin which is used in this terraform
- terraform plan to see which resources will be created upon running the file
- terraform apply then enter "Yes" at the prompt, this will spin up the infrastructure set by you the .tf 

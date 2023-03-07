### Provide these variable here or on coommand line to override the default
### terraform apply \
#        -var access_key=... \
#        -var secret_key=... \
#         ...
##########################################################################

variable "access_key" {
  description = "aws access key"
  default     = "YOUR_ACCESS_KEYS_GOES_HERE"
}
variable "secret_key" {
  description = "aws secret key"
  default     = "YOUR_SECCRET_KEYS_GOES_HERE"
}

variable "region" {
  description = "aws region"
  default     = "us-east-1"
}

variable "ami" {
  description = "EC2 AMI"
  default     = "ami-0c9978668f8d55984"
}
variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "ssh_rsa_pub" {
  description = "ssh public key for access to EC2 instance"
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCsYsEJQ+dJPIIOY0KY4bfYisHsj1EfN2NCMzcG5QLcPjCZdGBQj5jRmCxrs0EzE/fuJsLUPVfI7C2rHusJiFI4OhME+QBL+R+Q9jFvE5YTjeu45nmR3p50j0QmSonPu/4y1G5dG6GijAM5hJAb0OSf1p8QZ6laH24IJEbNL5o0NVXHk26B1bwgfSy+ins7cWQhL8h2vviYCKi3FufpU8867QdWoz+An2e5hpXvx51J88/n13X8W4abKR5XfrNTR/ne1RrYfGkQs2BUbNtXay4QYvrYjbT0eZRIQNSVXk486Bf+dSD7yIIjblBfPuoa9deQjWBwv3mulzx5ezDbES/GvShBbod7YKAgoNY7gV9qdrXY+ry77ZFZ3SAq7JFfgHeULUjBmHkcIeAXXmfwhI8ZOnLV1LZhsiXOEe4c6DxkaNfWX/dWOQejKReutgYgpGxnaKAwDGadnMnMcfvzP0eItaG4P5Um9ISXXFS4FZPJHG+B9DW9NMWg+eFXdgqi3r0= ec2-user@ip-172-31-5-60.ec2.internal"
}

variable "vpc_id" {
  description = "vpc id for deploy EC2"
  default     = "vpc-0acfe1a535844522e"
}

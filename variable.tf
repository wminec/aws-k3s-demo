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
  default     = "YOUR_SSH_PUBLIC_KEY"
}

variable "vpc_id" {
  description = "vpc id for deploy EC2"
  default     = "vpc-0acfe1a535844522e"
}

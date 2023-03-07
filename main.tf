# ---------------------------------------------------------------------------------------------
# Deploy an EC2 instance and then invoke a provisioner to execute ansible playbook
# terraform: Infrastructure deployment
# -- network: 1 - vpc, subnet, gateway, routing table, security group
# -- instance: 1 ec2, 1 eip
# -- provisioner: ansible-playbook (k3s and consul install)
#
# - Author: Rajendra Adhikari
# - Date: 05-05-2019
# ---------------------------------------------------------------------------------------------


# ---------------------------------------------------------------------------------------------
# Define a provider access and import your public key
# ---------------------------------------------------------------------------------------------
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region     = var.region
#  access_key = var.access_key
#  secret_key = var.secret_key
}

resource "aws_key_pair" "deployer" {
  key_name   = "k3s-setup-key"
  public_key = var.ssh_rsa_pub
}

# ---------------------------------------------------------------------------------------------
# Deploy an EC2 instance
# ---------------------------------------------------------------------------------------------
resource "aws_instance" "k3s-master-node" {
  ami             = var.ami
  instance_type   = var.instance_type
#  key_name        = var.key_pair
  key_name        = aws_key_pair.deployer.key_name
  security_groups = [aws_security_group.k3s-sg.name]
  #  subnet_id = "${aws_subnet.k3s-subnet.id}"

  connection {
    host = aws_instance.k3s-master-node.private_ip
    #host = aws_instance.k3s-master-node.public_ip
    user = "ec2-user"
#    private_key = var.key_pair
    private_key = "${file("/home/ec2-user/.ssh/id_rsa")}"
#    agent = true
  }

  provisioner "local-exec" {
    command = "cp -R ./inventory/sample inventory/my-cluster && printf '[master]\n${aws_instance.k3s-master-node.private_ip}\n\n[k3s_cluster:children]\nmaster' > ./inventory/my-cluster/hosts.ini && sed -i 's/ansible_user: debian/ansible_user: ec2-user/g' ./inventory/my-cluster/group_vars/all.yml"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo dnf update -y",
      "sudo dnf install python -y",
      "sudo dnf clean all",
    ]
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i ./inventory/my-cluster/hosts.ini site.yml"
  }

  tags = {
    Name = "sye-k3s-master-node"
  }
}

## ---------------------------------------------------------------------------------------------
## Networking: Define the VPC, subnet, internet gateway. routing table and eip for ec2 instance
## ---------------------------------------------------------------------------------------------
#resource "aws_vpc" "signalpath" {
#  cidr_block = "10.0.0.0/16"
#  enable_dns_hostnames = true
#  enable_dns_support = true
#  tags {
#    Name = "sye-assignment"
#  }
#}
#
#resource "aws_subnet" "k3s-subnet" {
#  cidr_block = "${cidrsubnet(aws_vpc.signalpath.cidr_block, 3, 1}"
#  vpc_id = "${aws_vpc.signalpath.id}"
#  availability_zone = "${var.region}a"
#}
#
#resource "aws_internet_gateway" "k3s-gateway" {
#  vpc_id = "${aws_vpc.signalpath.id}"
#}
#
#
#resource "aws_route_table" "route-table-signalpath" {
#  vpc_id = "${aws_vpc.signalpath.id}"
#
#route {
#    cidr_block = "0.0.0.0/0"
#    gateway_id = "${aws_internet_gateway.k3s-gateway.id}"
#  }
#}
#
#resource "aws_route_table_association" "subnet-association" {
#  subnet_id      = "${aws_subnet.k3s-subnet.id}"
#  route_table_id = "${aws_route_table.route-table-signalpath.id}"
#}
#
#resource "aws_eip" "k3s-master-ip" {
#  instance = "${aws_instance.k3s-master-node.id}"
#}

# ---------------------------------------------------------------------------------------------
# Security groups: Allow all egress traffic, only allow ssh, http(s) ingress traffic on the VPC
# ---------------------------------------------------------------------------------------------

resource "aws_security_group" "k3s-sg" {
  name   = "k3s-ssh-sg"
  vpc_id = var.vpc_id
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
  }
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
  }
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}


# ---------------------------------------------------------------------------------------------
# Run Provisioner: pretasks and invoke ansible playbook for k3s and consul deployment
# ---------------------------------------------------------------------------------------------
#resource "aws_instance" "connection_ec2" {
#  ami           = "${var.ami}"
#  instance_type = "${var.instance_type}"
#  key_name = "${aws_key_pair.deployer.key_name}"
#  security_groups = ["${aws_security_group.k3s-sg.id}"]
#
#  connection {
#    host = aws_instance.k3s-master-node.private_ip
#    user = "ec2-user"
#    private_key = var.key_pair
#  }
#
#  provisioner "local-exec" {
#    command = "printf '[k3sdemo]\n${aws_instance.k3s-master-node.private_ip}' > ./inventory/hosts"
#  }
#}

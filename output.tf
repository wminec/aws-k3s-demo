# -----------------------------------------------------------------------------------------------------
# Dump all your terrafom output here
#
# - Author: Rajendra Adhikari
# - Date: 05-05-2019
# -----------------------------------------------------------------------------------------------------

output "instance_id" {
  description = "ID of the EC2 instance"
#  value = aws_eip.k3s-master-ip.public_ip
  value = aws_instance.k3s-master-node.id
}

output "instance_public_ip" {
  #value = "UI url: http://${aws_eip.k3s-master-ip.public_ip}"
  value = aws_instance.k3s-master-node.public_ip
}

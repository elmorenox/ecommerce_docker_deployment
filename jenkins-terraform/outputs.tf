# outputs.tf
output "controller_public_ip" {
  value = aws_instance.jenkins_controller.public_ip
}

output "node_public_ip" {
  value = aws_instance.jenkins_node.public_ip
}
# instances.tf
resource "aws_instance" "jenkins_controller" {
  ami           = "ami-0c7217cdde317cfec"  # Ubuntu 22.04 LTS AMI ID for us-east-1
  instance_type = "t2.micro"
  key_name      = var.key_name
  subnet_id     = aws_subnet.jenkins_subnet.id

  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]

  user_data = file("scripts/controller-userdata.sh")

  tags = {
    Name = "jenkins-controller"
  }
}

resource "aws_instance" "jenkins_node" {
  ami           = "ami-0c7217cdde317cfec"  # Ubuntu 22.04 LTS AMI ID for us-east-1
  instance_type = "t2.medium"
  key_name      = var.key_name
  subnet_id     = aws_subnet.jenkins_subnet.id

  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]

  user_data = file("scripts/node-userdata.sh")

  tags = {
    Name = "jenkins-node"
  }
}
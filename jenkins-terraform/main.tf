provider "aws" {
  region = "us-east-1"
}

# VPC Resources
resource "aws_vpc" "jenkins_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "jenkins-vpc"
  }
}

resource "aws_subnet" "jenkins_subnet" {
  vpc_id                  = aws_vpc.jenkins_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "jenkins-subnet"
  }
}

resource "aws_internet_gateway" "jenkins_igw" {
  vpc_id = aws_vpc.jenkins_vpc.id

  tags = {
    Name = "jenkins-igw"
  }
}

resource "aws_route_table" "jenkins_rt" {
  vpc_id = aws_vpc.jenkins_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.jenkins_igw.id
  }

  tags = {
    Name = "jenkins-rt"
  }
}

resource "aws_route_table_association" "jenkins_rta" {
  subnet_id      = aws_subnet.jenkins_subnet.id
  route_table_id = aws_route_table.jenkins_rt.id
}

# Security Group
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-sg"
  description = "Security group for Jenkins instances"
  vpc_id      = aws_vpc.jenkins_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 50000
    to_port     = 50000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "jenkins-sg"
  }
}

# EC2 Instances
resource "aws_instance" "jenkins_node" {
  ami           = "ami-0c7217cdde317cfec"  # Ubuntu 22.04 LTS AMI ID for us-east-1
  instance_type = "t2.medium"
  key_name      = var.key_name
  subnet_id     = aws_subnet.jenkins_subnet.id
  
  # Set a static private IP address within the subnet's range
  private_ip    = "10.0.1.10"  # Changed from 10.0.1.10 to be within the subnet range

  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]

  user_data = file("scripts/node-userdata.sh")

  tags = {
    Name = "Jenkins-Node"
  }
}

resource "aws_instance" "jenkins_controller" {
  ami           = "ami-0c7217cdde317cfec"  # Ubuntu 22.04 LTS AMI ID for us-east-1
  instance_type = "t2.micro"
  key_name      = var.key_name
  subnet_id     = aws_subnet.jenkins_subnet.id

  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]

  # Use templatefile instead of file to inject variables into the user data script
  user_data = templatefile("${path.module}/scripts/controller-userdata.sh", {
    ssh_private_key     = file(var.ssh_private_key_file),
    docker_hub_username = var.docker_hub_username,
    docker_hub_password = var.docker_hub_password,
    jenkins_node_ip     = aws_instance.jenkins_node.private_ip,
    codon_pubkey        = file(var.codon_pubkey)  # Read the file content, not just the path
  })

  depends_on = [aws_instance.jenkins_node]

  tags = {
    Name = "Jenkins"
  }
}
# Outputs
output "controller_public_ip" {
  value = aws_instance.jenkins_controller.public_ip
}

output "node_public_ip" {
  value = aws_instance.jenkins_node.public_ip
}
# variables.tf
variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
}

variable "ssh_private_key_file" {
  description = "Path to private SSH key file"
  type        = string
}

variable "docker_hub_username" {
  description = "Docker Hub username for Jenkins credentials"
  type        = string
  sensitive   = true
}

variable "docker_hub_password" {
  description = "Docker Hub password for Jenkins credentials"
  type        = string
  sensitive   = true
}

variable "codon_pubkey" {
  description = "Gives access to codon engine"
  type        = string
  sensitive   = true
}

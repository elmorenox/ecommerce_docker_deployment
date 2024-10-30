variable "db_name" {
  description = "Database name"
  type        = string
  default = "e-commerce"
}

variable "db_username" {
  description = "Database username"
  type        = string
  default = "user"
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
  default = "password"
}
variable "db_name" {
  description = "Database name"
  type        = string
  default = "ecommerce"
}

variable "db_username" {
  description = "Database username"
  type        = string
  default = "userdb"
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
  default = "abcd1234"
}

variable "key_name" {
  description = "Name of the EC2 key pair"
  type        = string
  default = "LuisMorenoWorkloads"
}
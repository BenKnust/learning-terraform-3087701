variable "instance_type" {
  description = "Type of EC2 instance to provision"
  default     = "t3.nano"
}

variable "db-username" {
  type = string
}
variable "db-password" {
  type = string
}
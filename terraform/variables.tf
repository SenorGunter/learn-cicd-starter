


variable "aws_region" {}
variable "aws_account_id" {}
variable "ecr_repository" {}
variable "ec2_instance_type" {
  default = "t3.micro"
}
variable "ami_id" {}
variable "ec2_key_name" {}
variable "security_group_id" {}
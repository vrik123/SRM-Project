variable "keyname"{}
variable "vpcid"{}
variable "tar_ami_id"{}
variable "instance_count" {}
variable "iam_policy_arn"{
	default = ["arn:aws:iam::aws:policy/AdministratorAccess"]
}

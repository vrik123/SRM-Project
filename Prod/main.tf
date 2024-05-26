provider "aws" {
  region     = "us-east-1"
  access_key  = ""
  secret_key  = ""
}

module "AnsibleControl"{
  source  = ".//../Modules/AnsibleControl"
  keyname = "${var.keyname}"
  vpcid  = "${var.vpcid}"
  ansi_ami_id  = "${var.ansi_ami_id}"
}

module "Jenkinsserver" {
  source  = ".//../Modules/Jenkinsserver"
  keyname = "${var.keyname}"
  vpcid  = "${var.vpcid}"
  ami_id  = "${var.ami_id}"
}

module "TargetServer"{
  source  = ".//../Modules/TargetServer"
  keyname = "${var.keyname}"
  vpcid  = "${var.vpcid}"
  tar_ami_id  = "${var.tar_ami_id}"
  instance_count="${var.instance_count}"
}

module "RDS"{
   source  = ".//../Modules/RDS"
}
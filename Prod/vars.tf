variable "keyname"{
default ="Jenkins"
}
variable "vpcid"{
default ="vpc-014fbb6547d6bdbe3"
}
variable "ami_id"{
default="ami-0e001c9271cf7f3b9"
}
variable "web_ami_id"{
default="ami-04b70fa74e45c3917"
}

variable "tar_ami_id"{
	default="ami-04b70fa74e45c3917"
}
variable "instance_count" {
  default = "1"
}
variable "ansi_ami_id"{
default="ami-04b70fa74e45c3917"	
}
resource "aws_instance" "ansiserver" {
  ami           = "${var.ansi_ami_id}"
  instance_type = "t2.micro"
  key_name = "${var.keyname}"
  vpc_security_group_ids = [aws_security_group.ansiserver.id]
  iam_instance_profile = "${aws_iam_instance_profile.ansi_profile.id}"
  user_data = file("E:/Terraform/files/install_ansible.sh")
  associate_public_ip_address = true
  tags = {
    Name = "Ansible Controller"
  }
}
resource "aws_iam_role" "ansi_role" {
  name = "ansi_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "role-attach" {
  role       = aws_iam_role.ansi_role.name
  count      = "${length(var.iam_policy_arn)}"
  policy_arn = "${var.iam_policy_arn[count.index]}"
}
resource "aws_iam_instance_profile" "ansi_profile"{
  name = "ansi_profile"
  role = "${aws_iam_role.ansi_role.name}"
}
resource "aws_security_group" "ansiserver" {
  name        = "ansiserver"
  description = "Allow SSH and Jenkins inbound traffic"
  vpc_id      = "${var.vpcid}"
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
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  }
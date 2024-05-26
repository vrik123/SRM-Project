resource "aws_instance" "web" {
  ami           = "${var.ami_id}"
  instance_type = "t2.medium"
  key_name = "${var.keyname}"
  vpc_security_group_ids = [aws_security_group.sg_allow_ssh_jenkins.id]
  iam_instance_profile = "${aws_iam_instance_profile.jenkins_profile.id}"
  user_data = file("E:/Terraform/files/install_jenkins.sh")
  associate_public_ip_address = true
  tags = {
    Name = "Jenkins"
  }
}
resource "aws_iam_role" "jenkins_role" {
  name = "jenkins_role"

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
  role       = aws_iam_role.jenkins_role.name
  count      = "${length(var.iam_policy_arn)}"
  policy_arn = "${var.iam_policy_arn[count.index]}"
}
resource "aws_iam_instance_profile" "jenkins_profile"{
  name = "jenkins_profile"
  role = "${aws_iam_role.jenkins_role.name}"
}
resource "aws_security_group" "sg_allow_ssh_jenkins" {
  name        = "allow_ssh_jenkins"
  description = "Allow SSH and Jenkins inbound traffic"
  vpc_id      = "${var.vpcid}"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  }
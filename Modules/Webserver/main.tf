resource "aws_instance" "webserver" {
  ami           = "${var.web_ami_id}"
  instance_type = "t2.micro"
  key_name = "${var.keyname}"
  vpc_security_group_ids = [aws_security_group.webserver.id]
  iam_instance_profile = "${aws_iam_instance_profile.web_profile.id}"
  user_data = file("E:/Terraform/files/php_apache2.sh")
  associate_public_ip_address = true
  tags = {
    Name = "test"
  }
}
resource "aws_iam_role" "web_role" {
  name = "web_role"

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
  role       = aws_iam_role.web_role.name
  count      = "${length(var.iam_policy_arn)}"
  policy_arn = "${var.iam_policy_arn[count.index]}"
}
resource "aws_iam_instance_profile" "web_profile"{
  name = "web_profile"
  role = "${aws_iam_role.web_role.name}"
}
resource "aws_security_group" "webserver" {
  name        = "webserver"
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
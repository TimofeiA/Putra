provider "aws" {

}

/*resource "aws_instance" "example" {
  ami           = "ami-0cb91c7de36eed2cb"
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = <<-EOF
  #!/bin/bash
  echo "Hello World" > index.html
  nohup busybox httpd -f -p ${var.server_port} &
  EOF

  user_data_replace_on_change = true

  tags = {
    Name = "my-bubunty"

  }

}
*/

# let's create an configuration for an auto scaling group instead of ec2 instance which is commented above:

resource "aws_launch_configuration" "example" {
  image_id        = "ami-0cb91c7de36eed2cb"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.instance.id]

  user_data = <<-EOF
  #!/bin/bash
  echo "Hello World" > index.html
  nohup busybox httpd -f -p ${var.server_port} &
  EOF

  # Required with an autoscaling group:
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "instance" {
  name = "web"

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_autoscaling_group" "example" {
  launch_configuration = aws_launch_configuration.example.name
  min_size             = 1
  max_size             = 2

}

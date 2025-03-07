provider "aws" {

}

resource "aws_instance" "example" {
  ami           = "ami-0cb91c7de36eed2cb"
  instance_type = "t2.micro"

  tags = {
    Name = "my-bubunty"

  }

}



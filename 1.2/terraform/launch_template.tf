provider "aws" {
    profile = "default"
    region = "us-west-2"
}

resource "aws_instance" "instance_genesis" {
  ami           = "ami-03d5c68bab01f3496" # us-west-2
  instance_type = "t2.micro"
  key_name = "ansible-docker"
  tags = {
    Name = "genesis"
  }

}
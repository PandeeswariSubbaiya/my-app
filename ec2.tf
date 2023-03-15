resource "aws_instance" "myec2-NorthVirgina" {
  count                  = 2
  ami                    = "ami-0557a15b87f6559cf"
  instance_type          = "t2.micro"
  availability_zone = "us-east-1a"
  //vpc_security_group_ids = [aws_security_group.allow_tls.id]
  security_groups = ["security_jenkins_port"]
  key_name = "North_Virginia_Keypair"

  tags = {
    name = "testec2"
  }
  connection {
    type = "ssh"
    host = self.public_ip
    user = "ubuntu"
    private_key = file("/root/.ssh/id_rsa")
}
}  
  //Security group creation and whitelisting the ip
//resource "aws_security_group" "allow_tls" {
resource "aws_security_group" "security_jenkins_port" {
  name        = "security_jenkins_port"
  //name = "terraform-sg-Nvirginia"

  ingress {
    description = "Allow port 22 - inbound"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow port 8080 - inbound"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

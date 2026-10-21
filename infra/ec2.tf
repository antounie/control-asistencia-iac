resource "aws_key_pair" "lab" {
  key_name   = "${var.proyecto}-key"
  public_key = file(pathexpand(var.ruta_clave_publica))
}

data "aws_ami" "ubuntu" {
    most_recent = true
    owners = ["099720109477"]

    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
    }
}
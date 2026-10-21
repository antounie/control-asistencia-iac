# ---------- Imagen oficial de Ubuntu 24.04 ----------
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

# ---------- Par de claves SSH ----------
resource "aws_key_pair" "lab" {
  key_name   = "${var.proyecto}-key"
  public_key = file(pathexpand(var.ruta_clave_publica))
}

# ---------- IP elasticas (se crean antes que las instancias) ----------
resource "aws_eip" "backend" {
  domain = "vpc"

  tags = {
    Name = "${var.proyecto}-backend-eip"
  }
}

resource "aws_eip" "frontend" {
  domain = "vpc"

  tags = {
    Name = "${var.proyecto}-frontend-eip"
  }
}

# ---------- Instancia BACKEND ----------
resource "aws_instance" "backend" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.lab.key_name
  vpc_security_group_ids = [aws_security_group.backend.id]

  user_data_replace_on_change = true
  user_data = replace(templatefile("${path.module}/scripts/backend.sh.tftpl", {
    repo_url    = var.repo_url
    backend_ip  = aws_eip.backend.public_ip
    frontend_ip = aws_eip.frontend.public_ip
  }), "\r", "")

  root_block_device {
    volume_size = 10
    volume_type = "gp3"
    encrypted   = true
  }

  metadata_options {
    http_tokens = "required"
  }

  lifecycle {
    ignore_changes = [ami]
  }

  tags = {
    Name = "${var.proyecto}-backend"
  }
}

# ---------- Instancia FRONTEND ----------
resource "aws_instance" "frontend" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.lab.key_name
  vpc_security_group_ids = [aws_security_group.frontend.id]

  user_data_replace_on_change = true
  user_data = replace(templatefile("${path.module}/scripts/frontend.sh.tftpl", {
    repo_url    = var.repo_url
    backend_ip  = aws_eip.backend.public_ip
    frontend_ip = aws_eip.frontend.public_ip
  }), "\r", "")

  root_block_device {
    volume_size = 10
    volume_type = "gp3"
    encrypted   = true
  }

  metadata_options {
    http_tokens = "required"
  }

  lifecycle {
    ignore_changes = [ami]
  }

  tags = {
    Name = "${var.proyecto}-frontend"
  }
}

# ---------- Asociar cada IP elastica a su instancia ----------
resource "aws_eip_association" "backend" {
  instance_id   = aws_instance.backend.id
  allocation_id = aws_eip.backend.id
}

resource "aws_eip_association" "frontend" {
  instance_id   = aws_instance.frontend.id
  allocation_id = aws_eip.frontend.id
}
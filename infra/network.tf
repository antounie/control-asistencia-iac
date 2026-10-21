data "aws_vpc" "default" {
  default = true
}

# ---------- Security Group del FRONTEND ----------

resource "aws_security_group" "frontend" {
  name        = "${var.proyecto}-frontend-sg"
  description = "HTTP publico y SSH desde mi IP para el frontend"
  vpc_id      = data.aws_vpc.default.id
}

resource "aws_vpc_security_group_ingress_rule" "frontend_http" {
  security_group_id = aws_security_group.frontend.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  description       = "HTTP desde internet"
}

resource "aws_vpc_security_group_ingress_rule" "frontend_ssh" {
  security_group_id = aws_security_group.frontend.id
  cidr_ipv4         = var.mi_ip # ← corregido (antes: var.region)
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  description       = "SSH desde mi IP"
}

resource "aws_vpc_security_group_egress_rule" "frontend_all" {
  security_group_id = aws_security_group.frontend.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Toda la salida a internet"
}

# ---------- Security Group del BACKEND ----------

resource "aws_security_group" "backend" {
  name        = "${var.proyecto}-backend-sg"
  description = "HTTP publico y SSH desde mi IP para el backend"
  vpc_id      = data.aws_vpc.default.id
}

resource "aws_vpc_security_group_ingress_rule" "backend_http" {
  security_group_id = aws_security_group.backend.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  description       = "HTTP desde internet"
}

resource "aws_vpc_security_group_ingress_rule" "backend_ssh" {
  security_group_id = aws_security_group.backend.id
  cidr_ipv4         = var.mi_ip # ← corregido (antes: var.region)
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  description       = "SSH desde mi IP"
}

# ← agregado: faltaba la salida del backend
resource "aws_vpc_security_group_egress_rule" "backend_all" {
  security_group_id = aws_security_group.backend.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Toda la salida a internet"
}
provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Proyecto = var.proyecto
      Entorno  = "laboratorio"
      Gestion  = "terraform"
    }
  }
}


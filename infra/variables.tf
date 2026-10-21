variable "region" {
  description = "Region de AWS donde se crean los recursos"
  type        = string
  default     = "us-east-2"
}

variable "proyecto" {
  description = "Nombre del proyecto, usado en etiquetas y nombres"
  type        = string
  default     = "control-asistencia"
}

variable "mi_ip" {
  description = "Mi IP publica en formato CIDR para SSH"
  type        = string
}

variable "ruta_clave_publica" {
  description = "Ruta del archivo de la clave publica SSH"
  type        = string
  default     = "~/.ssh/control-asistencia.pub"
}
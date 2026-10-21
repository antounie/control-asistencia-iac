output "frontend_url" {
  description = "Abre esta URL en el navegador para usar el sistema"
  value       = "http://${aws_eip.frontend.public_ip}"
}

output "backend_graphql_url" {
  description = "Endpoint de la API GraphQL"
  value       = "http://${aws_eip.backend.public_ip}/graphql/"
}

output "backend_admin_url" {
  description = "Panel de administracion de Django"
  value       = "http://${aws_eip.backend.public_ip}/admin/"
}

output "ssh_backend" {
  description = "Comando para entrar al servidor backend"
  value       = "ssh -i $HOME/.ssh/control-asistencia ubuntu@${aws_eip.backend.public_ip}"
}

output "ssh_frontend" {
  description = "Comando para entrar al servidor frontend"
  value       = "ssh -i $HOME/.ssh/control-asistencia ubuntu@${aws_eip.frontend.public_ip}"
}
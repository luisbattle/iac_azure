data "template_file" "linux-backend-cloud-init" {
  template = file("./scripts/init_backend.sh")
}
data "template_file" "linux-frontend-cloud-init" {
  template = file("./scripts/init_frontend.sh")
}


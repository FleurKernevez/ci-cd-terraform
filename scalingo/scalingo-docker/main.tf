# Set the required provider and versions
terraform {
  required_providers {
    scalingo = {
      source  = "scalingo/scalingo"
      version = "2.3.0" # Or the latest version
    }
  }
}

variable "scalingo_token" {
  type        = string
  description = "the scalingo token"
}

provider "scalingo" {
  api_token = var.scalingo_token
  region    = "osc-fr1"
}

resource "scalingo_app" "marinaperez-my-app" {
  name     = "marinaperez-my-app"
}

resource "scalingo_addon" "db" {
  provider_id = "mysql"
  plan = "mysql-starter-512"
  app = "${scalingo_app.marinaperez-my-app.id}"
}

resource "scalingo_container_type" "web" {
  app = scalingo_app.marinaperez-my-app.name
  name   = "web"
  size   = "S"
  amount = 1
}

resource "scalingo_container_type" "api-python" {
  app = scalingo_app.marinaperez-my-app.name
  name   = "api-python"
  size   = "S"
  amount = 1
}

resource "scalingo_container_type" "api-node" {
  app = scalingo_app.marinaperez-my-app.name
  name   = "api-node"
  size   = "S"
  amount = 1
}
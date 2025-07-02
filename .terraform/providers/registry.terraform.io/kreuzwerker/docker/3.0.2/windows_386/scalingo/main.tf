# A adapter avec une app a créer sur Scalingo

terraform {
  require_providers {
    scalingo = {
      source  = "scalingo/scalingo"
      version = "2.3.0"
    }
  }
}

variable scalingo_token {
  type        = string
  description = "description"
}

provider "scalingo" {
  api_token = var.scalingo_token
  region = "osc-fr1"
}

resource "scalingo_app" "marinaperez-python-api" {
  name     = "marinaperez-python-api"
}

resource "scalingo_addon" "db" {
  provider_id = "mysql"
  plan = "mysql-starter-512"
  app = "${scalingo_app.marinaperez-python-api.id}"
}

resource "scalingo_container_type" "web" {
  app    = scalingo_app.marinaperez-python-api.name
  name   = "web"
  amount = 1
  size   = "S"
}

resource "scalingo_container_type" "api" {
  app    = scalingo_app.marinaperez-python-api.name
  name   = "api"
  amount = 1
  size   = "S"
}

# A venir : Faire communiquer docker avec scalingo
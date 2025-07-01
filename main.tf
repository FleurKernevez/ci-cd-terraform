terraform {
    required_providers {
        docker = {
            source = "kreuzwerker/docker"
            version = "3.0.2"        
        }
    }
}

provider "docker" {}

# Variables
variable "mongodb_url" {
  description = "MongoDB connection string"
  type        = string
}

variable "port" {
  description = "Port used by Node server"
  type        = string
}

variable "mysql_pwd" {
  description = "Port used by Node server"
  type        = string
}

resource "docker_network" "internal_network"{
    name = "internal-app-network"
}

// mango

resource "docker_image" "mongo_image" {
    name = "mongo"

}
resource "docker_container" "mongo_db" {
    name = "mongo_db"
    image = docker_image.mongo_image.image_id
    restart = "always"

    networks_advanced {
        name = docker_network.internal_network.name
    }

    ports {
        external = 27017
        internal = 27017
    }
}

// node

resource "docker_image" "node_image" {
    name = "docker.io/fleurk/node"
}

resource "docker_container" "node_server" {
    name = "node_server"
    image = docker_image.node_image.image_id
    restart = "always"

    networks_advanced {
        name = docker_network.internal_network.name
    }

    ports {
        external = 5001
        internal = 5001
    }


    # Command to run
    command = ["node", "server.js"]

    # Depends on MongoDB
    depends_on = [docker_container.mongo_db]
}

// my sql

resource "docker_image" "mysql_image" {
    name = "docker.io/fleurk/mysql"

}
resource "docker_container" "mysql_image" {
    name = "mysql_image"
    image = docker_image.mysql_image.image_id
    restart = "always"

    env=[
        "MYSQL_ROOT_PASSWORD=var.mysql_pwd"
    ]

    networks_advanced {
        name = docker_network.internal_network.name
    }

    ports {
        external = 3306
        internal = 3306
    }
}

// python

resource "docker_image" "python_image" {
    name = "docker.io/fleurk/python:3.9"
}

resource "docker_container" "python_server" {
    name = "python_server"
    image = docker_image.python_image.image_id
    restart = "always"

    networks_advanced {
        name = docker_network.internal_network.name
    }

    ports {
        external = 8000
        internal = 8000
    }

    # Command to run
    command = ["python", "-m", "uvicorn", "server:app", "--proxy-headers", "--host", "0.0.0.0", "--port", "8000"]

    # Depends on MongoDB
    depends_on = [docker_container.mysql_image]

}

// react

resource "docker_image" "react_image" {
    name = "docker.io/fleurk/react"
}

resource "docker_container" "react" {
    name = "react"
    image = docker_image.react_image.image_id
    restart = "always"

    networks_advanced {
        name = docker_network.internal_network.name
    }

    ports {
        external = 3000
        internal = 3000
    }

    # Command to run
    command = ["npm", "start"]

    # Depends on MongoDB
    depends_on = [docker_container.mysql_image]
}


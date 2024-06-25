packer {
  required_plugins {
    azure = {
      source  = "github.com/hashicorp/azure"
      version = "~> 2"
    }
  }
}


source "azure-arm" "FastifyVM" {
  azure_tags = {
    dept = "Development"
    task = "Image deployment"
  }
  client_id                         = "00000000-0000-0000-0000-000000000000"
  client_secret                     = "00000000-0000-0000-0000-000000000000"
  image_offer                       = "0001-com-ubuntu-server-jammy"
  image_publisher                   = "canonical"
  image_sku                         = "22_04-lts"
  location                          = "westeurope"
  managed_image_name                = "fastifyVM"
  managed_image_resource_group_name = "fastifyResourceGroup"
  os_type                           = "Linux"
  subscription_id                   = "00000000-0000-0000-0000-000000000000"
  tenant_id                         = "00000000-0000-0000-0000-000000000000"
  vm_size                           = "Standard_B1S"
}

build {
  sources = ["source.azure-arm.FastifyVM"]

  provisioner "shell" {
    inline = [
      "sudo mkdir -p /home/fastify-hello-world",
      "sudo chown -R $USER:$USER /home/fastify-hello-world"
    ]
  }

  provisioner "file" {
    source      = "./"
    destination = "/home/fastify-hello-world"
  }

  provisioner "shell" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt upgrade -y",
      "sudo apt install -y curl",
      "curl -fsSL https://deb.nodesource.com/setup_20.x | sudo bash - ",
      "sudo apt-get install -y nodejs",
      "cd /home/fastify-hello-world",
      "npm install"
    ]
  }

}
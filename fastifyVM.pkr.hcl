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
  client_id                         = "your_default_client_id"
  client_secret                     = "your_default_client_secret"
  image_offer                       = "0001-com-ubuntu-server-jammy"
  image_publisher                   = "canonical"
  image_sku                         = "22_04-lts"
  location                          = "westeurope"
  managed_image_name                = "fastifyVM"
  managed_image_resource_group_name = "fastifyRG"
  os_type                           = "Linux"
  subscription_id                   = "your_default_subscription_id"
  tenant_id                         = "your_default_tenant_id"
  vm_size                           = "Standard_B1S"
}

build {
  sources = ["source.azure-arm.FastifyVM"]

  provisioner "shell" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt upgrade -y",
      "sudo apt install -y curl",
      "curl -fsSL https://deb.nodesource.com/setup_20.x | sudo bash - ",
      "sudo apt-get install -y nodejs",
      "git clone https://github.com/Viorel1989/fastify-hello-world.git",
      "cd fastify-hello-world",
      "npm install",
      "npm start"
    ]
  }

}
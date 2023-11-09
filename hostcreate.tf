
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.102.0"
    }
  }
}


#Configure connection to my yandex.cloud
provider "yandex" {
  token                    = ""
  cloud_id                 = "b1g076oa23iiut56kpqh"
  folder_id                = "b1gs7vib6tce4ocj9pnr"
  zone                     = "ru-central1-a"
}

#Build host
resource "yandex_compute_instance" "build" {
  name        = "build"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"

#Chose count core and ram
  resources {
    cores  = 2
    memory = 4
  }

#Chose OC and size hdd
  boot_disk {
    initialize_params {
      image_id = "fd88q8cetpv706g8kia9"
      size = 15
    }
  }

#Network config
  network_interface {
    subnet_id = "e9b6m0jmtruhhm3r4bdj"
    nat            = true
  }

#Indicate the path to the ssh key
  metadata = {
    ssh-keys = "root:${file("/home/dmitry/cer/Cert/build.pub")}"
  }

#Connect to build host and update package
  provisioner "remote-exec" {
    inline =  [
      "sudo apt update"
    ]
    connection {
      type     = "ssh"
      user     = "ubuntu"
      private_key = file("/home/dmitry/cer/Cert/build")
      host = yandex_compute_instance.build.network_interface.0.nat_ip_address
  }
  }
}

#Prod Host
resource "yandex_compute_instance" "prod" {
  name        = "prod"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"

#Chose count core and ram
  resources {
    cores  = 2
    memory = 4
  }

#Chose OC and size hdd
  boot_disk {
    initialize_params {
      image_id = "fd88q8cetpv706g8kia9"
      size = 15
    }
  }

#Configure network options
  network_interface {
    subnet_id = "e9b6m0jmtruhhm3r4bdj"
    nat            = true
  }

#Indicate the path to the ssh key
  metadata = {
    ssh-keys = "ubuntu:${file("/home/dmitry/cer/Cert/prod.pub")}"
  }


#Connect to prod host and update package
  provisioner "remote-exec" {
    inline =  [
      "sudo apt update"
    ]
     connection {
       type     = "ssh"
       user     = "ubuntu"
       private_key = file("/home/dmitry/cer/Cert/prod")
       host = yandex_compute_instance.prod.network_interface.0.nat_ip_address
  }
  }
}

#Output build-stage
output "build_ip" {
  value = yandex_compute_instance.build.network_interface.0.nat_ip_address
}

#Output prod-stage
output "prod_ip" {
  value = yandex_compute_instance.prod.network_interface.0.nat_ip_address
}




// packer {
//   required_plugins {
//     amazon = {
//       version = ">= 0.0.2"
//       source  = "github.com/hashicorp/amazon"
//     }
//   }
// }

source "amazon-ebs" "vm" {
  region = "${var.region}"
  ami_name      = "ubuntu-docker-{{timestamp}}"
  source_ami    = "${var.base_ami}"
  instance_type = "${var.instance_type}"
  // associate_public_ip_address = true
  ssh_username = "ubuntu"
  launch_block_device_mappings {
    device_name = "/dev/sda1"
    volume_size = 50
    volume_type = "gp2"
    delete_on_termination = true
  }
  tags = {
    OS_Version = "Ubuntu"
    Release = "Latest"
    ManagedBy = "DevOps Team"
    }
}

build {
  name = "linux-builder"
  sources = [
    "source.amazon-ebs.vm"
  ]
  provisioner "ansible" {
    playbook_file = "./ansible/application.yml"
  }
}
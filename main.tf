terraform {
  backend "gcs" {
    project = "devops-233521"
    bucket = "devopsmalyna1"
    prefix = "dev"
    credentials = "DevOps-f87e91d062e3.json"
  }
}
resource "google_compute_http_health_check" "default" {
  name                = "tf-www-basic-check"
  request_path        = "/"
  check_interval_sec  = 1
  healthy_threshold   = 1
  unhealthy_threshold = 10
  timeout_sec         = 1
}

resource "google_compute_instance" "vm-jenkins" {
  count        = "${var.count}"
  name         = "${var.instance_name}-${count.index}"
  machine_type = "${var.machine_type}"
  tags = ["http"]
  

  boot_disk {
    initialize_params {
      image = "${var.image}"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network       = "default"
    access_config = {
    }
  }
   metadata {
    sshKeys = "centos:${file("${var.public_key_path}")}"
  }
 #metadata_startup_script = "${file("start.sh")}"
 #metadata_startup_script = <<SCRIPT
#sudo yum -y update
#sudo yum -y install httpd
#sudo systemctl start httpd
#SCRIPT

#provisioner "remote-exec" {
#  connection {
#    type = "ssh"
#    host = "local"
#    user = "centos"
#    private_key = "./.ssh/id_rsa"
#  }
#      scripts = [
#        "start.sh",
#        "start.sh",
#      ]

#    }
}


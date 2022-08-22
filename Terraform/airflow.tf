resource "yandex_compute_instance" "airflow" {
  name = "airflow-server"
  platform_id = "standard-v1"
  resources {
    cores = 2
    memory = 4
  }
  
  boot_disk {
    disk_id = yandex_compute_disk.disk_airflow.id
  }
  
  network_interface {
    subnet_id = yandex_vpc_subnet.data_subnet.id
    nat = true
  }
  
  metadata = {
    
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}" 
  }
}

resource "yandex_vpc_security_group" "airflow-ports" {
  network_id = yandex_vpc_network.data_net.id
  ingress {
    protocol = "TCP"
    v4_cidr_blocks = [ "10.0.1.0/24" ]
    port = 22 
  }
  ingress {
    protocol = "TCP"
    v4_cidr_blocks = [ "10.0.1.0/24" ]
    port = 8080
  }
}
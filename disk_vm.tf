resource "yandex_compute_disk" "storage" {
  count = 3
  name = "vdisk-${count.index}"
  size = var.hdd_size
}

resource "yandex_compute_instance" "storage" {
  name = "storage"
  platform_id = "standard-v1"
  resources {
    cores         = 2
    memory        = 1
    core_fraction = 5
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  dynamic "secondary_disk" {
    for_each = {for  disk in yandex_compute_disk.storage: disk.name => disk}
    content {
     disk_id = secondary_disk.value.id
     }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
    security_group_ids = [yandex_vpc_security_group.example.id]
  }
  metadata = {
    serial-port-enable = 1
    ssh-keys           = local.vms_ssh_root_key
  }
}
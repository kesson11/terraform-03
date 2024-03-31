# for_each loop example - different VMs main & replica
resource "yandex_compute_instance" "nodes" {
  
   # for_each = {for vm in var.vms:  vm.hostname => vm}
#    name         = "${each.value.hostname}" machine_type = "custom-${each.value.cpu}-${each.value.ram*1024}" zone = "${var.gcp_zone}"
#
  #  boot_disk {
   #     initialize_params {
   #     image = "${var.image_name}" size = "${each.value.hdd}"
   #    }



  for_each = {for vm in var.for_each_vm: vm.vm_name => vm}
  name = each.value.vm_name
  platform_id = "standard-v1"
  #depends_on = [ yandex_compute_instance.web ]
  resources {
    cores         = each.value.cpu
    memory        = each.value.ram
    core_fraction = each.value.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = each.value.disk_volume
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
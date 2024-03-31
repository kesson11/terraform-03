locals {
  #vms_ssh_root_key = "ubuntu:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKVzzVYjUFT5PNXSGcZ+/v5lH/gLcxSPB7D/Xx5TP+T9 kes@localhost.localdomain"
  vms_ssh_root_key = "ubuntu:${file("/home/kes/.ssh/id_ed25519.pub")}"
}
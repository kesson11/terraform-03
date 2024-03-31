resource  "local_file" "hosts" {
  filename = "./hosts.cfg"
  content = templatefile("./hosts.tftpl",{
    webservers= [for i in yandex_compute_instance.web: i ]
    databases=  [for k,v in yandex_compute_instance.nodes: v ]
    storages= tolist( [yandex_compute_instance.storage])
  })
}
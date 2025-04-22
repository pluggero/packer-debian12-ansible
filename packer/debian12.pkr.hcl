##################################################################################
# SOURCES
##################################################################################
source "virtualbox-iso" "debian12" {
  vm_name              = "${local.vm_name}"
  iso_url              = local.debian_iso_url_x86_64
  iso_checksum         = local.debian_iso_checksum_x86_64
  iso_target_path      = "${path.root}/inputs/${local.debian_iso_name_x86_64}"
  http_directory       = local.http_directory
  shutdown_command     = local.vm_nonroot_shutdown_command
  ssh_username         = var.vm_ssh_username
  ssh_password         = var.vm_ssh_password
  ssh_timeout          = var.vm_ssh_timeout
  boot_command         = local.debian_boot_command_x86_64
  boot_wait            = var.vm_boot_wait
  disk_size            = var.vm_disk_size
  guest_os_type        = "Debian_64"
  cpus                 = var.vm_cpu_core
  memory               = var.vm_mem_size
  headless             = var.vbox_vm_headless
  hard_drive_interface = "sata"
  iso_interface        = "sata"
  format               = var.vbox_output_format
  output_directory     = "${path.root}/outputs/${local.vbox_output_name}"
  guest_additions_mode = var.vbox_guest_additions
  vboxmanage           = [["modifyvm", "{{.Name}}", "--nat-localhostreachable1", "on"]]
  vboxmanage_post      = [
    ["modifyvm", "{{.Name}}", "--memory", var.vbox_post_mem_size],
    ["modifyvm", "{{.Name}}", "--cpus", var.vbox_post_cpu_core],
    ["modifyvm", "{{.Name}}", "--uartmode1", "disconnected"],
    ["modifyvm", "{{.Name}}", "--graphicscontroller", var.vbox_post_graphics],
    ["modifyvm", "{{.Name}}", "--vram", var.vbox_post_vram],
    ["modifyvm", "{{.Name}}", "--accelerate-3d", var.vbox_post_accelerate_3d],
    ["modifyvm", "{{.Name}}", "--clipboard-mode", var.vbox_post_clipboard_mode],
    ["modifyvm", "{{.Name}}", "--nic1", "bridged", "--bridgeadapter1", var.vbox_post_bridged_adapter],
  ]
}



##################################################################################
# BUILD
##################################################################################

build {
  sources = [
    "source.virtualbox-iso.debian12"
  ]

  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{.Vars}} sudo -S -E bash '{{.Path}}'"
    script = "${path.root}/scripts/ansible.sh"
  }

  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{.Vars}} sudo -S -E bash '{{.Path}}'"
    script = "${path.root}/scripts/setup.sh"
  }

  provisioner "ansible-local" {
    playbook_file = "${path.root}/../ansible/playbooks/main.yml"
    galaxy_file = "${path.root}/../ansible/requirements.yml"
  }

  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{.Vars}} sudo -S -E bash '{{.Path}}'"
    script = "${path.root}/scripts/cleanup.sh"
  }

  post-processors {
    post-processor "artifice" {
      files = [
        "${path.root}/outputs/${local.vbox_output_name}/${local.vm_name}-disk001.vmdk",
        "${path.root}/outputs/${local.vbox_output_name}/${local.vm_name}.ovf"
      ]
    }
    post-processor "vagrant" {
      keep_input_artifact = true
      provider_override   = "virtualbox"
      output = "${path.root}/outputs/${local.vbox_output_name}/${local.vm_name}-virtualbox.box"
    }
  }

}

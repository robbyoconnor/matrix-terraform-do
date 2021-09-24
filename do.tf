resource "local_file" "hosts_file" {
  content = templatefile("files/hosts.tmpl",
    {
      "hostname" : digitalocean_droplet.matrix-do.name
  })
  filename = "../matrix-docker-ansible-deploy/inventory/hosts"
}

resource "digitalocean_droplet" "matrix-do" {
  ssh_keys = [digitalocean_ssh_key.matrix-do.fingerprint]
  image    = var.ubuntu
  region   = var.do_nyc3
  size     = "s-2vcpu-4gb"
  backups  = true
  ipv6     = true
  name     = "matrix.oconnor.ninja"

  connection {
    host        = self.ipv4_address
    type        = "ssh"
    private_key = file(var.pvt_key)
    user        = "root"
    timeout     = "2m"
  }

  provisioner "remote-exec" {
    inline = ["rm -f /var/lib/apt/lists/lock"] # not sure why but it locks things up later when we try to run our playbook
  }

}

resource "digitalocean_ssh_key" "matrix-do" {
  name       = "matrix-do"
  public_key = file(var.ssh_key_path)
}

resource "digitalocean_firewall" "firewall" {
  name = "Matrix"

  droplet_ids = [digitalocean_droplet.matrix-do.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "3478"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "udp"
    port_range       = "3478"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "5348"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "udp"
    port_range       = "5348"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "8448"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "udp"
    port_range       = "49152-49172"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }
  inbound_rule {
    protocol         = "tcp"
    port_range       = "4443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "udp"
    port_range       = "10000"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "icmp"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

}

resource "null_resource" "ansible-provisioner" {
  depends_on = [digitalocean_droplet.matrix-do, cloudflare_record.matrix_a, cloudflare_record.matrix_aaaa]

  provisioner "local-exec" {
    working_dir = "../matrix-docker-ansible-deploy"
    command     = "sleep 5 && ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u root -i inventory/hosts --private-key ${var.pvt_key} -e 'pub_key=${var.pub_key}' setup.yml --tags=setup-all"
  }
}

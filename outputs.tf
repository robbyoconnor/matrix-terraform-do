output "IPv4" {
  value = digitalocean_droplet.matrix-do.ipv4_address
}

output "IPv6" {
  value = digitalocean_droplet.matrix-do.ipv6_address
}

output "Name" {
  value = digitalocean_droplet.matrix-do.name
}

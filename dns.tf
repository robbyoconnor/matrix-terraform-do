resource "cloudflare_record" "matrix_a" {
  zone_id = var.cf_zone
  name    = "matrix"
  type    = "A"
  value   = digitalocean_droplet.matrix-do.ipv4_address
  ttl     = 300
}

resource "cloudflare_record" "matrix_aaaa" {
  zone_id = var.cf_zone
  name    = "matrix"
  type    = "AAAA"
  value   = digitalocean_droplet.matrix-do.ipv6_address
  ttl     = 300
  proxied = false
}


resource "cloudflare_record" "apex_cname" {
  zone_id = var.cf_zone
  name    = "@"
  type    = "A"
  value   = "35.185.44.232"
  ttl     = 300
  proxied = false
}

resource "cloudflare_record" "gitlab_verification" {
  zone_id = var.cf_zone
  name    = "_gitlab-pages-verification-code"
  type    = "TXT"
  value   = "_gitlab-pages-verification-code=a7b869031003da5b397e71f323097cdc"
  ttl     = 300
  proxied = false
}

resource "cloudflare_record" "gitlab_verification2" {
  zone_id = var.cf_zone
  name    = "oconnor.ninja"
  type    = "TXT"
  value   = "gitlab-pages-verification-code=e7bf3465da74477a92874cbcce1ffd72"
  ttl     = 300
  proxied = false
}


resource "cloudflare_record" "element_cname" {
  zone_id = var.cf_zone
  name    = "element"
  type    = "CNAME"
  value   = "matrix.oconnor.ninja"
  ttl     = 300
  proxied = "false"
}

resource "cloudflare_record" "_matrix_identity" {
  zone_id = var.cf_zone
  name    = "_matrix_identity._tcp"
  type    = "SRV"
  ttl     = 300
  proxied = "false"
  data {

    service  = "_matrix_identity"
    proto    = "_tcp"
    name     = "matrix_identity_srv"
    priority = 10
    weight   = 0
    port     = 443
    target   = "matrix.oconnor.ninja"
  }
}

# resource "cloudflare_record" "_matrix" {
#   zone_id = var.cf_zone
#   name    = "_matrix._tcp"
#   type    = "SRV"
#   ttl     = 300
#   proxied = "false"
#   data {

#     service  = "_matrix"
#     proto    = "_tcp"
#     name     = "matrix_srv"
#     priority = 10
#     weight   = 0
#     port     = 443
#     target   = "matrix.oconnor.ninja"
#   }
# }

resource "cloudflare_record" "dimension_cname" {
  zone_id = var.cf_zone
  name    = "dimension"
  type    = "CNAME"
  value   = "matrix.oconnor.ninja"
  ttl     = 300
  proxied = "false"
}

resource "cloudflare_record" "jitsi_cname" {
  zone_id = var.cf_zone
  name    = "jitsi"
  type    = "CNAME"
  value   = "matrix.oconnor.ninja"
  ttl     = 300
  proxied = "false"
}
resource "cloudflare_record" "stats_cname" {
  zone_id = var.cf_zone
  name    = "stats"
  type    = "CNAME"
  value   = "matrix.oconnor.ninja"
  ttl     = 300
  proxied = "false"
}

resource "cloudflare_record" "goneb_cname" {
  zone_id = var.cf_zone
  name    = "goneb"
  type    = "CNAME"
  value   = "matrix.oconnor.ninja"
  ttl     = 300
  proxied = "false"
}

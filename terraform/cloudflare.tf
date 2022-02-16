resource "cloudflare_zone" "hannahs_family" {
  zone = "hannahs.family"
}

resource "cloudflare_zone_dnssec" "hannahs_family" {
  zone_id = cloudflare_zone.hannahs_family.id
}

resource "cloudflare_record" "MX_hannahs_family" {
  for_each = {
    "aspmx.l.google.com"      = 1
    "alt1.aspmx.l.google.com" = 5
    "alt2.aspmx.l.google.com" = 5
    "aspmx2.googlemail.com"   = 10
    "aspmx3.googlemail.com"   = 10
  }

  zone_id  = cloudflare_zone.hannahs_family.id
  name     = "hannahs.family"
  type     = "MX"
  priority = each.value
  value    = each.key
}

resource "cloudflare_record" "TXT_hannahs_family" {
  zone_id = cloudflare_zone.hannahs_family.id
  name    = "hannahs.family"
  type    = "TXT"
  value   = "v=spf1 a include:_spf.google.com ~all"
}

resource "cloudflare_record" "TXT__dmarc_hannahs_family" {
  zone_id = cloudflare_zone.hannahs_family.id
  name    = "_dmarc"
  type    = "TXT"
  value   = "v=DMARC1; p=quarantine; rua=mailto:admin@hannahs.family"
}

resource "cloudflare_zone" "jbhannah_net" {
  zone = "jbhannah.net"
}

resource "cloudflare_zone_dnssec" "jbhannah_net" {
  zone_id = cloudflare_zone.jbhannah_net.id
}

resource "cloudflare_record" "CNAME_jbhannah_net" {
  zone_id = cloudflare_zone.jbhannah_net.id
  name    = "jbhannah.net"
  type    = "CNAME"
  value   = "cname.vercel-dns.com"
}

resource "cloudflare_record" "CNAME_jps4_jbhannah_net" {
  zone_id = cloudflare_zone.jbhannah_net.id
  name    = "jps4"
  type    = "CNAME"
  value   = "fierce-refuge-2741.herokuapp.com"
  proxied = true
}

resource "cloudflare_record" "CNAME_www_jbhannah_net" {
  zone_id = cloudflare_zone.jbhannah_net.id
  name    = "www"
  type    = "CNAME"
  value   = cloudflare_record.CNAME_jbhannah_net.hostname
}

resource "cloudflare_record" "MX_jbhannah_net" {
  for_each = {
    "aspmx.l.google.com"      = 1
    "alt1.aspmx.l.google.com" = 5
    "alt2.aspmx.l.google.com" = 5
    "aspmx2.googlemail.com"   = 10
    "aspmx3.googlemail.com"   = 10
  }

  zone_id  = cloudflare_zone.jbhannah_net.id
  name     = "jbhannah.net"
  type     = "MX"
  priority = each.value
  value    = each.key
}

resource "cloudflare_record" "TXT_jbhannah_net" {
  for_each = toset([
    "google-site-verification=hxSa3qxT4V1Gx9KxK_4cVTS4zrmW0y7MKvZ3EBTzaoY",
    "v=spf1 a include:_spf.google.com ~all",
  ])

  zone_id = cloudflare_zone.jbhannah_net.id
  name    = "jbhannah.net"
  type    = "TXT"
  value   = each.value
}

resource "cloudflare_record" "TXT__dmarc_jbhannah_net" {
  zone_id = cloudflare_zone.jbhannah_net.id
  name    = "_dmarc"
  type    = "TXT"
  value   = "v=DMARC1; p=quarantine; rua=mailto:admin@jbhannah.net"
}

resource "cloudflare_record" "TXT__keybase_jbhannah_net" {
  zone_id = cloudflare_zone.jbhannah_net.id
  name    = "_keybase"
  type    = "TXT"
  value   = "keybase-site-verification=wo3z8fuI_nkYT4zlnlaMWV1Q1NkdGU06BuMMK4Zv3WQ"
}

resource "google_dns_managed_zone" "blobscan_zone" {
  name        = "blobscan"
  dns_name    = "blobscan.com."
  description = "Blobscan DNS zone"
  dnssec_config {
    state = "on"
  }
  labels = {
    project = "blobscan"
  }
}

resource "random_id" "rnd" {
  byte_length = 4
}

# fetching already created DNS zone
data "google_dns_managed_zone" "blobscan_zone" {
  name = "blobscan"
}

resource "google_dns_record_set" "root" {
  name         = "blobscan.com."
  managed_zone = data.google_dns_managed_zone.blobscan_zone.name
  type         = "A"
  ttl          = 300
  rrdatas = ["76.76.21.21"]
}

resource "google_dns_record_set" "vercel_wildcard" {
  name         = "*.blobscan.com."
  managed_zone = data.google_dns_managed_zone.blobscan_zone.name
  type         = "CNAME"
  ttl          = 300
  rrdatas      = ["cname.vercel-dns.com."]
}

resource "google_dns_record_set" "vercel_txt" {
  name         = "_vercel.blobscan.com."
  managed_zone = data.google_dns_managed_zone.blobscan_zone.name
  type         = "TXT"
  ttl          = 300
  rrdatas      = [
    "vc-domain-verify=stg-goerli.blobscan.com,6da5d62b5797925346a9"
  ]
}

resource "google_dns_record_set" "api_redirect" {
  name         = "api.blobscan.com."
  managed_zone = data.google_dns_managed_zone.blobscan_zone.name
  type         = "CNAME"
  ttl          = 300
  rrdatas      = ["api.goerli.blobscan.com."]
}
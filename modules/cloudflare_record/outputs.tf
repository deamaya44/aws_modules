output "record_id" {
  description = "ID of the DNS record"
  value       = cloudflare_record.this.id
}

output "hostname" {
  description = "Hostname of the DNS record"
  value       = cloudflare_record.this.hostname
}

output "record_name" {
  description = "Name of the DNS record"
  value       = cloudflare_record.this.name
}

output "hosted_zone_id" {
  description = "ID of the Route53 hosted zone"
  value       = data.aws_route53_zone.nelskincare_zone.zone_id
}

output "hosted_zone_name" {
  description = "Name of the Route53 hosted zone"
  value       = data.aws_route53_zone.nelskincare_zone.name
}
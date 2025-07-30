terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

data "aws_route53_zone" "nelskin_zone" {
  name = "nelskin.co.za"
}

data "aws_route53_zone" "nelskincare_zone" {
  name = "nelskincare.co.za"
}

# Existing domain - SquareSpace records
resource "aws_route53_record" "root_domain_a_records" {
  zone_id = data.aws_route53_zone.nelskin_zone.zone_id
  name    = data.aws_route53_zone.nelskin_zone.name
  type    = "A"
  ttl     = var.migration_ttl

  records = var.squarespace_ip_addresses
}

resource "aws_route53_record" "www_cname" {
  zone_id = data.aws_route53_zone.nelskin_zone.zone_id
  name    = "www.${data.aws_route53_zone.nelskin_zone.name}"
  type    = "CNAME"
  ttl     = var.migration_ttl

  records = [var.squarespace_cname_target]
}
# ============================================================================
# CloudFront Configuration for nelskincare.co.za
# ============================================================================

resource "aws_route53_record" "nelskincare_root" {
  zone_id = data.aws_route53_zone.nelskincare_zone.zone_id
  name    = data.aws_route53_zone.nelskincare_zone.name
  type    = "A"

  alias {
    name                   = var.cloudfront_distribution_domain_name
    zone_id                = var.cloudfront_hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "nelskincare_www" {
  zone_id = data.aws_route53_zone.nelskincare_zone.zone_id
  name    = "www.${data.aws_route53_zone.nelskincare_zone.name}"
  type    = "A"

  alias {
    name                   = var.cloudfront_distribution_domain_name
    zone_id                = var.cloudfront_hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "nelskincare_root_ipv6" {
  zone_id = data.aws_route53_zone.nelskincare_zone.zone_id
  name    = data.aws_route53_zone.nelskincare_zone.name
  type    = "AAAA"

  alias {
    name                   = var.cloudfront_distribution_domain_name
    zone_id                = var.cloudfront_hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "nelskincare_www_ipv6" {
  zone_id = data.aws_route53_zone.nelskincare_zone.zone_id
  name    = "www.${data.aws_route53_zone.nelskincare_zone.name}"
  type    = "AAAA"

  alias {
    name                   = var.cloudfront_distribution_domain_name
    zone_id                = var.cloudfront_hosted_zone_id
    evaluate_target_health = false
  }
}
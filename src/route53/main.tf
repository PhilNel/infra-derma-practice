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

# ============================================================================
# Redirect nelskin.co.za domain to nelskincare.co.za domain using CloudFront
# ============================================================================

resource "aws_route53_record" "nelskin_redirect_root" {
  zone_id = data.aws_route53_zone.nelskin_zone.zone_id
  name    = data.aws_route53_zone.nelskin_zone.name
  type    = "A"

  alias {
    name                   = var.nelskin_redirect_cloudfront_domain_name
    zone_id                = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "nelskin_redirect_www" {
  zone_id = data.aws_route53_zone.nelskin_zone.zone_id
  name    = "www.${data.aws_route53_zone.nelskin_zone.name}"
  type    = "A"

  alias {
    name                   = var.nelskin_redirect_cloudfront_domain_name
    zone_id                = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "nelskin_redirect_root_ipv6" {
  zone_id = data.aws_route53_zone.nelskin_zone.zone_id
  name    = data.aws_route53_zone.nelskin_zone.name
  type    = "AAAA"

  alias {
    name                   = var.nelskin_redirect_cloudfront_domain_name
    zone_id                = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "nelskin_redirect_www_ipv6" {
  zone_id = data.aws_route53_zone.nelskin_zone.zone_id
  name    = "www.${data.aws_route53_zone.nelskin_zone.name}"
  type    = "AAAA"

  alias {
    name                   = var.nelskin_redirect_cloudfront_domain_name
    zone_id                = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
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
    zone_id                = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "nelskincare_www" {
  zone_id = data.aws_route53_zone.nelskincare_zone.zone_id
  name    = "www.${data.aws_route53_zone.nelskincare_zone.name}"
  type    = "A"

  alias {
    name                   = var.cloudfront_distribution_domain_name
    zone_id                = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "nelskincare_root_ipv6" {
  zone_id = data.aws_route53_zone.nelskincare_zone.zone_id
  name    = data.aws_route53_zone.nelskincare_zone.name
  type    = "AAAA"

  alias {
    name                   = var.cloudfront_distribution_domain_name
    zone_id                = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "nelskincare_www_ipv6" {
  zone_id = data.aws_route53_zone.nelskincare_zone.zone_id
  name    = "www.${data.aws_route53_zone.nelskincare_zone.name}"
  type    = "AAAA"

  alias {
    name                   = var.cloudfront_distribution_domain_name
    zone_id                = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}
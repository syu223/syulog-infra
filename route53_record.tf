resource "aws_route53_record" "cf_alias" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "syulog.link"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.origin-distribution.domain_name
    zone_id                = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}

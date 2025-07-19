#1. ACM証明書の発行
resource "aws_acm_certificate" "cert_syulog" {
  provider          = aws.virginia  
  domain_name       = "syulog.link"
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true     
  }
}

data "aws_route53_zone" "main" {
  name         = "syulog.link"    
  private_zone = false             
}

# 2. Route 53 に DNS検証レコードを作成
resource "aws_route53_record" "record_syulog_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert_syulog.domain_validation_options : 
    dvo.domain_name => {                         
      name   = dvo.resource_record_name          # ACMが指定した検証用レコードの名前
      type   = dvo.resource_record_type          # ACMが指定する検証レコードタイプ 通常 "CNAME"
      record = dvo.resource_record_value         # ACMが提示する検証用トークン値
    }
  }

  zone_id = data.aws_route53_zone.main.zone_id   # 検証レコードを追加する対象のゾーン
  name    = each.value.name                      # DNSレコードの名前（例: _abcde.syulog.link）
  type    = each.value.type                      # レコードタイプ（CNAME など）
  records = [each.value.record]                  # 実際のレコード値（検証トークン）
  ttl     = 60                                   # 検証目的なので短くてOK
}

# 3. ACM証明書の検証完了を待つ
resource "aws_acm_certificate_validation" "cert_syulog_validation" {
  provider                = aws.virginia
  certificate_arn         = aws_acm_certificate.cert_syulog.arn
  validation_record_fqdns = [
    for record in aws_route53_record.record_syulog_validation : record.fqdn
  ]
}

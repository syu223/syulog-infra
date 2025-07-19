resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "s3-oac" # 任意のOAC名
  origin_access_control_origin_type = "s3"     # OACが対象とする「オリジン」（データの送信元）のタイプを指定
  signing_behavior                  = "always" # CloudFrontがS3へのすべてのリクエストに署名を付与する
  signing_protocol                  = "sigv4"  # S3へのリクエストを署名する際に使用するプロトコルを指定
}

resource "aws_cloudfront_distribution" "origin-distribution" {
  enabled             = true
  default_root_object = "index.html"

  origin {
    domain_name = aws_s3_bucket.private.bucket_regional_domain_name
    origin_id   = "s3-origin"

    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "s3-origin"

    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}

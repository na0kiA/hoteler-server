resource "aws_acm_certificate" "root" {
  domain_name = "api.hoteler.jp"

  validation_method = "DNS"

  tags = {
    Name = "${local.service_name}-lovehoteler-com"
  }

  # デフォルトではリソースが削除されてから作成されるが、証明書に関してはロードバランサーリスナーで使用中なのを考慮して、作成してから削除させる
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "root" {
  certificate_arn = aws_acm_certificate.root.arn
}
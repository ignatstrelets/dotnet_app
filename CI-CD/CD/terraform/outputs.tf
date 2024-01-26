output "loki_public_ip" {
  value = aws_instance.loki.public_ip
}

output "elb_domain_name" {
  value = aws_elb.elb.dns_name
}
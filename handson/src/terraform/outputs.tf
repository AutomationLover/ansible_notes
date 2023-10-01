output "intances_public_ips" {
  value = {
    for i in aws_instance.example:
        i.tags_all.Name => i.public_ip
  }
}


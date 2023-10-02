output "intances_public_ips" {
  value = {
    Name = aws_instance.example.tags_all.Name 
    PublicIP = aws_instance.example.public_ip
  }
}
/*
output "intances_public_ips" {
  value = {
    for i in aws_instance.jenkins:
        i.tags_all.Name => i.public_ip
  }
}
*/


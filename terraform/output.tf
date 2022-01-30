output "domainName" {
  value = "${var.domainName}"
}

output "instanceIp" {
  value = "${aws_eip_association.eip_assoc.public_ip}"
}

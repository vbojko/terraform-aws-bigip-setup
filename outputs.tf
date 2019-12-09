output "vpc" {
  description = "AWS VPC ID for the created VPC"
  value       = module.vpc.vpc_id
}

output "bigip_mgmt_public_ips" {
  description = "Public IP addresses for the BIG-IP management interfaces"
  value       = module.bigip.mgmt_public_ips
}

output "bigip_mgmt_port" {
  description = "BIG-IP management port"
  value       = module.bigip.mgmt_port
}

output "bigip_password" {
  description = "BIG-IP management password"
  value       = random_password.password.result
}

output "jumphost_ip" {
  description = "ip address of jump host"
  value       = module.jumphost.public_ip
}

output "ec2_key_name" {
  description = "the key used to communication with ec2 instances"
  value       = var.ec2_key_name
}

output "bigip_nic_info" {
  description = "detailed information about the public nics on the bigips "
  value = data.aws_network_interface.bigip_public_nics
}

output "juiceshop_ip" {
  value = aws_eip.juiceshop[*].public_ip
}

output "grafana_ip" {
  value = aws_eip.grafana[*].public_ip
}

output "failover_declaration" {
  value = templatefile(
      "${path.module}/failover_declaration.json",
      {
        failover_scope = var.cidr
        failover_label = "${var.prefix}mydeployment${random_id.id.hex}"
      }
      )
}

# output "js_tags" {
#   value = local.js_tags
# }

# output "gf_tags" {
#   value = local.gf_tags
# }

output "tagsarray" {
  value = local.failover_tags
}
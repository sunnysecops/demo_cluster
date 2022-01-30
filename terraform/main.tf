locals {
  timestamp = 	formatdate("DD-MM-YYYY", timestamp())
  tags 	    =	 {
    	Terraform	= 	"True"
    	Environment	= 	"Dev"
    	Name 	   	= 	"${var.name}"
    	Product    	= 	"Falcon"
    	Owner 	   	= 	"${var.owner}"
    	Creator	   	= 	"${var.creator}"
    	CreatedOn  	= 	"${local.timestamp}"
   }
}
data "template_file" "setupScript" {
  template                  = "${file("scripts/setup.sh")}"
   vars                     = {
    githubUsername =    var.githubUsername
    githubToken    =    var.githubToken
  }
}

resource "aws_spot_instance_request" "spotFleet" {
    spot_price    		   = 	"${var.spotPrice}"
    wait_for_fulfillment           = 	true
    spot_type 			   = 	"persistent"
    instance_interruption_behavior = 	"stop"
    root_block_device {
        volume_size 		   = 	"30"
    }
    ami                            =  "${var.amiId}"
    instance_type                  =  "${var.instanceType}"
    iam_instance_profile           =  "${var.IAM}"
    associate_public_ip_address    =  true
    key_name                       =  "${var.keyName}"
    monitoring                     =  true
    vpc_security_group_ids         =  ["security-group-id"]
    user_data                      =  data.template_file.setupScript.rendered
    subnet_id                      =  "${var.subnetId}"
    tags			   =  local.tags
}

resource "aws_ec2_tag" "instanceTags" {
  resource_id 	= 	aws_spot_instance_request.spotFleet.spot_instance_id
  for_each	= 	local.tags
  key		= 	each.key
  value    	= 	each.value
}

resource "aws_eip" "eip" {
  vpc		   =    true
  tags		   =    local.tags
}

resource "aws_eip_association" "eip_assoc" {
  allocation_id         =    aws_eip.eip.id
  instance_id           =    aws_spot_instance_request.spotFleet.spot_instance_id
  allow_reassociation   =    false
}

resource "aws_route53_record" "devMinikube" {
  zone_id          =    "${var.zoneID}"
  name             =    "${var.domainName}"
  type             =    "A"
  allow_overwrite  =    true
  ttl              =    "300"
  records          =    ["${aws_eip_association.eip_assoc.public_ip}"]
}

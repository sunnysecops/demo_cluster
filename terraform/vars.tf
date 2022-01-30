variable "keyName" {
    description = "Enter the Key Name to access"
    type = string
}

variable "amiID" {
    description = "Enter the AMI ID"
    type = string
}

variable "name" {
    description = "Enter Server Name"
    type = string
}

variable "owner" {
    description = "Enter Email ID"
    type = string
}

variable "creator" {
    description = "Enter Email ID"
    type = string
}

variable "access_key" {
    type = string
    default = ""
}

variable "secret_key" {
    type = string
    default = ""
}

variable "region" {
    type = string
    default = "us-east-1"
}

variable "instanceType" {
    description = "Enter Server Instance Type"
    type = string
    default = "t3.medium"
}

variable "spotPrice" {
    type = string
    default = "0.04"
}

variable "subnetId" {
    description = "Enter Server Subnet ID"
    type = string
    default = ""
}

variable "zoneID" {
    description =  "Enter Zone ID for Route53"
    type =  string
}

variable "IAM" {
    description = ""Enter the IAM role to be attached"
    type = string
}

variable "domainName" {
    description = "Enter Domain Name"
    type = string
}

variable "githubUsername" {
    description = "Enter Github Username"
    type = string
}

variable "githubToken" {
    description = "Enter Github Token"
    type = string
}

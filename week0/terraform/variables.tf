variable "AmiId" {
  description = "The ID of the AMI to use for the EC2 instance(Def - Ubuntu Server 20.04 LTS 64-bit x86)"
  type        = string
  default     = "ami-0ca5c3bd5a268e7db"
}

variable "InstanceType" {
  description = "The type of the EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "KeyName" {
  description = "The EC2 Key Pair to allow SSH access to the instance"
  type        = string
  default     = "sshysh-key-pair"
}
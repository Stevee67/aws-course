variable "AWSRegion" {
  description = "Aws region"
  type        = string
  default     = "us-west-2"
}

variable "AZ1" {
  description = "Availability zone 1"
  type        = string
  default     = "us-west-2a"
}

variable "AZ2" {
  description = "Availability zone 2"
  type        = string
  default     = "us-west-2b"
}

variable "AmiId" {
  description = "The ID of the AMI to use for the EC2 instance(Def - Ubuntu Server 20.04 LTS 64-bit x86)"
  type        = string
  default     = "ami-0518bb0e75d3619ca"
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
variable "AsgMinSize" {
  description = "Auto scaling group min size"
  type        = number
  default     = 2
}

variable "AsgMaxSize" {
  description = "Auto scaling group max size"
  type        = number
  default     = 2
}

variable "AsgDesiredCapacity" {
  description = "Auto scaling group desired size"
  type        = number
  default     = 2
}

variable "AsgName" {
  description = "Auto scaling group name"
  type        = string
  default     = "testASG"
}

variable "NatAmiId" {
  description = "The ID of the AMI to use for the EC2 Nat instance"
  type        = string
  default     = "ami-0032ea5ae08aa27a2"
}
variable "HealthyThreshold" {
  description = "healthy threshold"
  type        = number
  default     = 2
}

variable "UnHealthyThreshold" {
  description = "unhealthy threshold"
  type        = number
  default     = 5
}

variable "HealthCheckTimeout" {
  description = "health check timeout"
  type        = number
  default     = 5
}

variable "HealthCheckInterval" {
  description = "health check interval"
  type        = number
  default     = 30
}
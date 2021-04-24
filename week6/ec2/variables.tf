variable "AmiId" {
  type        = string
}
variable "InstanceType" {
  type        = string
}
variable "KeyName" {
  type        = string
}
variable "AZ1" {
  type        = string
}
variable "AZ2" {
  type        = string
}
variable "AsgMinSize" {
  type        = number
}
variable "AsgMaxSize" {
  type        = number
}
variable "AsgDesiredCapacity" {
  type        = number
}
variable "AsgName" {
  type        = string
}
variable "VpcId" {
  type        = string
}
variable "GatewayId" {
  type        = string
}
variable "NatAmiId" {
  type        = string
}
variable "Public1SubnetId" {
  type        = string
}
variable "Private1SubnetId" {
  type        = string
}
variable "Public2SubnetId" {
  type        = string
}
variable "Private2SubnetId" {
  type        = string
}
variable "HealthyThreshold" {
  type        = number
}
variable "UnHealthyThreshold" {
  type        = number
}
variable "HealthCheckTimeout" {
  type        = number
}
variable "HealthCheckInterval" {
  type        = number
}
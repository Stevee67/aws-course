variable "AllocatedStorage" {
  type        = number
}
variable "RdsInstanceType" {
  type        = string
}
variable "DbUsername" {
  type        = string
}
variable "DbPassword" {
  type        = string
}
variable "DbEngine" {
  type        = string
}
variable "DbEngineVersion" {
  type        = string
}
variable "RDSStorageType" {
  type        = string
}
variable "RDSDbName" {
  type        = string
}
variable "RDSDbIdentifier" {
  type        = string
}
variable "privateSecurityGroupId" {
  type        = string
}
variable "AZ" {
  type        = string
}
variable "DbSubnet1" {
  type        = string
}
variable "DbSubnet2" {
  type        = string
}
variable "VpcId" {
  type        = string
}
variable "key_pair_name" {
  description = "The name of the AWS Key Pair"
  default     = "JS-KeyPair"
}
variable "sg_id" {
  description = "The ID of the Security Group to bind to"
  default     = "sg-0400c5d533efd083c"
}
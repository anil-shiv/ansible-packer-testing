variable "region" {
  type    = string
  default = "ap-south-1"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "ami_name" {
  type    = string
  default = "linux-web-app"
}

variable "base_ami" {
  type    = string
  // default = "ami-076e3a557efe1aa9c" //amazon linux
  default = "ami-068257025f72f470d"  // ubuntu market place
}
// ami-05c8ca4485f8b138a

variable "subnet_id" {
  type    = string
  default = "subnet-ccfed3ed"
}

variable "security_group_id" {
  type    = string
  default = "sg-914a0f8f"
}
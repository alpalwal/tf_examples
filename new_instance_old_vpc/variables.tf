variable "properties" {
    type = map(string)
    default = {
      region = "us-east-1"
      vpc = "vpc-fb57a183"
      ami = "ami-053b0d53c279acc90"
      itype = "c4.4xlarge"
      subnet = "subnet-0130fc4a"
      publicip = true
      keyname = "tarikey"
      secgroupname = "tari-sec-group"
      myIP = "67.180.211.150/32"
  }
}
variable "properties" {
    type = map(string)
    default = {
      region = "us-east-1"
      # vpc = "vpc-09c1d3bca16222bea"
      ami = "ami-033cdc7addc34de7b"
      itype = "c5.large"
      # subnet = "subnet-07ec13780613d570a"
      publicip = true
      keyname = "cheetah-ppk"
      secgroupname = "vpn-sec-group"
      myIP1 = "67.180.211.150/32"
      myIP2 = "73.78.46.5/32"
      auth_token = "e08d4ae0fa577f95396e1e8449a1e29e/cb03139419865063d8faa009328bf46b0e2aa921d32a8b3dd055110cd6063098f06d8b45581844973ca424244553a8c0524cb209999b7198466184147e8d3abb/e8e4b6089bf58341c8d3d4bf5a99a024ea59b553b1969d95f843f9f9ea588125"
 
     main_vpc_cidr = "192.168.170.0/24"
     public_subnets = "192.168.170.128/26"
     private_subnets = "192.168.170.192/26"
 
 }
}

# vMX AMI
# https://aws.amazon.com/marketplace/pp/prodview-o5hpcs2rygxnk

# first time in a new TF directory - need to run "terraform init"
# terraform plan
# terraform apply --auto-approve

# terraform destroy --auto-approve



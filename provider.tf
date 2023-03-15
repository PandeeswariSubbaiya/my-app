terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.57.0"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "northvirginabucket1"
   key = "North_Virginia_Keypair/statefile"
   region = "us-east-1"
 }
}

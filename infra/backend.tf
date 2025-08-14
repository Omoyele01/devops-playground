terraform {
  backend "s3" {
    bucket         = "tf-state-omoyele-2025" # <— your bucket
    key            = "envs/dev/infra.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "tf-locks"
    encrypt        = true
  }

  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

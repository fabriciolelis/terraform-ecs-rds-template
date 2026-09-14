terraform {
  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  # Partial config: bucket, key and region are supplied by -backend-config at
  # init time, so one module serves every account and environment.
  backend "s3" {
    encrypt      = true
    use_lockfile = true
  }
}

# provider "aws" {
#   region = "ap-south-1"
# }

# mini stack local provider 
provider "aws" {
  region                      = "ap-south-1"
  access_key                  = "000000000000"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    budgets  = "http://localhost:4566"
    iam      = "http://localhost:4566"
    iot      = "http://localhost:4566"
    s3       = "http://localhost:4566"
    dynamodb = "http://localhost:4566"
    lambda   = "http://localhost:4566"
    sqs      = "http://localhost:4566"
    # kubernetes_pod = "http://localhost:4566"

  }
}

# Using provider_local.tf for MiniStack instead
// components 
resource "aws_budgets_budget" "test" {
  account_id        = "000000000000"
  name              = "monthly aws_budgets_budget"
  budget_type       = "COST"
  time_unit         = "MONTHLY"
  limit_unit        = "USD"
  time_period_start = "2026-11-25_16:59"
  limit_amount      = "500.00"
}

data "aws_iot_endpoint" "example" {
  # region = "ap-south-1"
  endpoint_type = "iot:Data-ATS"
}

# resource "kubernetes_pod_v1" "agent" {
#   metadata {
#     name = "my-device"
#   }

#   spec {
#     container {
#       image = "gcr.io/my-project/image-name"
#       name  = "image-name"

#       env {
#         name  = "IOT_ENDPOINT"
#         value = data.aws_iot_endpoint.example.endpoint_address
#       }
#     }
#   }
# }

data "aws_iot_registration_code" "example" {
  
}


resource "tls_private_key" "verification" {
  algorithm = "RSA"
}

resource "tls_cert_request" "verification" {
  private_key_pem = tls_private_key.verification.private_key_pem
  subject {
    common_name = data.aws_iot_registration_code.example.registration_code
  }
}


output "IOT_ENDPOINT" {
  value = data.aws_iot_endpoint.example
}

output "private_key_pem" {
  sensitive = true
  value = tls_private_key.verification 
}

output "Device_name" {
  value = var.device_name
}
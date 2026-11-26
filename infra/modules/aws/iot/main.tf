terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

data "aws_caller_identity" "current" {}

locals {
  iot_arn = "arn:aws:iot:ap-southeast-1:${data.aws_caller_identity.current.account_id}"
}

# Create IoT Thing
resource "aws_iot_thing" "edge" {
  name = "edge"
}

# Create device certificate
resource "aws_iot_certificate" "edge" {
  active = true
}

# Create security policy
resource "aws_iot_policy" "edge" {
  name = "edge-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "iot:Connect"
        Resource = "${local.iot_arn}:client/robot-01"
      },
      {
        Effect   = "Allow"
        Action   = "iot:Publish"
        Resource = "${local.iot_arn}:topic/robot-01/telemetry"
      },
      {
        Effect   = "Allow"
        Action   = "iot:Subscribe"
        Resource = "${local.iot_arn}:topicfilter/robot-01/commands"
      },
      {
        Effect   = "Allow"
        Action   = "iot:Receive"
        Resource = "${local.iot_arn}:topic/robot-01/commands"
      }
    ]
  })
}

# Attach certificate to robot
resource "aws_iot_thing_principal_attachment" "edge" {
  thing     = aws_iot_thing.edge.name
  principal = aws_iot_certificate.edge.arn
}

# Attach security policy to certificate
resource "aws_iot_policy_attachment" "edge" {
  policy = aws_iot_policy.edge.name
  target = aws_iot_certificate.edge.arn
}

# # Retrieve MQTT endpoint
# data "aws_iot_endpoint" "endpoint" {
#   endpoint_type = "iot:Data-ATS"
# }

# output "iot_endpoint" {
#   value = data.aws_iot_endpoint.endpoint.endpoint_address
# }
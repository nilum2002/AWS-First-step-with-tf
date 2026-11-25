terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_budgets_budget" "test" {
  name              = "monthly aws_budgets_budget"
  budget_type       = "COST"
  time_unit         = "MONTHLY"
  limit_unit        = "USD"
  time_period_start = "2026-11-25_16:59"
  limit_amount = "500.00"
}


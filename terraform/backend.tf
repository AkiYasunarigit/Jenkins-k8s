terraform {
  backend "s3" {
    bucket = "jenkins-app-k8s-2024-us-east-1-v1"
    region = "us-east-1"
    key = "eks/terraform.tfstate"
  }
}
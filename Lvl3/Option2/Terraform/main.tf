
provider "aws" {
  region = "us-west-2"
}

module "ecs" {
  source    = "/Users/bhagi/SRAssesment/Lvl3/Option2/Terraform/Modules/ECS"
  name      = "my-ecs-cluster"
  servers   = 1
  subnet_id = ["subnet-6e131446"]
  vpc_id    = "vpc-99e73dfc"
}
# Terraform ECS RDS template

This terraform project can be used to set up the AWS infrastructure for a dockerized application running on ECS with Fargate launch configuration and an RDS database to be used by the application.

## Resources

This setup creates the following resources:

- VPC
- One public and one private subnet per AZ
- Routing tables for the subnets
- Internet Gateway for public subnets
- NAT gateways with attached Elastic IPs for the private subnet
- Three security groups
  - one that allows HTTP/HTTPS access
  - one that allows access to the specified container port
  - one that allows access to the database
- An ALB + Target Group with listeners for port 80 and 443
- An ECR for the docker images
- An ECS cluster with a service
  and task definition to run docker containers from the ECR (incl. IAM execution role)
- An RDS database
  - protected by a private VPC
  - connect to application
- S3 to upload frontend files
- Cloudfront

  - distribute frontend application
  - work a reserve proxy to backend application running on ECS

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

  ## License

```
Copyright (c) 2021 VIRTUS/UFCG

VIRTUS-HUB LICENSE.

Permission is hereby granted to any person “authorized by VIRTUS” to have a copy of this software and associated documentation files (the "Software"), to deal in the Software WITH restriction to only use, copy, modify and merge it on “VIRTUS authorized projects”.

To permit persons to whom the Software is furnished to do so, the following conditions are required:

1. It is “authorized by VIRTUS” any person with a VIRTUS-HUB account.
2. “VIRTUS authorized project” is a project hosted by VIRTUS-HUB or any project explicit authorized by VIRTUS/UFCG.
3. The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

----

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

----

The LICENSE terms and conditions of the Software can be updated by the copyright owner.
```

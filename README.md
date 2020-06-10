PayCertify Scripting Challenge
===

This app serves as a simple CI system.  It takes two inputs, a build task and the url, to a git repository.  Once the CI application has cloned the repository, it will search for a `pipeline.yml` file, parse it and run commands from the build step if they are valid.

This repository also includes two terraform modules which create a VPC and ECS to deploy the app to Fargate.

## Requirements: 
    
     - Terraform v0.11.x
     - Python 3.7.x
     - Pytest
     


## Command To Run:
   `python ci.py <build step> <url of repo to clone>`
    
***Example***:
    
`python ci.py build https://github.com/PayCertify/devops-scripting-helloworld`


## Tests
    pytest tests/test_file.py

## Terraform Modules
This repository contains two terraform modules (VPC and ECS;See Below). That will create and deploy the application to FARGATE built by the CI script. 

**VPC**

Creates:
- VPC
- Public/Private subnets
- Gateways
- Route Tables
- Security Groups

**ECS**

Creates
- Load balancer
- ECS Cluster
- ECS Task Definition
- ECS Service


# Terraform IAC: ECS workflow with Fargate

This project has two goals:

1. Create an underline architecture for ECS with Fargate and deploy latest image into AWS
2. Create CI/CD pipeline to push Docker image from a Java git repository to ECR

## Architecture

![alt text](ECS_Fargate-ECS.drawio.png)

## CICD

![alt text](ECS_Fargate-CICD.drawio.png)

### Java Container Application

This repository is used as example for the deployment
Git: https://github.com/cevoaustralia/java-ecs-demo

## Deployment Guide

This terraform project is divided by two modules

1. INFRA

   - Contains all infrastructure since Networking to ECS
   - The reason to be deployed later is because ECS task definition will fail without the image on ECR

2. CICD
   - Code Pipelien deployment
   - Connects with Java Application Git Repository
   - Push Java application docker container image into ECR
   - Deploy image into ECS

### Deployment

You can deploy the modules separately or all together, if is done separately the first time you will need to deploy the Infra module first

```
     terraform plan -target=module.infra -out=infra.tfplan
     terraform apply infra.tfplan
```

Then the CICD modules

```
     terraform plan -target=module.cicd -out=cicd.tfplan
     terraform apply cicd.tfplan
```

Or you can deploy all together

```
     terraform plan -out=tf.plan
     terraform apply tf.plan
```

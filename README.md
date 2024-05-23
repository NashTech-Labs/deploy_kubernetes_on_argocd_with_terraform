# Terraform Configuration for ArgoCD Deployment

This repository contains Terraform configuration files to deploy ArgoCD on a Kubernetes cluster.

## Files Included

- `file.tf`: Terraform configuration file defining the Kubernetes resources required for ArgoCD deployment.
- `terraform.tfvars`: Terraform variables file containing values for customization.
- `vars.tf`: Terraform variables definition file.

## Customization

You can customize the deployment by modifying the variables in the `terraform.tfvars` file. The variables include cluster name, namespace name, secret and config map names, deployment and service names, image version, ports, and other configuration options.

## Prerequisites

- A Kubernetes cluster configured and accessible from your local machine.
- Terraform installed on your local machine.
- Proper permissions to create resources in the Kubernetes cluster.


## **Getting Started**

1. Clone the repository: $ git clone https://github.com/NashTech-Labs/deploy_kubernetes_on_argocd_with_terraform.git

2. Navigate to the repository: $ cd deploy_kubernetes_on_argocd_with_terraform

3. Review and customize variable values in terraform.tfvars.

4. Initialize Terraform: $ terraform init

5. Generate and review the Terraform plan: $ terraform plan

6. Apply the Terraform configuration: $ terraform apply

7. To destroy the deployed resources, run: $ terraform destroy

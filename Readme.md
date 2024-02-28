# Learn AWS with Terraform

## What is Terraform?

Terraform is a tool for building, changing, and versioning infrastructure safely and efficiently. Terraform can manage existing and popular service providers as well as custom in-house solutions.

## How to install Terraform?

### Linux

1. Download the latest version of Terraform from [here](https://www.terraform.io/downloads.html).
2. Unzip the downloaded file.
3. Move the executable file to `/usr/local/bin/`.
4. Run `terraform --version` to verify the installation.
5. Done!

## How to use Terraform?

### Step 1: Create a directory

Create a directory for your Terraform configuration files.

### Step 2: Create a Terraform configuration file

Create a file named `main.tf` in the directory you created in step 1.

### Step 3: Initialize Terraform

Run `terraform init` to initialize Terraform.

### Step 4: Create a Terraform execution plan

Run `terraform plan` to create a Terraform execution plan.

### Step 5: Apply the Terraform execution plan

Run `terraform apply` to apply the Terraform execution plan.

### Step 6: Destroy Terraform resources

Run `terraform destroy` to destroy Terraform resources.

## How to use Terraform with AWS?

### Step 1: Create an IAM user

1. Go to [AWS IAM](https://console.aws.amazon.com/iam/home).
2. Click on `Users` in the left sidebar.
3. Click on `Add user`.
4. Enter a name for the user.
5. Select `Programmatic access`.
6. Click on `Next: Permissions`.
7. Select `Attach existing policies directly`.
8. Select `AdministratorAccess`. (This is not recommended for production environments.)
9. Click on `Next: Tags`.
10. Click on `Next: Review`.
11. Click on `Create user`.
12. Copy the `Access key ID` and `Secret access key` to a safe place.
13. set aws cli credentials using `aws configure` command.

### Step 2: Setup remote state

1. Create s3 bucket for remote state. (e.g. `terraform-remote-state`) using `aws s3api create-bucket --bucket terraform-remote-state-0001 --region us-east-1 --create-bucket-configuration LocationConstraint=ap-south-1`
2. Create a DynamoDB table for state locking. (e.g. `terraform-state-lock`) using `aws dynamodb create-table --table-name terraform-state-lock --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1`
3. in `main.tf` file add following code
```hcl
terraform {
  backend "s3" {
    bucket         = "terraform-remote-state"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
  }
}
```
4. other terraform commands will work as usual. 
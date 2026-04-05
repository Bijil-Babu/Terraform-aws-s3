# Terraform AWS S3 Bucket

This project provisions an S3 bucket on AWS using Terraform. It uses a separate S3 bucket to store the Terraform state file remotely, with encryption and native state locking enabled.

---

## What This Does

- Creates an S3 bucket (`s3-bucket-terraform-9645`) in `us-east-1`
- Stores Terraform state remotely in `bijil-test-terraform-state`
- Encrypts the state file at rest
- Locks state during operations using `use_lockfile = true` — this is a Terraform 1.10+ feature that uses S3 directly for locking, so no DynamoDB table is needed

---

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) v1.10 or later
- AWS CLI installed and configured (`aws configure`)
- The state bucket must already exist in AWS before running `terraform init` — Terraform cannot create its own backend bucket

---

## Project Structure

```
.
├── main.tf         # Infrastructure and backend config
└── .gitignore      # Keeps sensitive and generated files out of git
```

---

## Important: Create the State Bucket First

Before running `terraform init`, the remote state bucket needs to exist in AWS. Terraform will try to connect to it during initialisation and will fail if it doesn't exist yet.

The simplest way to handle this is to create it manually in the AWS console:

1. Go to S3 in the AWS console
2. Create a bucket named `bijil-test-terraform-state` in `us-east-1`
3. Enable server-side encryption on the bucket
4. Block all public access

Once the bucket exists, Terraform can use it as a backend and you never need to touch it again.

---

## Usage

```bash
# First time setup
terraform init -upgrade

# See what Terraform will create
terraform plan

# Create the resources
terraform apply

# Tear everything down
terraform destroy
```

---

## Best Practices Applied

| Practice | Implementation |
|---|---|
| Remote state | State stored in S3 instead of locally |
| State encryption | `encrypt = true` in backend config |
| State locking | `use_lockfile = true` prevents two runs corrupting state at the same time |
| Provider version pinning | AWS provider locked to `~> 6.0` |
| No hardcoded credentials | AWS credentials come from CLI config, never written in code |
| Resource tagging | Every resource tagged with `Name` and `Environment` |
| Clean `.gitignore` | Provider binaries, state files, and secrets excluded from git |
| Single terraform block | `backend` and `required_providers` merged into one block to avoid HCL parse errors |

---

## What Not to Commit

One thing worth knowing — the `.terraform/` folder that gets created when you run `terraform init` contains the provider binary which is around 800MB. Committing it to GitHub will fail because GitHub has a 100MB file size limit. The `.gitignore` in this repo handles all of this, but it is worth understanding why each entry is there:

```
.terraform/           # Provider binaries, recreated by terraform init on any machine
*.tfstate             # Contains resource details and can include sensitive data
*.tfstate.backup      # Same as above
*.tfvars              # Used for variable values, may contain secrets
.terraform.lock.hcl   # Records provider versions, safe to exclude for personal projects
```

---

## State File Location

Once applied, the state file lives at:

```
s3://bijil-test-terraform-state/dev/terraform.tfstate
```

---

## Author

Bijil Babu

# Infrastructure as Code (IaC) Best Practices for Multi-Cloud Environments

## 🎓 Project Overview
This project demonstrates Infrastructure as Code best practices for managing resources across multiple cloud providers (AWS and Google Cloud Platform).

**Author:** Kasra Gerami
**Programme:** MSc Computing (Internet Technology and Security)
**University:** University of Northampton
**Thesis Title:** Infrastructure as Code (IaC) Best Practices for Multi-Cloud Environments

---

## 🌐 Application

This project deploys a **Community Events Web Application** across multiple cloud platforms using Infrastructure as Code principles.

### Application Features:
- Event management system
- Admin panel for CRUD operations
- User authentication
- Responsive design
- MySQL database backend

### Technologies:
- **Frontend:** HTML5, CSS3, JavaScript
- **Backend:** PHP
- **Database:** MySQL
- **Containerization:** Docker
- **Infrastructure:** Terraform

---

## ☁️ Cloud Providers

- **Amazon Web Services (AWS)**
  - EC2 for compute
  - RDS for MySQL database
  - VPC for networking

- **Google Cloud Platform (GCP)**
  - Compute Engine for compute
  - Cloud SQL for MySQL database
  - VPC for networking

---

## 🛠️ Tools & Technologies

| Category | Tool | Purpose |
|----------|------|---------|
| Infrastructure as Code | Terraform | Provisioning cloud resources |
| Security Scanning | Checkov | Security policy enforcement |
| CI/CD | GitHub Actions | Automated testing and deployment |
| Version Control | Git | Code management |
| Containerization | Docker | Application packaging |

---

## 📂 Project Structure
```
iac-multi-cloud-thesis/
├── app/                  # Community Events web application
│   ├── admin/           # Admin panel
│   ├── css/             # Stylesheets
│   ├── js/              # JavaScript files
│   ├── php/             # PHP backend
│   ├── Dockerfile       # Docker configuration
│   └── docker-compose.yml
│
├── aws/                 # AWS infrastructure code
│   ├── main.tf         # Main Terraform configuration
│   ├── compute.tf      # EC2 instances
│   ├── database.tf     # RDS database
│   └── network.tf      # VPC and security groups
│
├── gcp/                 # GCP infrastructure code
│   ├── main.tf         # Main Terraform configuration
│   ├── compute.tf      # Compute Engine instances
│   ├── database.tf     # Cloud SQL database
│   └── network.tf      # VPC and firewall rules
│
├── modules/             # Reusable Terraform modules
│   ├── docker-host/    # Docker host configuration
│   └── mysql-db/       # MySQL database module
│
├── policies/            # Security policies
│   └── checkov/        # Checkov security rules
│
└── .github/             # CI/CD workflows
    └── workflows/
```

---

## 🚀 Getting Started

### Prerequisites
- Terraform >= 1.0
- AWS CLI configured
- Google Cloud CLI configured
- Docker (for local testing)
- Git

### Local Testing (Docker)
```bash
# Navigate to app directory
cd app

# Start the application
docker-compose up -d

# Access the application
# Main site: http://localhost:9090
# phpMyAdmin: http://localhost:9091
```

### Deploy to AWS
```bash
# Navigate to AWS directory
cd aws

# Initialize Terraform
terraform init

# Review the plan
terraform plan

# Apply the infrastructure
terraform apply
```

### Deploy to GCP
```bash
# Navigate to GCP directory
cd gcp

# Initialize Terraform
terraform init

# Review the plan
terraform plan

# Apply the infrastructure
terraform apply
```

---

## 🔒 Security

This project implements security best practices:
- ✅ Automated security scanning with Checkov
- ✅ Infrastructure code validation before deployment
- ✅ Secure database configurations
- ✅ Network security with firewalls and security groups
- ✅ Encrypted data at rest and in transit

---

## 📊 Testing & Evaluation

### Metrics Collected:
1. **Performance Metrics**
   - Deployment time (AWS vs GCP)
   - Resource creation time
   
2. **Cost Analysis**
   - Monthly operational costs
   - Cost comparison between clouds

3. **Security Metrics**
   - Number of security issues found
   - Security improvements after fixes

4. **Reliability Metrics**
   - Deployment success rate
   - Infrastructure recovery time

---

## 📝 Documentation

Detailed documentation for each component:
- [Application Documentation](./app/README.md)
- AWS Infrastructure Guide (Coming soon)
- GCP Infrastructure Guide (Coming soon)
- Security Policies Guide (Coming soon)

---

## 🎯 Project Goals

1. ✅ Demonstrate IaC principles with Terraform
2. ✅ Deploy application on multiple cloud platforms
3. ✅ Implement security best practices
4. ✅ Automate testing and deployment
5. ✅ Provide comparative analysis of cloud providers
6. ✅ Create reusable, maintainable infrastructure code

---

## 📧 Contact

**Kasra Gerami**
MSc Computing Student
University of Northampton
GitHub: [@kasragerami68](https://github.com/kasragerami68)

---

## 📄 License

This project is created for academic purposes as part of a Master's thesis at the University of Northampton.

---

**Last Updated:** January 2025
## 🔄 CI/CD Pipeline

This project uses GitHub Actions for automated testing and security scanning:

- **AWS Pipeline**: Validates Terraform code and runs Checkov security scans
- **GCP Pipeline**: Validates Terraform code and runs Checkov security scans
- **Triggers**: Automatically runs on every push and pull request

Last tested: December 14, 2025
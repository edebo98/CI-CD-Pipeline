# CI/CD Pipeline with GitHub Actions, Docker & AWS ECS

![AWS](https://img.shields.io/badge/AWS-ECS-orange) ![Terraform](https://img.shields.io/badge/IaC-Terraform-purple) ![Docker](https://img.shields.io/badge/Container-Docker-blue) ![GitHub Actions](https://img.shields.io/badge/CI%2FCD-GitHub%20Actions-green)

A production-ready CI/CD pipeline that automatically builds, containerizes, and deploys a Node.js application to AWS ECS Fargate using Infrastructure as Code.

## 🏗️ Architecture

```
GitHub Push → GitHub Actions → Docker Build → ECR → ECS Fargate → Load Balancer → Internet
```

**Components:**
- Application Load Balancer distributes traffic across containers
- ECS Fargate runs containerized application (serverless)
- ECR stores Docker images
- VPC with multi-AZ deployment for high availability
- CloudWatch for monitoring and logs

## 🚀 Live Demo

**Application URL:** `http://app-alb-542726861.us-east-1.elb.amazonaws.com`

## 🛠️ Tech Stack

| Category | Technology |
|----------|-----------|
| Application | Node.js + Express |
| Containerization | Docker |
| Container Registry | Amazon ECR |
| Orchestration | Amazon ECS (Fargate) |
| Load Balancing | Application Load Balancer |
| Infrastructure | Terraform |
| CI/CD | GitHub Actions |
| Monitoring | AWS CloudWatch |
| Networking | VPC, Subnets, Security Groups |

## 📋 Prerequisites

Before you begin, ensure you have:

- ✅ AWS Account with appropriate IAM permissions
- ✅ GitHub Account
- ✅ Docker Desktop installed
- ✅ Terraform installed (v1.0+)
- ✅ AWS CLI configured
- ✅ Node.js installed (v18+)
- ✅ Git installed

## 🚀 Quick Start

### 1. Clone Repository
```bash
git clone https://github.com/yourusername/aws-ecs-cicd-pipeline.git
cd aws-ecs-cicd-pipeline
```

### 2. Test Locally
```bash
cd app
npm install
node server.js
```
Visit `http://localhost:3000`

### 3. Deploy Infrastructure
```bash
cd infra
terraform init
terraform apply
```

### 4. Configure CI/CD
Add GitHub Secrets:
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_REGION`

### 5. Deploy Application
```bash
git add .
git commit -m "Deploy application"
git push origin main
```

GitHub Actions will automatically build and deploy! 🎉

## 📁 Project Structure

```
.
├── .github/
│   └── workflows/
│       └── deploy.yml              # CI/CD pipeline configuration
├── app/
│   ├── server.js                   # Node.js application
│   ├── package.json                # Dependencies
│   └── Dockerfile                  # Container configuration
├── infra/
│   ├── vpc.tf                      # VPC and networking
│   ├── ecs.tf                      # ECS cluster and services
│   ├── alb.tf                      # Load balancer
│   ├── ecr.tf                      # Container registry
│   ├── iam.tf                      # IAM roles and policies
│   ├── variables.tf                # Input variables
│   └── outputs.tf                  # Output values
├── CHALLENGES_SECTION.md           # Troubleshooting guide
└── README.md                       # This file
```

## 🔧 Local Development

### Run Application Locally
```bash
cd app
npm install
npm start
```

### Build Docker Image
```bash
docker build -t my-app .
```

### Run Docker Container
```bash
docker run -p 3000:3000 my-app
```

### Test Application
```bash
curl http://localhost:3000
# Output: Hello from CI/CD Pipeline!
```

## ☁️ AWS Infrastructure

### Deploy with Terraform

**Initialize Terraform:**
```bash
cd infra
terraform init
```

**Preview Changes:**
```bash
terraform plan
```

**Deploy Infrastructure:**
```bash
terraform apply
```

**Get Load Balancer URL:**
```bash
terraform output alb_dns_name
```

### Infrastructure Components

Terraform creates:
- ✅ VPC with public subnets (Multi-AZ)
- ✅ Internet Gateway and route tables
- ✅ Security groups (ALB and ECS)
- ✅ ECR repository
- ✅ ECS cluster (Fargate)
- ✅ ECS task definition
- ✅ ECS service with load balancer
- ✅ Application Load Balancer
- ✅ Target group with health checks
- ✅ CloudWatch log group
- ✅ IAM roles and policies

## 🔄 CI/CD Pipeline

### GitHub Actions Workflow

The pipeline automatically:

1. **Checkout Code** - Clones repository
2. **Configure AWS** - Authenticates with AWS
3. **Login to ECR** - Gets container registry credentials
4. **Build Image** - Creates Docker image
5. **Tag Image** - Tags with commit SHA
6. **Push to ECR** - Uploads to container registry
7. **Update ECS** - Deploys new version

### Trigger Pipeline

```bash
# Make any change
echo "Updated app" >> app/server.js

# Commit and push
git add .
git commit -m "Update application"
git push origin main
```

Watch deployment in **Actions** tab on GitHub!

### Pipeline Configuration

Location: `.github/workflows/deploy.yml`

```yaml
on:
  push:
    branches: [ main ]
```

**Triggers:** Automatic on push to `main` branch

## 🔐 Security Setup

### GitHub Secrets Configuration

1. Go to GitHub Repository
2. Navigate to **Settings** → **Secrets and variables** → **Actions**
3. Add these secrets:

| Secret Name | Value |
|------------|-------|
| `AWS_ACCESS_KEY_ID` | Your AWS access key |
| `AWS_SECRET_ACCESS_KEY` | Your AWS secret key |
| `AWS_REGION` | `us-east-1` (or your region) |

### AWS IAM Permissions Required

Your IAM user needs:
- ECR (push/pull images)
- ECS (update services)
- CloudWatch (write logs)

## 🔍 Verification & Testing

### Check ECS Service
```bash
aws ecs describe-services \
  --cluster my-ecs-cluster \
  --services my-app-service \
  --region us-east-1
```

### Check Running Tasks
```bash
aws ecs list-tasks \
  --cluster my-ecs-cluster \
  --service-name my-app-service \
  --region us-east-1
```

### Check Target Health
```bash
aws elbv2 describe-target-health \
  --target-group-arn <YOUR_TG_ARN> \
  --region us-east-1
```

### View Application Logs
```bash
aws logs tail /ecs/my-app --follow --region us-east-1
```

### Test Application
```bash
curl http://<YOUR_ALB_DNS>
# Expected: Hello from CI/CD Pipeline!
```

## 📊 Monitoring

### CloudWatch Dashboards
- Container CPU/Memory usage
- Request count and latency
- Target health status
- Task events

### Application Logs
All application logs are sent to CloudWatch Logs:
- Log Group: `/ecs/my-app`
- Retention: 7 days

### Health Checks
- **Type:** HTTP
- **Path:** `/`
- **Interval:** 30 seconds
- **Timeout:** 5 seconds
- **Healthy threshold:** 2
- **Unhealthy threshold:** 2

## 🐛 Troubleshooting

### Common Issues

**Issue: Targets unhealthy**
```bash
# Check security groups
aws ec2 describe-security-groups --group-ids <SG_ID>

# Verify app is listening on 0.0.0.0
```

**Issue: ECS task not starting**
```bash
# Check service events
aws ecs describe-services --cluster my-ecs-cluster --services my-app-service

# Check CloudWatch logs
aws logs tail /ecs/my-app --since 10m
```

**Issue: Image not found**
```bash
# Verify image in ECR
aws ecr describe-images --repository-name my-app-repo
```

See [CHALLENGES_SECTION.md](./CHALLENGES_SECTION.md) for detailed troubleshooting steps.

## 🧹 Cleanup

To avoid AWS charges, destroy all resources:

```bash
cd infra
terraform destroy
```

Type `yes` when prompted.

**Warning:** This will delete all resources including:
- ECS cluster and services
- Load balancer
- ECR repository and images
- VPC and networking components

## 💰 Cost Estimate

Running this infrastructure 24/7:

| Service | Monthly Cost (Estimate) |
|---------|------------------------|
| ECS Fargate (1 task) | ~$15 |
| Application Load Balancer | ~$20 |
| ECR Storage | ~$1 |
| Data Transfer | ~$5 |
| **Total** | **~$41/month** |

**Cost Savings:** Use `terraform destroy` when not needed!

## 📈 Performance

- **Cold Start:** < 2 seconds
- **Response Time:** < 50ms
- **Availability:** Multi-AZ (99.99%)
- **Scaling:** Manual (can be automated)

## 🚀 Future Enhancements

**Planned Improvements:**
- [ ] Implement auto-scaling based on CPU/memory
- [ ] Add HTTPS with ACM certificate
- [ ] Blue-green deployment strategy
- [ ] RDS database integration
- [ ] AWS WAF for security
- [ ] Route53 custom domain
- [ ] Multi-environment setup (dev/staging/prod)
- [ ] Infrastructure testing with Terratest
- [ ] AWS X-Ray for tracing
- [ ] Secrets Manager for credentials

## 📝 Technical Requirements

✅ **Application**: Node.js web server  
✅ **Docker**: Containerized application  
✅ **Terraform**: Infrastructure as Code  
✅ **GitHub Actions**: Automated CI/CD  
✅ **AWS ECS**: Container orchestration  
✅ **Load Balancer**: Traffic distribution  
✅ **VPC**: Network isolation  
✅ **Monitoring**: CloudWatch integration  

## 🎓 Learning Outcomes

This project demonstrates:
- Container orchestration with ECS
- Infrastructure as Code with Terraform
- CI/CD pipeline implementation
- AWS networking and security
- Docker containerization
- Automated deployments
- Cloud architecture design
- Troubleshooting and debugging

## 📚 Documentation

- [AWS ECS Documentation](https://docs.aws.amazon.com/ecs/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Docker Documentation](https://docs.docker.com/)

## 🤝 Contributing

This is a portfolio project, but feedback is welcome!

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

## 📄 License

This project is open source and available under the MIT License.

## 👤 Author

**Edebo**
- LinkedIn: www.linkedin.com/in/edeboonoja


## 🙏 Acknowledgments

- AWS Documentation Team
- Terraform Community
- DevOps Community
- GitHub Actions Team

---

**⚠️ Important Reminders:**

1. **Destroy resources when done**: `terraform destroy`
2. **Rotate AWS credentials** regularly
3. **Review AWS bills** monthly
4. **Keep dependencies updated**

**📧 Questions?** Open an issue or reach out!

**⭐ Like this project?** Give it a star on GitHub!


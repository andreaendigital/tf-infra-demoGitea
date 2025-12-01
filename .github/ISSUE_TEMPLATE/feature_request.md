---
name: 🚀 Feature Request
about: Suggest a new infrastructure feature or improvement for the Terraform project
title: "[FEATURE] "
labels: "enhancement"
assignees: ""
---

## Feature Description

**SCRUM Ticket:** SCRUM-XXX

### What feature would you like to see?

<!-- Clear description of the proposed infrastructure feature -->

### Why is this feature needed?

<!-- Business value, scalability benefits, and infrastructure improvement -->

---

## Infrastructure Requirements

**Affected Components:**

- [ ] EC2 (compute instances)
- [ ] RDS (database)
- [ ] Load Balancer
- [ ] Security Groups
- [ ] Networking (VPC, Subnets, Route Tables)
- [ ] S3 (storage)
- [ ] Monitoring (CloudWatch, logs)
- [ ] CI/CD Pipeline
- [ ] Other (please specify)

### Terraform Changes Required

- [ ] New modules to create
- [ ] Existing modules to modify
- [ ] New variables to add
- [ ] New outputs to define
- [ ] State backend configuration changes

### Jenkinsfile Changes Required

- [ ] New pipeline stages to add
- [ ] Existing stages to modify
- [ ] Environment variables to update
- [ ] Build parameters to add
- [ ] Post-deployment validations needed
- [ ] Rollback stages needed

### Resource Details

```
List any new AWS resources needed:
- Example: EC2 instance type, RDS engine, Load Balancer type, etc.
```

### AWS Services Impact

- **Regions affected:**
- **Availability Zones:**
- **Estimated cost impact:** High / Medium / Low

---

## 🔐 Security & Compliance

- [ ] Security groups configured properly
- [ ] IAM roles/policies reviewed
- [ ] Encryption enabled where applicable
- [ ] Compliance requirements met
- [ ] VPC isolation verified

---

## ✅ Acceptance Criteria

- [ ] Terraform code validates successfully (`terraform validate`)
- [ ] `terraform plan` shows expected resources
- [ ] All variables are documented
- [ ] Outputs defined for dependent modules
- [ ] Security best practices applied
- [ ] Monitoring configured
- [ ] Documentation updated (README.md)

## 🧪 Testing Requirements

- [ ] Terraform plan reviewed
- [ ] Infrastructure deployed in dev environment
- [ ] Resource connectivity verified
- [ ] Monitoring alerts tested
- [ ] Rollback procedure tested
- [ ] State backup verified

## 📋 Implementation Details

**Terraform Modules to use:**

```
Example: vpc, ec2, rds, security-groups, etc.
```

**Dependencies:**

```
List any dependencies or prerequisites
```

**Estimated Timeline:** [ ] 1-2 days [ ] 3-5 days [ ] 1-2 weeks [ ] 2+ weeks

**Priority:** [ ] Critical 🔴 [ ] High 🟠 [ ] Medium 🟡 [ ] Low 🟢
**Estimated Effort:** [ ] Small (XS) [ ] Medium (M) [ ] Large (L) [ ] Extra Large (XL)

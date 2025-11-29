---
name: 🐛 Bug Report
about: Report a bug or issue in the Terraform Infrastructure
title: "[BUG] "
labels: "bug"
assignees: ""
---

## 🐛 Bug Description

**Affected Component:**

- [ ] EC2
- [ ] RDS
- [ ] Load Balancer
- [ ] Security Groups
- [ ] Networking
- [ ] S3
- [ ] Monitoring
- [ ] CI/CD Pipeline
- [ ] Other (please specify)

### What happened?

<!-- Clear description of the infrastructure issue -->

### What should have happened?

<!-- Expected behavior or desired state -->

---

## 🔄 Reproduction Steps

1. Step 1
2. Step 2
3. Step 3

## 🌐 Environment

- **Terraform Version:**
- **AWS Region:**
- **Environment:** [ ] Development [ ] Staging [ ] Production
- **OS:** Windows / Linux / macOS
- **Backend:** S3 / Local

## 📋 Error Details

```
Paste terraform error logs here (terraform plan, terraform apply output)
```

### Terraform Output

```bash
# Run: terraform plan
# Or: terraform show
```

### State Information (if applicable)

```
Describe any state-related issues or inconsistencies
```

## 🔧 Jenkins Pipeline Information (if applicable)

**Is the bug related to the CI/CD pipeline?** [ ] Yes [ ] No

### Jenkinsfile Issues

- [ ] Pipeline stage failure
- [ ] Environment variable issue
- [ ] Build parameter problem
- [ ] Validation stage error
- [ ] Deployment stage failure
- [ ] Rollback procedure issue
- [ ] Post-deployment validation failure

### Pipeline Error Logs

```
Paste Jenkins console output here
```

**Pipeline Build Number:** #XXX
**Failed Stage:**

## 🧪 Validation Checklist

- [ ] Bug reproduced locally
- [ ] `terraform validate` executed
- [ ] `terraform plan` output collected
- [ ] Error logs attached
- [ ] State backup verified

## 📊 Additional Context

- **Related SCRUM Ticket:** SCRUM-XXX
- **Affected Resources:** List any resources impacted
- **Potential Impact:** [ ] Blocking [ ] High [ ] Medium [ ] Low

**Priority:** [ ] Critical 🔴 [ ] High 🟠 [ ] Medium 🟡 [ ] Low 🟢

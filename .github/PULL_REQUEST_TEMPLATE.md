# Pull Request - Terraform Infrastructure

## Summary

**SCRUM Ticket:** `SCRUM-XXX`
**Type:**

- [ ] New Infrastructure
- [ ] Resource Update
- [ ] Bug Fix
- [ ] Optimization
- [ ] Documentation

### What changes does this PR include?

<!-- Describe your infrastructure changes here -->

### Affected Resources

<!-- List the Terraform resources that are modified -->

- [ ] EC2
- [ ] RDS
- [ ] Load Balancer
- [ ] Security Groups
- [ ] Networking
- [ ] S3
- [ ] Monitoring

### Related Issues

<!-- Link related issues: Closes #XXX, Fixes #XXX -->

---

## Terraform Validation

### Test Commands

```bash
# Validate syntax
terraform validate

# Plan changes
terraform plan -out=tfplan

# Show specific changes
terraform show tfplan
```

### Validation Status

- [ ] `terraform validate` - Passed ✓
- [ ] `terraform plan` - Reviewed without errors
- [ ] `terraform fmt` - Applied
- [ ] No unexpected destructive changes
- [ ] Variables documented

---

## Infrastructure Changes

### Networking Changes

- [ ] VPC modified
- [ ] Subnets added/modified
- [ ] Route tables updated
- [ ] Internet Gateway modified

### Security Changes

- [ ] Security Groups updated
- [ ] Ingress/egress rules reviewed
- [ ] SSL certificates updated

### Compute Changes

- [ ] EC2 instances added/modified
- [ ] Auto Scaling updated
- [ ] AMI updated

### Database Changes

- [ ] RDS updated
- [ ] Snapshots created before changes
- [ ] Backup policy reviewed

### Storage Changes

- [ ] S3 buckets created/modified
- [ ] Access policies updated
- [ ] Versioning configured

---

## Deployment Impact

- [ ] No downtime expected
- [ ] Minimal downtime required (specify time)
- [ ] Destructive changes - requires special approval
- [ ] Requires rollback plan

**Rollback Plan (if applicable):**

<!-- Describe the rollback plan in case of issues -->

---

## Pre-merge Checklist

- [ ] Terraform code reviewed
- [ ] Plan verified without errors
- [ ] Variables and outputs documented
- [ ] Remote state backend verified
- [ ] Infrastructure changes approved
- [ ] Documentation updated (README.md)
- [ ] No secrets in code
- [ ] Jenkinsfile / CI-CD changes reviewed

### Jenkinsfile / CI-CD Summary (if applicable)

```
Describe any changes to the Jenkinsfile or CI/CD pipeline here:
- New/modified pipeline stages
- Environment variables or credentials changed
- New build parameters or flags
- Post-deploy validations added
- Rollback steps added/modified
```

**Reviewer:** @<!-- username -->
**Target Environment:**
| Component | Status | Verified |
|-----------|--------|----------|
| Terraform Plan | <!-- output summary --> | [ ] Yes |
| Backend S3 | <!-- bucket name --> | [ ] Yes |
| Destructive Changes | <!-- Yes/No --> | [ ] Reviewed |

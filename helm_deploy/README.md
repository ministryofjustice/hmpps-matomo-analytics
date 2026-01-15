# HMPPS Matomo Analytics - Deployment

This deploys a containerized Matomo analytics instance running as non-root with nginx + PHP-FPM.

## Prerequisites

### 1. Helm v4 Client
```sh
helm version
```

### 2. TLS Certificate
Ensure a certificate exists in the cloud-platform-environments repo:
```
cloud-platform-environments/namespaces/live.cloud-platform.service.justice.gov.uk/hmpps-matomo-analytics-<env>/certificate.yaml
```

### 3. Database Secret
The `matomo-rds` secret must exist in the namespace with these keys:
- `rds_instance_address`
- `database_name`
- `database_username`
- `database_password`

### 4. PersistentVolumeClaim (Manual Step)
**Must be created before first deployment** - GitHub Actions lacks PVC permissions.

Edit `helm_deploy/pvc.yaml` to set the correct namespace, then apply:
```sh
kubectl apply -f helm_deploy/pvc.yaml -n hmpps-analytics-dev
```

This creates a 10Gi gp3 EBS volume for `/var/www/html/config`, `/var/www/html/plugins`, and `/var/www/html/tmp`.

**Note:** Due to ReadWriteOnce access mode (gp3 limitation), only 1 replica is supported.

## Useful Commands

**List releases:**
```sh
helm list -n hmpps-analytics-dev
```

**View history:**
```sh
helm history hmpps-matomo-analytics -n hmpps-analytics-dev
```

**Rollback:**
```sh
helm rollback hmpps-matomo-analytics <revision> -n hmpps-analytics-dev --wait
```

**Check PVC:**
```sh
kubectl get pvc matomo-pvc -n hmpps-analytics-dev
```

**View logs:**
```sh
kubectl logs -f -l app=hmpps-matomo-analytics -n hmpps-analytics-dev
```

# Create CronJob
cat <<'EOF' > backup-cronjob.yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: backup-job
  namespace: batch-jobs
spec:
  schedule: "0 2 * * *"  # 2 AM every day
  concurrencyPolicy: Allow
  successfulJobsHistoryLimit: 3
  failedJobsHistoryLimit: 1
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: backup
            image: busybox:stable
            command: ["sh", "-c", "echo 'Running backup...'; echo 'Backup completed at '$(date)"]
          restartPolicy: OnFailure
EOF
kubectl apply -f backup-cronjob.yaml

# Verify CronJob
kubectl get cronjob -n batch-jobs
kubectl describe cronjob backup-job -n batch-jobs

# Create job manually for testing (optional)
kubectl create job --from=cronjob/backup-job/backup-job backup-job-manual -n batch-jobs 2>/dev/null || true
kubectl get jobs -n batch-jobs

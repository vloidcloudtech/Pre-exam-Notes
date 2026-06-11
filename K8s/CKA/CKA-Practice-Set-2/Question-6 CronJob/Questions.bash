# Question:
# Schedule tasks to run on a specific schedule using CronJob. This is useful for
# cleanup, backups, and maintenance tasks.

# Task:
# 1. Create a namespace called 'batch-jobs'
# 2. Create a CronJob named 'backup-job' that:
#    - Runs every day at 2 AM
#    - Executes a backup script
#    - Uses busybox image with echo command
# 3. Set successfulJobsHistoryLimit to 3
# 4. Set failedJobsHistoryLimit to 1
# 5. Set concurrencyPolicy to Allow
# 6. Manually trigger the job and verify it creates a Job resource

# Video Link - TBD

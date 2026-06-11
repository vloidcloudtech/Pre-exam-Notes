# Question 16 – Mount Secret as Volume

Mount a Secret as a volume in a Pod for secure credential handling.

## Your Task

1. Create a Secret named `app-secret` with:
   - `username: admin`
   - `password: SecurePass123!`
2. Create a Pod named `secret-consumer` that:
   - Mounts the Secret as a volume at `/etc/secrets`
   - Runs a command that reads the secret files
3. Verify the secret files are readable in the pod
4. Verify permissions are set correctly (readable but not writable)

## Docs

- [Secrets](https://kubernetes.io/docs/concepts/configuration/secret/)
- [Mounting Secrets as Volumes](https://kubernetes.io/docs/concepts/configuration/secret/#mounting-a-secret-as-a-file-through-a-volume)

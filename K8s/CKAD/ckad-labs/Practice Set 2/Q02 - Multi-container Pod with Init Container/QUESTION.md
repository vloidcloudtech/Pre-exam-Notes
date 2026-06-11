# Question 2 – Multi-container Pod with Init Container

You need to create a pod with an init container that prepares the environment before the main application starts. The init container should download a configuration file.

## Your Task

1. Create a Pod named `app-with-init` in namespace `default`
2. The pod must have:
   - An init container that creates a config file at `/shared/config.txt`
   - A main application container that reads the config file
   - A shared volume (emptyDir) between init and main containers
3. Verify the init container completes before main container starts
4. Verify the main container can access the config file

## Docs

- [Init Containers](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/)
- [Volumes](https://kubernetes.io/docs/concepts/storage/volumes/)

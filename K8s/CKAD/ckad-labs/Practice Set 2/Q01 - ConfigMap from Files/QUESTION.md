# Question 1 – ConfigMap from Files

A web application needs configuration files stored in ConfigMap. You have the following configuration files that need to be loaded:

- `app.conf`: Contains application settings
- `database.conf`: Contains database connection settings

## Your Task

1. Create a ConfigMap named `app-config` in namespace `default` 
2. Load the configuration files from the current directory into the ConfigMap
3. Create a Deployment named `web-app` that mounts the ConfigMap at `/etc/config`
4. Verify the configuration files are accessible in the pod

## Docs

- [ConfigMap](https://kubernetes.io/docs/concepts/configuration/configmap/)
- [Volumes](https://kubernetes.io/docs/concepts/storage/volumes/)

# Question 3 – Create Persistent Volume and Claim

An application needs persistent storage that survives pod restarts. You need to create a PersistentVolume and PersistentVolumeClaim.

## Your Task

1. Create a PersistentVolume named `task-pv` with:
   - Storage: 2Gi
   - Access mode: ReadWriteOnce
   - Using emptyDir as backing storage (for testing)
2. Create a PersistentVolumeClaim named `task-pvc` that claims the PV
3. Create a Pod named `pv-consumer` that uses the PVC
4. Mount the PVC at `/data` in the pod
5. Verify the pod can write to and read from the mounted volume

## Docs

- [Persistent Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)
- [PersistentVolumeClaim](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#persistentvolumeclaims)

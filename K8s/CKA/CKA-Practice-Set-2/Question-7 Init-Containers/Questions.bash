# Question:
# Many applications require initialization before the main application starts.
# Init containers run before app containers and must complete successfully before
# the pod can proceed.

# Task:
# 1. Create a namespace called 'init-demo'
# 2. Create a Pod named 'app-with-init' that:
#    - Has an init container that downloads a config file (simulated)
#    - Has a main container that uses the downloaded config
#    - Mounts shared volume between init and main containers
# 3. Verify the init container runs first and completes successfully
# 4. Verify the main container starts only after init completes

# Video Link - TBD

#!/bin/bash
set -euo pipefail
echo "=== Q1 Setup: ConfigMap from Files ==="

# Create configuration files
cat > /tmp/app.conf <<'EOF'
server.port=8080
server.timeout=30
logging.level=INFO
EOF

cat > /tmp/database.conf <<'EOF'
db.host=localhost
db.port=5432
db.name=appdb
EOF

echo "Configuration files created"
echo "Ready for candidate to create ConfigMap and Deployment"

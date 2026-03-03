#!/bin/bash
# Check script for Q5 - Build Container Image with Podman
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/lib/common.sh"

score=0
total=2
print_header "Question 5 | Build Container Image and Save as Tarball"

# 1. Image my-app:1.0 exists
img_exists=false
podman images --format '{{.Repository}}:{{.Tag}}' 2>/dev/null | grep -q "my-app:1.0" && img_exists=true
if [ "$img_exists" = "false" ]; then
  docker images --format '{{.Repository}}:{{.Tag}}' 2>/dev/null | grep -q "my-app:1.0" && img_exists=true
fi
check_criterion "Image my-app:1.0 exists" "$img_exists" && ((score++))

# 2. Tarball exists
check_criterion "Tarball /root/my-app.tar exists" \
  "$([ -f /root/my-app.tar ] && echo true || echo false)" && ((score++))

print_score $score $total

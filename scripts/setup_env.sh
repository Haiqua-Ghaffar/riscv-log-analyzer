#!/bin/bash

set -euo pipefail
# an array of required tools
TOOLS=("bash" "grep" "awk" "sed" "sort")

echo "Checking required tools..."

for tool in "${TOOLS[@]}"; do  #Checks if all tools exists
    if command -v "$tool" >/dev/null 2>&1; then
        echo "[OK] $tool installed"
    else
        echo "[MISSING] $tool not installed"
    fi
done

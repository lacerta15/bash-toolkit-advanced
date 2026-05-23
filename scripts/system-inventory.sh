#!/bin/bash
# Collect full system inventory
source "$(dirname "$0")/../lib/logger.sh"

HOST=$(hostname -f)
log_info "Collecting inventory for $HOST"

echo "=== SYSTEM INVENTORY: $HOST ==="
echo "Date: $(date)"

echo ""
echo "--- Hardware ---"
lscpu | grep -E "Architecture|CPU\(s\)|Thread|Core|Socket|Model name"
echo "RAM: $(free -h | awk '/^Mem:/{print $2}')"
lsblk -d -o NAME,SIZE,TYPE,ROTA | head -20

echo ""
echo "--- OS ---"
cat /etc/os-release | grep -E "^NAME|^VERSION="
uname -r

echo ""
echo "--- Network ---"
ip -brief address | grep UP

echo ""
echo "--- Storage ---"
df -hT | grep -v tmpfs

echo ""
echo "--- Services ---"
systemctl list-units --state=running --type=service --no-legend | awk '{print $1}'

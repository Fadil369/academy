#!/usr/bin/env bash
set -euo pipefail

echo "Deploying local_brainsait to server Moodle local directory"

SERVER_HOST="ubuntu@95.177.160.74"
SERVER_KEY="~/.ssh/cloud.key"
REMOTE_MOODLE_LOCAL="/var/www/html/moodle/local"

SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/plugin/local/brainsait"

ssh -i "$SERVER_KEY" "$SERVER_HOST" "sudo mkdir -p $REMOTE_MOODLE_LOCAL && sudo chown -R ubuntu:www-data $REMOTE_MOODLE_LOCAL"

# Backup existing plugin on server if present
ssh -i "$SERVER_KEY" "$SERVER_HOST" "if [ -d $REMOTE_MOODLE_LOCAL/brainsait ]; then sudo mv $REMOTE_MOODLE_LOCAL/brainsait $REMOTE_MOODLE_LOCAL/brainsait_$(date +%Y%m%d%H%M%S)_bak; fi"

# Sync new plugin
rsync -avz -e "ssh -i $SERVER_KEY" "$SRC_DIR/" "$SERVER_HOST:$REMOTE_MOODLE_LOCAL/brainsait/"

# Set permissions
ssh -i "$SERVER_KEY" "$SERVER_HOST" "sudo chown -R www-data:www-data $REMOTE_MOODLE_LOCAL/brainsait && sudo find $REMOTE_MOODLE_LOCAL/brainsait -type f -name '*.sh' -exec chmod +x {} +"

echo "Plugin deployed. Visit Site administration to complete upgrade."

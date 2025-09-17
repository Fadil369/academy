#!/usr/bin/env bash
set -euo pipefail

echo "Deploying local_brainsait to server Moodle local directory"

SERVER_HOST="ubuntu@95.177.160.74"
SERVER_KEY="~/.ssh/cloud.key"

# Try common Moodle paths
MOODLE_PATHS=("/var/www/html/moodle" "/var/www/moodle" "/var/www/html" "/opt/moodle")

SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/plugin/local/brainsait"

echo "Finding Moodle installation..."
REMOTE_MOODLE_ROOT=""
for path in "${MOODLE_PATHS[@]}"; do
    if ssh -i "$SERVER_KEY" "$SERVER_HOST" "test -f $path/config.php"; then
        REMOTE_MOODLE_ROOT="$path"
        echo "Found Moodle at: $REMOTE_MOODLE_ROOT"
        break
    fi
done

if [ -z "$REMOTE_MOODLE_ROOT" ]; then
    echo "Could not find Moodle installation. Please check manually."
    exit 1
fi

REMOTE_MOODLE_LOCAL="$REMOTE_MOODLE_ROOT/local"

ssh -i "$SERVER_KEY" "$SERVER_HOST" "sudo mkdir -p $REMOTE_MOODLE_LOCAL && sudo chown -R ubuntu:www-data $REMOTE_MOODLE_LOCAL"

# Backup existing plugin on server if present
ssh -i "$SERVER_KEY" "$SERVER_HOST" "if [ -d $REMOTE_MOODLE_LOCAL/brainsait ]; then sudo mv $REMOTE_MOODLE_LOCAL/brainsait $REMOTE_MOODLE_LOCAL/brainsait_$(date +%Y%m%d%H%M%S)_bak; fi"

# Sync new plugin
rsync -avz -e "ssh -i $SERVER_KEY" "$SRC_DIR/" "$SERVER_HOST:$REMOTE_MOODLE_LOCAL/brainsait/"

# Set permissions
ssh -i "$SERVER_KEY" "$SERVER_HOST" "sudo chown -R www-data:www-data $REMOTE_MOODLE_LOCAL/brainsait && sudo find $REMOTE_MOODLE_LOCAL/brainsait -type f -name '*.sh' -exec chmod +x {} +"

echo "Plugin deployed. Visit Site administration to complete upgrade."

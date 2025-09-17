#!/usr/bin/env bash
set -euo pipefail

SERVER_HOST="ubuntu@95.177.160.74"
SERVER_KEY="~/.ssh/cloud.key"

SERVER_NAME="lms.brainsait.com"
PUBLIC_DIR="/var/www/brainsait-web"
URL_BASE="/brainsait-demo"

LOCAL_TEMPLATE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/ops/nginx/brainsait-presentation.conf.template"
REMOTE_CONF="/etc/nginx/sites-available/brainsait-presentation.conf"

TMP_FILE="/tmp/brainsait-presentation.conf"
sed -e "s#{{SERVER_NAME}}#${SERVER_NAME}#g" \
    -e "s#{{PUBLIC_DIR}}#${PUBLIC_DIR}#g" \
    -e "s#{{URL_BASE}}#${URL_BASE}#g" "$LOCAL_TEMPLATE" > "$TMP_FILE"

scp -i "$SERVER_KEY" "$TMP_FILE" "$SERVER_HOST:$REMOTE_CONF"

ssh -i "$SERVER_KEY" "$SERVER_HOST" "sudo mkdir -p ${PUBLIC_DIR} && sudo chown -R www-data:www-data ${PUBLIC_DIR} && sudo ln -sf $REMOTE_CONF /etc/nginx/sites-enabled/brainsait-presentation.conf && sudo nginx -t && sudo systemctl reload nginx"

echo "Deployed nginx config. Presentation base URL: https://${SERVER_NAME}${URL_BASE}/interactive-presentation.html"

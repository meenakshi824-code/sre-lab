#!/bin/bash

SERVICE="nginx"
URL="http://localhost"

echo "[$(date)] Starting health check"

if systemctl is-active --quiet "$SERVICE"; then
    echo "PASS: $SERVICE is running"
else
    echo "FAIL: $SERVICE is not running"
    exit 1
fi

HTTP_STATUS=$(curl -s -o /dev/null \
    -w "%{http_code}" \
    --connect-timeout 5 "$URL")
CURL_EXIT=$?

if [ "$CURL_EXIT" -eq 0 ] && [ "$HTTP_STATUS" = "200" ]; then
    echo "PASS: HTTP status is $HTTP_STATUS"
else
    echo "FAIL: HTTP check failed (status: ${HTTP_STATUS:-unavailable})"
    exit 1
fi

echo "Overall health check: PASS"
exit 0

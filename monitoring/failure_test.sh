#!/bin/bash

url="http://localhost/this-path-should-not-exist"

status=$(curl --fail -s -o /dev/null \
    --connect-timeout 3 \
    --max-time 5 \
    -w "%{http_code}" "$url")

result=$?

echo "HTTP status: $status"
echo "Curl exit code: $result"

if [ "$result" -eq 0 ] && [ "$status" = "200" ]; then
    echo "PASS: Application is healthy"
else
    echo "FAIL: Application health check failed"
    exit 1
fi

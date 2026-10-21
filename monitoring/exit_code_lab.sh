#!/bin/bash

curl -s -o /dev/null \
    --connect-timeout 3 \
    --max-time 5 \
    -w "%{http_code}" \
    http://127.0.0.1:8080/health

curl_result=$?

echo
echo "Curl exit code: $curl_result"

if [ "$curl_result" -eq 0 ]; then
    echo "Request completed"
else
    echo "Request failed"
fi

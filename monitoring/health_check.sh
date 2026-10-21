#!/bin/bash

LOG_FILE="${LOG_FILE:-$HOME/sre_lab/monitoring/logs/health.log}"
BACKEND_URL="${BACKEND_URL:-http://127.0.0.1:8080/health}"
PROXY_URL="${PROXY_URL:-http://localhost/myapp/health}"

check_url() {
    local name="$1"
    local url="$2"
    local status
    local result

    status=$(curl --fail -s -o /dev/null \
        --connect-timeout 3 \
        --max-time 5 \
        -w "%{http_code}" "$url")
    result=$?

    if [ "$result" -eq 0 ] && [ "$status" = "200" ]; then
        echo "PASS: $name - HTTP $status"
        echo "$(date '+%F %T') PASS $name HTTP $status" >> "$LOG_FILE"
    else
        echo "FAIL: $name - HTTP ${status:-000}"
        echo "$(date '+%F %T') FAIL $name HTTP ${status:-000}" >> "$LOG_FILE"
        return 1
    fi
}

mkdir -p "$(dirname "$LOG_FILE")"

check_url "Backend" "$BACKEND_URL"
backend_result=$?

check_url "Nginx proxy" "$PROXY_URL"
proxy_result=$?

if [ "$backend_result" -eq 0 ] && [ "$proxy_result" -eq 0 ]; then
    echo "Overall result: HEALTHY"
else
    echo "Overall result: UNHEALTHY"
    exit 1
fi

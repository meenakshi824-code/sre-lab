#!/bin/bash

SERVICE="${1:-nginx}"
LOG_FILE="service_check.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

check_service() {
    log "Checking service: $SERVICE"

    if systemctl is-active --quiet "$SERVICE"; then
        log "PASS: $SERVICE is running"
        return 0
    else
        log "FAIL: $SERVICE is not running"
        return 1
    fi
}

if check_service; then
    exit 0
else
    exit 1
fi

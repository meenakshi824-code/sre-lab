#!/bin/bash

SERVICE="nginx"
FAILED=0
TOTAL=3

for i in 1 2 3
do
    echo "Attempt $i of $TOTAL"

    if systemctl is-active --quiet "$SERVICE"; then
        echo "PASS: $SERVICE is running"
    else
        echo "FAIL: $SERVICE is not running"
        FAILED=1
    fi

    if [ "$i" -lt "$TOTAL" ]; then
        echo "Waiting 5 seconds..."
        sleep 5
    fi
done

if [ "$FAILED" -eq 0 ]; then
    echo "Overall result: PASS"
    exit 0
else
    echo "Overall result: FAIL"
    exit 1
fi

#!/bin/bash

is_healthy() {
    local curl_result="$1"
    local http_status="$2"

    [ "$curl_result" -eq 0 ] && [ "$http_status" = "200" ]
}

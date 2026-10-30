#!/bin/bash

is_healthy() {
    local curl_result="$1"
    local http_status="$2"

    [ "$curl_result" -eq 0 ] && [ "$http_status" = "200" ]
}
describe_curl_error() {
    local curl_result="$1"

    case "$curl_result" in
        0)  echo "request succeeded" ;;
        6)  echo "DNS resolution failed" ;;
        7)  echo "connection failed or was refused" ;;
        22) echo "HTTP error response (curl --fail)" ;;
        28) echo "request timed out" ;;
        *)  echo "curl failed with exit code $curl_result" ;;
    esac
}

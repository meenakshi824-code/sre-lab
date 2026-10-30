#!/usr/bin/env bats

setup() {
    source monitoring/health_logic.sh
}

@test "HTTP 200 with successful curl is healthy" {
    run is_healthy 0 200
    [ "$status" -eq 0 ]
}

@test "HTTP 404 is unhealthy" {
    run is_healthy 22 404
    [ "$status" -ne 0 ]
}

@test "Connection failure is unhealthy" {
    run is_healthy 7 000
    [ "$status" -ne 0 ]
}
@test "Curl code 6 identifies DNS resolution failure" {
    run describe_curl_error 6
    [ "$status" -eq 0 ]
    [ "$output" = "DNS resolution failed" ]
}

@test "Curl code 7 identifies connection failure" {
    run describe_curl_error 7
    [ "$status" -eq 0 ]
    [ "$output" = "connection failed or was refused" ]
}

@test "Curl code 22 identifies HTTP error response" {
    run describe_curl_error 22
    [ "$status" -eq 0 ]
    [ "$output" = "HTTP error response (curl --fail)" ]
}

@test "Curl code 28 identifies request timeout" {
    run describe_curl_error 28
    [ "$status" -eq 0 ]
    [ "$output" = "request timed out" ]
}

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

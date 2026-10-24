#!/usr/bin/env bats

setup() {
    export LOG_FILE="$BATS_TEST_TMPDIR/health.log"
    export BACKEND_URL="http://mock/backend"
    export PROXY_URL="http://mock/proxy"

    export MOCK_BACKEND_STATUS=200
    export MOCK_BACKEND_EXIT_CODE=0
    export MOCK_PROXY_STATUS=200
    export MOCK_PROXY_EXIT_CODE=0

    export PATH="$BATS_TEST_DIRNAME/mocks:$PATH"
}

@test "Both backend and proxy healthy" {
    run bash monitoring/health_check.sh

    [ "$status" -eq 0 ]
    [[ "$output" == *"Overall result: HEALTHY"* ]]
    grep -q "PASS Backend HTTP 200" "$LOG_FILE"
    grep -q "PASS Nginx proxy HTTP 200" "$LOG_FILE"
}

@test "Backend failure makes overall check unhealthy" {
    export MOCK_BACKEND_STATUS=404
    export MOCK_BACKEND_EXIT_CODE=22

    run bash monitoring/health_check.sh

    [ "$status" -eq 1 ]
    [[ "$output" == *"Overall result: UNHEALTHY"* ]]
    grep -q "FAIL Backend HTTP 404" "$LOG_FILE"
}

@test "Proxy failure makes overall check unhealthy" {
    export MOCK_PROXY_STATUS=404
    export MOCK_PROXY_EXIT_CODE=22

    run bash monitoring/health_check.sh

    [ "$status" -eq 1 ]
    [[ "$output" == *"Overall result: UNHEALTHY"* ]]
    grep -q "FAIL Nginx proxy HTTP 404" "$LOG_FILE"
}
@test "Backend connection failure makes overall check unhealthy" {
    export MOCK_BACKEND_STATUS=000
    export MOCK_BACKEND_EXIT_CODE=7

    run bash monitoring/health_check.sh

    [ "$status" -eq 1 ]
    [[ "$output" == *"Overall result: UNHEALTHY"* ]]
    grep -q "FAIL Backend HTTP 000" "$LOG_FILE"
    grep -q "FAIL Backend HTTP 000 curl_exit=7" "$LOG_FILE"
}
@test "Proxy connection failure makes overall check unhealthy" {
    export MOCK_PROXY_STATUS=000
    export MOCK_PROXY_EXIT_CODE=7

    run bash monitoring/health_check.sh

    [ "$status" -eq 1 ]
    [[ "$output" == *"Overall result: UNHEALTHY"* ]]
    grep -q "FAIL Nginx proxy HTTP 000" "$LOG_FILE"
}

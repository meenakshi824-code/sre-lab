#!/usr/bin/env bats

@test "Bash arithmetic works correctly" {
    result=$((2 + 3))
    [ "$result" -eq 5 ]
}

@test "Project health-check script exists" {
    [ -f "monitoring/health_check.sh" ]
}

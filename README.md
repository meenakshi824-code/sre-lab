# Bash-Based Application Health Monitoring & Troubleshooting

## 1. Project Overview

This project implements a lightweight Bash-based application health monitoring system designed to simulate real-world DevOps and SRE monitoring practices.

It checks the health of a backend application and its Nginx reverse proxy, identifies common request failures, and records timestamped monitoring results.

The project also includes automated testing with Bats, static code analysis with ShellCheck, and continuous integration using GitHub Actions.

## 2. Architecture

The monitoring workflow follows this request path:

```text
             Health Check Script
                     |
             +-------+-------+
             |               |
       Backend Check     Proxy Check
             |               |
       Backend :8080     Nginx :80
                             |
                       Reverse Proxy
                             |
                       Backend :8080
             |               |
             +-------+-------+
                     |
              Result Analysis
                     |
             Failure Classification
                     |
              Timestamped Logs
                     |
               Bats Testing
                     |
              GitHub Actions CI
```

## 3. Technologies Used

- Linux (Ubuntu / WSL2)
- Bash scripting
- Nginx
- curl
- Git and GitHub
- Bats (Bash Automated Testing System)
- ShellCheck
- GitHub Actions

## 4. Project Structure

```text
sre_lab/
├── .github/
│   └── workflows/
│       └── health-check.yml
├── bash/
│   ├── app_check.sh
│   ├── hello.sh
│   ├── repeat_check.sh
│   ├── service_check.sh
│   └── service_check_args.sh
├── monitoring/
│   ├── exit_code_lab.sh
│   ├── failure_test.sh
│   ├── health_check.sh
│   ├── health_logic.sh
│   └── logs/
│       └── health.log
├── tests/
│   ├── basic.bats
│   ├── health_check.bats
│   ├── health_logic.bats
│   └── mocks/
│       └── curl
└── README.md
```

## 5. Monitoring Features

### Backend and Nginx Health Checks

The monitoring script checks:

- Backend application health endpoint.
- Nginx reverse proxy health endpoint.
- HTTP response status.
- curl execution result.

### Timeout Handling

The monitoring script uses:

- Connection timeout: 3 seconds
- Maximum request duration: 5 seconds

### Failure Classification

The script translates common curl exit codes into readable diagnostic messages.

| curl exit code | Diagnostic message |
|---|---|
| 6 | DNS resolution failed |
| 7 | Connection failed or was refused |
| 22 | HTTP error response |
| 28 | Request timed out |

These messages provide troubleshooting clues and are not definitive root-cause diagnoses.

### Logging

Monitoring results are stored with timestamps.

Example:

```text
2026-10-30 09:44:09 FAIL Backend HTTP 000 curl_exit=7 reason="connection failed or was refused"
```

## 6. Running the Monitoring Script

Run from the repository root:

```bash
bash monitoring/health_check.sh
```

Default endpoints:

```text
Backend: http://127.0.0.1:8080/health
Nginx:   http://localhost/myapp/health
```

The endpoints can be overridden using environment variables:

```bash
BACKEND_URL="http://127.0.0.1:8080/health" \
PROXY_URL="http://localhost/myapp/health" \
bash monitoring/health_check.sh
```

The log file defaults to:

```text
~/sre_lab/monitoring/logs/health.log
```

It can also be overridden using `LOG_FILE`.

## 7. Automated Testing

The project uses Bats to validate monitoring logic and failure scenarios.

Run all tests:

```bash
bats tests/
```

The test suite covers:

- Successful HTTP 200 responses.
- HTTP failure responses.
- Backend connection failures.
- Nginx proxy failures.
- curl error classification.
- Basic Bash functionality.

Latest validated result: **14 tests passed, 0 failures.**

## 8. Static Code Analysis

ShellCheck is used to identify common Bash scripting issues.

Run:

```bash
shellcheck -x bash/*.sh monitoring/*.sh
```

## 9. Continuous Integration

GitHub Actions automatically validates the repository on pushes and pull requests targeting the main branch.

The workflow performs:

1. Repository checkout.
2. Bats installation.
3. Bash syntax validation.
4. ShellCheck analysis.
5. Automated Bats test execution.

The latest project changes successfully passed the GitHub Actions pipeline.

## 10. Skills Demonstrated

Through this project, I practised:

- Bash automation and scripting.
- Application health monitoring.
- HTTP and reverse proxy troubleshooting.
- curl exit-code analysis.
- Linux log management.
- Automated testing using Bats.
- Static analysis using ShellCheck.
- Git version control.
- CI automation using GitHub Actions.

## 11. Future Improvements

Potential enhancements include:

- Scheduled health checks using cron.
- Alert notifications for repeated failures.
- Monitoring additional application endpoints.
- Prometheus and Grafana integration.
- Docker-based deployment.
- AWS deployment and CloudWatch integration.

---

**Project Type:** DevOps / SRE Hands-on Project

**Repository:** sre_lab

**Status:** Bash monitoring and CI validation implemented.

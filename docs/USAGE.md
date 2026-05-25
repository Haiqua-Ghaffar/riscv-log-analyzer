# RISC-V Log Analyzer Usage Guide

## Overview

The RISC-V Log Analyzer is a Bash-based CLI tool for analyzing RISC-V simulation logs.
It extracts test results, computes statistics, detects regressions, and generates reports.

The analyzer supports:

* PASS / FAIL / SKIP analysis
* Pass percentage calculation
* Timing statistics (min, max, average)
* Failed test extraction
* Regression detection between runs
* CSV and text output formats
* Verbose debugging mode
* File output reporting

---

# Getting Started

## Verify Environment

Before using the tool, ensure all dependencies are installed:

```bash
make setup
```

Expected output:

```text
Checking required tools...
[OK] bash installed
[OK] grep installed
[OK] awk installed
[OK] sed installed
[OK] sort installed
```

---

# Log File Format

The analyzer expects logs in this format:

```text
[2026-05-01 10:23:45] TEST START: rv32i-add
[2026-05-01 10:23:46] TEST PASS: rv32i-add (0.82s)

[2026-05-01 10:23:47] TEST FAIL: rv32i-sll (1.02s)

[2026-05-01 10:23:48] TEST SKIP: rv32i-srl (not supported)
```

### Recognized Patterns:

* TEST PASS:
* TEST FAIL:
* TEST SKIP:

---

# Analyzer Script

## Basic Usage

```bash
./scripts/analyze.sh <log_file>
```

Example:

```bash
./scripts/analyze.sh test_data/run_v1.log
```

---

## Help Menu

```bash
./scripts/analyze.sh -h
```

---

## Options

  -f <text|csv>    Output format
  -o <file>        Save report to file
  -c <file>        Compare against another log file
  -v               Enable verbose mode
  -h               Show help

Examples:
  ./scripts/analyze.sh sample.log
  ./scripts/analyze.sh -f csv sample.log
  ./scripts/analyze.sh -o report.txt sample.log
  ./scripts/analyze.sh -v sample.log
  ./scripts/analyze.sh -c test_data/run_v1.log test_data/run_v2.log


## Example Output

```text
=== RISC-V Simulation Log Analysis ===

Log file: test_data/run_v1.log

--- Results Summary ---
Total tests: 5
Passed: 5
Failed: 0
Skipped: 0
Pass Rate: 100.00%
```

---

# CSV Output Mode

```bash
./scripts/analyze.sh -f csv sample.log
```

Example:

```csv
total,passed,failed,skipped,pass_rate
5,5,0,0,100.00
```

---

# Verbose Mode

```bash
./scripts/analyze.sh -v sample.log
```

Example:

```text
[VERBOSE] Log file: test_data/run_v1.log
[VERBOSE] Format: text
```

---

# Timing Statistics

Extracted from PASS/FAIL entries:

* Minimum execution time
* Maximum execution time
* Average execution time

Example:

```text
--- Timing Statistics ---
Min time: 0.65s
Max time: 1.02s
Avg time: 0.83s
```

---

# Regression Analysis 

Compare two log files to detect regressions.

## Usage:

```bash
./scripts/analyze.sh test_data/run_v1.log -c test_data/run_v2.log
```

## Meaning:

| File       | Role                             |
| ---------- | -------------------------------- |
| run_v1.log | Baseline (previous stable build) |
| run_v2.log | New build (possible regression)  |

---

## Output Example:

```text
=== Regression Analysis ===
REGRESSION: rv32i-sub
REGRESSION: rv32i-sll
```

---

# Report Generation

Generate full report:

```bash
make report
```

or:

```bash
./scripts/generate_report.sh
```

Output:

```text
output/report.txt
```

---

# Running Tests

```bash
make test
```

Runs sample logs through analyzer.

---

# Cleaning Output

```bash
make clean
```

Removes generated files.

---

# Makefile Commands

## Show Help

```bash
make help
```

## Setup Environment

```bash
make setup
```

## Run Tests

```bash
make test
```

## Generate Report

```bash
make report
```

## Clean Output

```bash
make clean
```

---

# Exit Codes

| Code | Meaning                       |
| ---- | ----------------------------- |
| 0    | Success (all tests passed)    |
| 1    | Failure detected              |
| 1    | Invalid input or missing file |

Example:

```bash
./scripts/analyze.sh test_data/run_v1.log
echo $?
```

---

# Common Errors

## File Not Found

```text
Error: File does not exist
```

Fix:

```bash
ls test_data/
```

---

## Permission Denied

```bash
chmod +x scripts/*.sh
```

---

## Makefile Issue

```text
missing separator
```

Cause: spaces instead of TAB in Makefile.

Fix: replace spaces with TAB.

---

# Project Workflow

```bash
make setup
make test
make report
```

---

# Technologies Used

* Bash
* GNU Make
* grep
* awk
* sed
* sort
* Linux CLI tools

---

# Author

Haiqua Ghaffar
MEDS Training Program – Module 1 Grand Assignment

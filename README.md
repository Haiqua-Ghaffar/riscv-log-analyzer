# RISC-V Log Analyzer

A shell-based utility for analyzing RISC-V simulation log files and generating summary reports.

This project was developed as part of the MEDS Module 1 Grand Assignment and demonstrates practical usage of:

- Linux command-line tools
- Bash scripting
- Git workflows
- Makefile automation
- Text processing using grep, awk, sort

---

## Features

### Log Analysis

The analyzer extracts:

- Total number of tests executed
- Number of PASS results
- Number of FAIL results
- Number of SKIP results
- Pass percentage
- List of failing tests
- Execution timing statistics
  - Minimum execution time
  - Maximum execution time
  - Average execution time

### Reporting

- Human-readable text reports
- CSV output format
- Automated report generation
- Optional file output using --output

### Automation

- Environment verification
- Automated testing via Makefile
- Report generation through Makefile targets
- Clean build support

---

## Repository Structure

```text
riscv-log-analyzer/
├── README.md
├── Makefile
├── .gitignore
├── scripts/
│   ├── analyze.sh
│   ├── setup_env.sh
│   └── generate_report.sh
├── test_data/
│   ├── sample_sim.log
│   ├── sample_pass.log
│   └── sample_fail.log
├── output/
└── docs/
    └── USAGE.md
```

---

## Requirements

The following tools are required:

- Bash
- grep
- awk
- sed
- sort
- make

Verify your environment using:

```bash
make setup
```

---

## Installation

Clone the repository:

```bash
git clone <repository-url>
cd riscv-log-analyzer
```

Make scripts executable if needed:

```bash
chmod +x scripts/*.sh
```

---

## Usage

Run analyzer:

```bash
./scripts/analyze.sh test_data/sample_sim.log
```

Save output:

```bash
./scripts/analyze.sh test_data/sample_sim.log --output output/report.txt
```
CSV format:

```bash
./scripts/analyze.sh test_data/sample_sim.log --format csv
```

Verbose mode:
```bash
./scripts/analyze.sh test_data/sample_sim.log --verbose
```

Help:
```bash
./scripts/analyze.sh --help
```

---

## Makefile Targets

| Target | Description |
|----------|-------------|
| make help | Show available commands |
| make setup | Verify required tools |
| make test | Run analyzer tests |
| make report | Generate analysis report |
| make clean | Remove generated output files |
| make all | Default target |

Example:

```bash
make report
```

---

## Sample Output

```text
=== RISC-V Simulation Log Analysis ===

Log file: test_data/sample_fail.log

--- Results Summary ---
Total tests: 4
Passed: 2
Failed: 1
Skipped: 1
Pass Rate: 50.00%

--- Failed Tests ---
rv32i-sll

--- Timing Statistics ---
Min time: 0.65s
Max time: 1.02s
Avg time: 0.83s

--- Verdict: FAIL ---
```

---

## Documentation

Detailed command reference and usage examples are available in:

```text
docs/USAGE.md
```

---

## Git Workflow Demonstrated

This project demonstrates:

- Feature branch development
- Branch merging
- Merge conflict resolution
- Meaningful commit history
- GitHub integration

---

## Technologies Used

- Bash
- Git
- GNU Make
- grep
- awk
- sed
- sort

---

## Author

Haiqua Ghaffar

MEDS Training Program – Module 1

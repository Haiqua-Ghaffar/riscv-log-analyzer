#!/bin/bash

# Exit on error and don't continue (-e), undefined variable (-u),
# and pipeline failure (-o pipefail)
set -euo pipefail

# -----------------------------
# Function: Print usage
# -----------------------------
# Display script usage information
show_help() {
    echo "Usage: $0 <log_file> [options]"
    echo
    echo "Options:"
    echo "  --format <text|csv>   Output format"
    echo "  --output <file>       Save output to file"
    echo "  --verbose             Enable verbose mode"
    echo "  --help                Show this help message"
}

# -----------------------------
# Function: Validate log file
# -----------------------------
# Check whether the provided log file exists
validate_file() {
    local file="$1"

    if [ ! -f "$file" ]; then
        echo "Error: File does not exist"
        exit 1
    fi
}

# -----------------------------
# Default Values
# -----------------------------
# Default configuration values
FORMAT="text"
VERBOSE=false
OUTPUT_FILE=""
LOG_FILE=""

# -----------------------------
# Parse Arguments
# -----------------------------
# Parse command-line arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --help)
            show_help
            exit 0
            ;;

        --format)
            FORMAT="${2:-text}"
            shift 2
            ;;

        --output)
            OUTPUT_FILE="${2:-}"
            shift 2
            ;;

        --verbose)
            VERBOSE=true
            shift
            ;;

        *)
            # First non-option argument is treated as log file
            if [ -z "$LOG_FILE" ]; then
                LOG_FILE="$1"
            else
                echo "Error: Unknown argument '$1'"
                exit 1
            fi
            shift
            ;;
    esac
done

# -----------------------------
# Validate Input
# -----------------------------
# Ensure user supplied a valid log file
if [ -z "$LOG_FILE" ]; then
    show_help
    exit 1
fi

validate_file "$LOG_FILE"

# -----------------------------
# Verbose Logging
# -----------------------------
# Optional verbose diagnostics
if [ "$VERBOSE" = true ]; then
    echo "[VERBOSE] Analyzing file: $LOG_FILE"
    echo "[VERBOSE] Output format: $FORMAT"
fi

# -----------------------------
# Analyze Log
# -----------------------------
# Count PASS, FAIL, and SKIP occurrences
PASS_COUNT=$(grep -c "TEST PASS" "$LOG_FILE" || true)
FAIL_COUNT=$(grep -c "TEST FAIL" "$LOG_FILE" || true)
SKIP_COUNT=$(grep -c "TEST SKIP" "$LOG_FILE" || true)

# Total number of executed tests
TOTAL=$((PASS_COUNT + FAIL_COUNT + SKIP_COUNT))

# Extract execution times from PASS and FAIL entries
TIMES=$(grep -E "TEST PASS|TEST FAIL" "$LOG_FILE" \
    | grep -oE '[0-9]+\.[0-9]+s' \
    | tr -d 's')

# Calculate average execution time using awk
AVG_TIME=$(echo "$TIMES" | awk '
{
    sum += $1
    count++
}
END {
    if (count > 0)
        printf "%.2f", sum/count
    else
        print "0.00"
}')

# Determine minimum and maximum execution times
MIN_TIME=$(echo "$TIMES" | sort -n | head -1)
MAX_TIME=$(echo "$TIMES" | sort -n | tail -1)

# Compute pass percentage while avoiding division by zero
if [ "$TOTAL" -gt 0 ]; then
    PASS_RATE=$(awk "BEGIN { printf \"%.2f\", ($PASS_COUNT/$TOTAL)*100 }")
else
    PASS_RATE="0.00"
fi

# -----------------------------
# Generate Output
# -----------------------------
# Build report content and store it in a variable
REPORT=$(
if [ "$FORMAT" = "csv" ]; then
    # CSV format for spreadsheet/reporting tools
    echo "total,passed,failed,skipped,pass_rate"
    echo "$TOTAL,$PASS_COUNT,$FAIL_COUNT,$SKIP_COUNT,$PASS_RATE"
else
    # Human-readable report format
    echo "=== RISC-V Simulation Log Analysis ==="
    echo "Log file: $LOG_FILE"
    echo
    echo "--- Results Summary ---"
    echo "Total tests: $TOTAL"
    echo "Passed: $PASS_COUNT"
    echo "Failed: $FAIL_COUNT"
    echo "Skipped: $SKIP_COUNT"
    echo "Pass Rate: ${PASS_RATE}%"

    echo
    echo "--- Failed Tests ---"

    # Extract names of failed tests
    grep "TEST FAIL" "$LOG_FILE" | awk '{print $5}' || true

    echo
    echo "--- Timing Statistics ---"

    # Display timing statistics
    echo "Min time: ${MIN_TIME}s"
    echo "Max time: ${MAX_TIME}s"
    echo "Avg time: ${AVG_TIME}s"
fi
)

# -----------------------------
# Output Handling
# -----------------------------
# Either save report to a file or print to terminal
if [ -n "$OUTPUT_FILE" ]; then
    echo "$REPORT" > "$OUTPUT_FILE"

    if [ "$VERBOSE" = true ]; then
        echo "[VERBOSE] Report written to $OUTPUT_FILE"
    fi
else
    echo "$REPORT"
fi

# -----------------------------
# Final Verdict
# -----------------------------
# Return appropriate exit code based on test results
if [ "$FAIL_COUNT" -gt 0 ]; then
    echo "--- FINAL VERDICT: FAIL ---"
    exit 1
else
    echo "--- FINAL VERDICT: PASS ---"
    exit 0
fi

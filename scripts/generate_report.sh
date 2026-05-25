#!/bin/bash

set -euo pipefail   # Exit on error, undefined variables, and pipe failures

mkdir -p output     # Create output directory if it doesn't exist

REPORT_FILE="output/report.txt"   # File where final report will be stored

echo "Generating report..."        # Status message for user

{
    echo "=== RISC-V Log Analysis Report ==="   # Report header
    echo "Generated on: $(date)"               # Add current timestamp
    echo                                        # Blank line for readability

    # Loop through all .log files in test_data directory
    for file in test_data/*.log; do
        echo "Analyzing $file"                 # Show which file is being processed
        
        # Run analyzer script on each log file
        # || true ensures script continues even if analyzer returns error
        ./scripts/analyze.sh "$file" || true   
        
        echo                                   # Blank line between reports
    done

} > "$REPORT_FILE"   # Redirect ALL output of block into report file

echo "Report saved to $REPORT_FILE"   # Final confirmation message

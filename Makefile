.PHONY: all test report clean help setup

SCRIPT=./scripts/analyze.sh


all: report

test:
	@echo "Running analyzer tests..."
	@$(SCRIPT) test_data/sample_pass.log
	@$(SCRIPT) test_data/sample_fail.log || true
	@echo "Tests completed."

report:
	@bash scripts/generate_report.sh
	@echo "report"

clean:
	@rm -rf output/*
	@echo "Output directory cleaned."

setup:
	@bash scripts/setup_env.sh

help:
	@echo "Available targets:"
	@echo "  make all      - Generate reports"
	@echo "  make test     - Run analyzer tests"
	@echo "  make report   - Generate report file"
	@echo "  make clean    - Remove generated files"
	@echo "  make setup    - Verify required tools"
	@echo "  make help     - Show this help menu"

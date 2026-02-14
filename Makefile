SHELL := /bin/bash
.DEFAULT_GOAL := help

.PHONY: help specs generate-sdk generate-sdk-all

help:
	@echo "Targets:"
	@echo "  make specs"
	@echo "      List available OpenAPI specs from specs/catalog.json"
	@echo ""
	@echo "  make generate-sdk SPEC=<spec-id> GENERATOR=<name> [OUT=<output-path>] [PACKAGE_NAME=<name>] [ADDITIONAL_PROPERTIES=<k=v,...>]"
	@echo "      Generate a client library for one spec"
	@echo ""
	@echo "  make generate-sdk-all GENERATOR=<name>"
	@echo "      Generate the same client library for all specs"

specs:
	@./scripts/list-specs.sh

generate-sdk:
	@if [[ -z "$(SPEC)" || -z "$(GENERATOR)" ]]; then \
		echo "Usage: make generate-sdk SPEC=<spec-id> GENERATOR=<name> [OUT=<output-path>] [PACKAGE_NAME=<name>] [ADDITIONAL_PROPERTIES=<k=v,...>]"; \
		exit 1; \
	fi
	@cmd=(./scripts/generate-sdk.sh --spec "$(SPEC)" --generator "$(GENERATOR)"); \
	if [[ -n "$(OUT)" ]]; then cmd+=(--output "$(OUT)"); fi; \
	if [[ -n "$(PACKAGE_NAME)" ]]; then cmd+=(--package-name "$(PACKAGE_NAME)"); fi; \
	if [[ -n "$(ADDITIONAL_PROPERTIES)" ]]; then cmd+=(--additional-properties "$(ADDITIONAL_PROPERTIES)"); fi; \
	"$${cmd[@]}"

generate-sdk-all:
	@if [[ -z "$(GENERATOR)" ]]; then \
		echo "Usage: make generate-sdk-all GENERATOR=<name>"; \
		exit 1; \
	fi
	@while IFS= read -r spec_id; do \
		./scripts/generate-sdk.sh --spec "$$spec_id" --generator "$(GENERATOR)" --output "generated/$$spec_id/$(GENERATOR)"; \
	done < <(./scripts/list-specs.sh --ids)

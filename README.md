# KORE OpenAPI

OpenAPI specifications for KORE public APIs, with a standardized repository layout and tooling to:

- discover available specs
- generate SDK/client libraries from any spec
- check documented Kore endpoints against repository specs

## Repository Layout

```text
.
├── specs/
│   ├── catalog.json
│   ├── api-clients/
│   ├── iam/
│   ├── programmable-wireless/
│   ├── supersim/
│   └── webhook/
├── scripts/
│   ├── check-doc-alignment.sh
│   ├── generate-sdk.sh
│   └── list-specs.sh
├── docs/
│   ├── generating-sdks.md
│   ├── endpoint-alignment.md
│   └── korewireless-documented-endpoints-2026-02-14.json
├── Makefile
└── LICENSE
```

## Quick Start

```bash
# list all available spec IDs and source files
make specs

# generate one SDK
make generate-sdk SPEC=supersim-v1 GENERATOR=typescript-fetch

# generate one SDK with a custom output folder
make generate-sdk SPEC=webhook-v1 GENERATOR=python OUT=generated/webhook/python

# compare local specs with documented Kore endpoints snapshot
make check-doc-alignment
```

## SDK Generation

The generator script uses Docker (`openapitools/openapi-generator-cli`) when available.
If Docker is not available, it falls back to local `openapi-generator-cli` or `npx @openapitools/openapi-generator-cli`.

Detailed usage and examples: `docs/generating-sdks.md`.

## Docs Alignment Audit

An alignment check against `docs.korewireless.com` pages was captured on **February 14, 2026**.

- Snapshot: `docs/korewireless-documented-endpoints-2026-02-14.json`
- Audit report: `docs/endpoint-alignment.md`
- Reproducible check: `scripts/check-doc-alignment.sh`

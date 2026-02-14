# KORE OpenAPI

OpenAPI specifications for KORE public APIs, with a standardized repository layout and tooling to:

- discover available specs
- generate SDK/client libraries from any spec

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
│   ├── generate-sdk.sh
│   └── list-specs.sh
├── docs/
│   └── generating-sdks.md
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
```

## SDK Generation

The generator script uses Docker (`openapitools/openapi-generator-cli`) when available.
If Docker is not available, it falls back to local `openapi-generator-cli` or `npx @openapitools/openapi-generator-cli`.

Detailed usage and examples: `docs/generating-sdks.md`.

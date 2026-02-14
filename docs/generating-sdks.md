# Generating SDKs

This repository includes a manifest-driven SDK generation workflow based on OpenAPI Generator.

## 1. Discover Available Specs

```bash
./scripts/list-specs.sh
```

To list IDs only:

```bash
./scripts/list-specs.sh --ids
```

## 2. Generate a Library

```bash
./scripts/generate-sdk.sh --spec <spec-id> --generator <generator-name>
```

Example:

```bash
./scripts/generate-sdk.sh --spec supersim-v1 --generator typescript-fetch
```

Output defaults to:

```text
generated/<spec-id>/<generator-name>
```

## 3. Common Options

```bash
./scripts/generate-sdk.sh \
  --spec webhook-v1 \
  --generator python \
  --output generated/webhook/python \
  --package-name kore_webhook \
  --additional-properties packageVersion=1.0.0,projectName=KoreWebhook
```

Pass through raw generator flags after `--`:

```bash
./scripts/generate-sdk.sh \
  --spec api-clients-client-v1 \
  --generator go \
  -- \
  --git-user-id korewireless \
  --git-repo-id kore-api-clients-go
```

## 4. Runtime Selection

`scripts/generate-sdk.sh` resolves runtime in this order:

1. Docker (`openapitools/openapi-generator-cli:v7.12.0` by default)
2. Local `openapi-generator-cli`
3. `npx @openapitools/openapi-generator-cli`

Override Docker image:

```bash
OPENAPI_GENERATOR_IMAGE=openapitools/openapi-generator-cli:v7.13.0 \
./scripts/generate-sdk.sh --spec iam-v1 --generator java
```

## 5. Makefile Shortcuts

```bash
make specs
make generate-sdk SPEC=iam-v1 GENERATOR=java PACKAGE_NAME=kore-iam-client
make generate-sdk-all GENERATOR=typescript-fetch
```

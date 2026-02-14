# Endpoint Alignment Report

This report compares API operations documented on `docs.korewireless.com` with operations defined in this repository's OpenAPI specs.

- Audit date: **February 14, 2026**
- Snapshot file: `docs/korewireless-documented-endpoints-2026-02-14.json`
- Comparison script: `scripts/check-doc-alignment.sh`

## Summary

- Documented in Kore docs but missing in local specs: **5**
- Present in local specs but not documented in the snapshot: **10**

## Documented but Missing in Local Specs

| Spec ID | Method | Path |
| --- | --- | --- |
| programmable-wireless-v1 | POST | /v1/Sims |
| supersim-v1 | POST | /v1/SettingsUpdates |
| webhook-v1 | GET | /v1/secrets/{id} |
| webhook-v1 | PUT | /v1/secrets/{id} |
| webhook-v1 | DELETE | /v1/secrets/{id} |

## Present in Local Specs but Not in Docs Snapshot

| Spec ID | Method | Path |
| --- | --- | --- |
| api-clients-token-v1 | OPTIONS | /v1/auth/token |
| iam-v1 | GET | /v1/platform_account_mappings |
| iam-v1 | POST | /v1/accounts |
| programmable-wireless-v1 | GET | /v1/Sims/{Sid}/UsageRecords |
| programmable-wireless-v1 | DELETE | /v1/RatePlans/{Sid} |
| programmable-wireless-v1 | DELETE | /v1/Sims/{Sid} |
| programmable-wireless-v1 | DELETE | /v1/Commands/{Sid} |
| programmable-wireless-v1 | POST | /v1/Sims/{Sid} |
| supersim-v1 | GET | /v1/NetworkAccessProfiles/{NetworkAccessProfileSid}/Networks/{Sid} |
| webhook-v1 | PATCH | /v1/secrets/{id} |

## Kore Documentation Sources Used

- [API Clients](https://docs.korewireless.com/en-us/api/products/api-clients)
- [v1-token](https://docs.korewireless.com/en-us/api/products/api-clients/v1-token)
- [IAM Account](https://docs.korewireless.com/en-us/api/products/iam/account)
- [Programmable Wireless](https://docs.korewireless.com/en-us/api/products/programmable-wireless)
- [SuperSIM](https://docs.korewireless.com/en-us/api/products/supersim)
- [Webhook Secret](https://docs.korewireless.com/en-us/api/products/webhook/secret)

## Re-run the Check

```bash
make check-doc-alignment
```

#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CATALOG_PATH="${ROOT_DIR}/specs/catalog.json"
SNAPSHOT_PATH="${1:-${ROOT_DIR}/docs/korewireless-documented-endpoints-2026-02-14.json}"

if [[ ! -f "${CATALOG_PATH}" ]]; then
  echo "Catalog not found: ${CATALOG_PATH}" >&2
  exit 1
fi

if [[ ! -f "${SNAPSHOT_PATH}" ]]; then
  echo "Docs snapshot not found: ${SNAPSHOT_PATH}" >&2
  exit 1
fi

spec_ops_file="$(mktemp)"
docs_ops_file="$(mktemp)"
missing_in_specs_file="$(mktemp)"
undocumented_in_docs_file="$(mktemp)"

cleanup() {
  rm -f "${spec_ops_file}" "${docs_ops_file}" "${missing_in_specs_file}" "${undocumented_in_docs_file}"
}
trap cleanup EXIT

jq -r '.[] | [.id, .yaml] | @tsv' "${CATALOG_PATH}" \
  | while IFS=$'\t' read -r spec_id yaml_path; do
      awk -v sid="${spec_id}" '
        /^paths:/ { inside_paths=1; next }
        inside_paths && /^  \/.+:$/ {
          path=$1
          sub(/:$/, "", path)
          next
        }
        inside_paths && /^    (get|post|put|delete|patch|options|head):$/ {
          method=toupper($1)
          sub(/:$/, "", method)
          print sid "\t" method "\t" path
        }
        inside_paths && /^[^ ]/ { inside_paths=0 }
      ' "${ROOT_DIR}/${yaml_path}"
    done \
  | sort -u > "${spec_ops_file}"

jq -r '.operations[] | [.spec_id, (.method | ascii_upcase), .path] | @tsv' "${SNAPSHOT_PATH}" \
  | sort -u > "${docs_ops_file}"

comm -23 "${docs_ops_file}" "${spec_ops_file}" > "${missing_in_specs_file}"
comm -13 "${docs_ops_file}" "${spec_ops_file}" > "${undocumented_in_docs_file}"

docs_count="$(wc -l < "${docs_ops_file}" | tr -d ' ')"
spec_count="$(wc -l < "${spec_ops_file}" | tr -d ' ')"
missing_count="$(wc -l < "${missing_in_specs_file}" | tr -d ' ')"
undocumented_count="$(wc -l < "${undocumented_in_docs_file}" | tr -d ' ')"

snapshot_date="$(jq -r '.snapshot_date' "${SNAPSHOT_PATH}")"

echo "Snapshot date: ${snapshot_date}"
echo "Documented operations in snapshot: ${docs_count}"
echo "Operations in local specs: ${spec_count}"
echo

if [[ "${missing_count}" -gt 0 ]]; then
  echo "Documented in Kore docs but missing in local specs (${missing_count}):"
  cat "${missing_in_specs_file}"
  echo
else
  echo "No operations are missing in local specs relative to the docs snapshot."
  echo
fi

if [[ "${undocumented_count}" -gt 0 ]]; then
  echo "Present in local specs but not found in docs snapshot (${undocumented_count}):"
  cat "${undocumented_in_docs_file}"
  echo
else
  echo "No extra local operations beyond the docs snapshot."
  echo
fi

if [[ "${STRICT:-0}" == "1" && ("${missing_count}" -gt 0 || "${undocumented_count}" -gt 0) ]]; then
  exit 1
fi

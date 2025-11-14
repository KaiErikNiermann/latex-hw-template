#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

INPUT_TEX="${ROOT_DIR}/main.tex"
OUTPUT_HTML="${SCRIPT_DIR}/main.html"
HEADER_FILE="${SCRIPT_DIR}/header.html"
STYLE_FILE="${SCRIPT_DIR}/style.css"
DOC_TITLE="${1:-$(basename "${INPUT_TEX}" .tex)}"

if ! command -v pandoc >/dev/null 2>&1; then
  echo "Error: pandoc is not installed or not in PATH." >&2
  exit 1
fi

if [[ ! -f "${INPUT_TEX}" ]]; then
  echo "Error: Could not find LaTeX source at ${INPUT_TEX}." >&2
  exit 1
fi

echo "Generating HTML version at ${OUTPUT_HTML}..."

pandoc "${INPUT_TEX}" \
  --standalone \
  --mathjax \
  --metadata "title=${DOC_TITLE}" \
  --include-in-header="${HEADER_FILE}" \
  --css="${STYLE_FILE}" \
  --resource-path="${ROOT_DIR}:${ROOT_DIR}/assets:${ROOT_DIR}/figures" \
  --output "${OUTPUT_HTML}"

echo "HTML build complete."

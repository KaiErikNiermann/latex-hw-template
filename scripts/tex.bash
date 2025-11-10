#!/bin/bash
set -euo pipefail

script_dir="$(dirname "$0")"

# shellcheck source=/dev/null
source "$script_dir/utilities.sh"

ASSUME_YES=""
STY_FILE=""
AUTO_FIRST="false"
SKIP_CORE="false"
USE_TUI="true"

usage() {
  cat <<'USAGE'
Install core TeX Live and optionally locate & install the package providing a .sty file.

USAGE:  
  setup-texlive.sh [options]

OPTIONS:
  -s, --sty FILE.sty   Look up which Debian/Ubuntu TeX Live package provides FILE.sty
  -f, --first          Skip TUI; auto-select the first matching package from apt-file results
      --skip-core      Skip the big TeX Live base install; only do apt-file lookup/install
  -y, --assume-yes     Pass -y to apt/apt-file (noninteractive installs)
  -h, --help           Show this help and exit

EXAMPLES:
  # Full setup, then interactively choose a package for ieeeconf.sty
  sudo ./setup-texlive.sh --sty ieeeconf.sty

  # Only resolve and install the first match for glossaries.sty
  sudo ./setup-texlive.sh --skip-core --sty glossaries.sty --first -y
USAGE
}

# Parse CLI args (supports short and long)
while [[ $# -gt 0 ]]; do
  case "$1" in
    -s|--sty)
      STY_FILE="${2:-}"
      if [[ -z "$STY_FILE" ]]; then
        echo "Error: --sty requires an argument" >&2
        usage; exit 2
      fi
      shift 2
      ;;
    -f|--first)
      AUTO_FIRST="true"
      shift
      ;;
    --skip-core)
      SKIP_CORE="true"
      shift
      ;;
    -y|--assume-yes)
      ASSUME_YES="-y"
      shift
      ;;
    -h|--help)
      usage; exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage; exit 2
      ;;
  esac
done

require_cmd() {
  local cmd="$1" pkg="${2:-$1}"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    log_message "Installing missing dependency: $pkg"
    $SUDO apt update
    $SUDO apt install $ASSUME_YES "$pkg"
  fi
}

install_core_texlive() {
  log_message "Updating the system..."
  $SUDO apt update && $SUDO apt upgrade $ASSUME_YES

  log_message "Installing essential LaTeX tools..."
  # Note: xelatex is provided by texlive-xetex (not a package named 'xelatex')
  $SUDO apt install $ASSUME_YES latexmk texlive-xetex biber

  log_message "Installing TeX Live (large metapackages)..."
  $SUDO apt install $ASSUME_YES texlive texlive-lang-all texlive-fonts-extra texlive-science

  log_message "Installing extra TeX Live utilities..."
  $SUDO apt install $ASSUME_YES texlive-bibtex-extra texlive-humanities
}

ensure_apt_file() {
  log_message "Ensuring apt-file is installed and updated..."
  require_cmd apt-file apt-file
  $SUDO apt-file update
}

ensure_tui() {
  # We'll use 'whiptail' for the TUI if available; otherwise fallback to a simple prompt.
  if command -v whiptail >/dev/null 2>&1; then
    return 0
  fi
  log_message "Installing whiptail for TUI selection (optional; fallback is a simple prompt)..."
  $SUDO apt update
  $SUDO apt install $ASSUME_YES whiptail || {
    log_message "whiptail not available; falling back to text prompt."
    USE_TUI="false"
  }
}

select_package_tui() {
  # Args: array of package names via stdin, one per line
  mapfile -t pkgs
  if [[ ${#pkgs[@]} -eq 0 ]]; then
    echo ""; return 0
  fi
  # Build whiptail menu entries: tag item tag item ...
  local menu_items=()
  local i=1
  for p in "${pkgs[@]}"; do
    menu_items+=("$i" "$p")
    ((i++))
  done
  local height=20 width=70 menu_height=10
  local choice
  choice=$(whiptail --title "TeX Live package selection" \
                    --menu "Select a package to install for the requested .sty:" \
                    $height $width $menu_height \
                    "${menu_items[@]}" \
                    3>&1 1>&2 2>&3) || { echo ""; return 0; }
  if [[ -z "$choice" ]]; then echo ""; return 0; fi
  # Map numeric choice back to package name
  echo "${pkgs[choice-1]}"
}

select_package_prompt() {
  # Args: array via stdin
  mapfile -t pkgs
  if [[ ${#pkgs[@]} -eq 0 ]]; then
    echo ""; return 0
  fi
  echo "Multiple packages provide this .sty. Choose one:"
  local i=1
  for p in "${pkgs[@]}"; do
    printf '  [%d] %s\n' "$i" "$p"
    ((i++))
  done
  local sel
  read -r -p "Enter number (or press Enter to cancel): " sel
  if [[ -z "${sel:-}" ]]; then echo ""; return 0; fi
  if ! [[ "$sel" =~ ^[0-9]+$ ]] || (( sel < 1 || sel > ${#pkgs[@]} )); then
    echo ""; return 0
  fi
  echo "${pkgs[sel-1]}"
}

resolve_and_install_sty() {
  local sty="$1"
  if [[ -z "$sty" ]]; then
    log_message "No .sty file specified; skipping apt-file lookup."
    return 0
  fi

  # Normalize: ensure it ends with .sty
  if [[ "$sty" != *.sty ]]; then
    sty="${sty}.sty"
  fi
  local base
  base="$(basename -- "$sty")"

  ensure_apt_file
  ensure_tui

  log_message "Searching for package providing '$base' with apt-file..."
  # Use regex to match the exact filename at path end
  # Output looks like: texlive-latex-extra: path/to/file.sty
  mapfile -t pkgs < <(apt-file find -x "/${base}$" \
                      | awk -F: '{print $1}' \
                      | grep -E '^texlive' \
                      | sort -u)

  if [[ ${#pkgs[@]} -eq 0 ]]; then
    log_message "No packages found providing '$base'."
    return 1
  fi

  local selected=""
  if [[ "$AUTO_FIRST" == "true" ]]; then
    selected="${pkgs[0]}"
    log_message "Auto-selecting first match: $selected"
  else
    if [[ "$USE_TUI" == "true" && "$(command -v whiptail)" ]]; then
      selected="$(printf '%s\n' "${pkgs[@]}" | select_package_tui)"
    else
      selected="$(printf '%s\n' "${pkgs[@]}" | select_package_prompt)"
    fi
  fi

  if [[ -z "$selected" ]]; then
    log_message "No selection made; skipping installation."
    return 0
  fi

  log_message "Installing package: $selected"
  $SUDO apt update
  $SUDO apt install $ASSUME_YES "$selected"
  log_message "Done installing '$selected'."
}

verify_install() {
  log_message "Verifying the TeX Live installation..."
  if command -v pdflatex >/dev/null 2>&1; then
    log_message "TeX Live seems installed (pdflatex found)."
  else
    log_message "TeX Live installation may be incomplete (pdflatex not found)."
  fi
}

main() {
  if [[ "$SKIP_CORE" != "true" ]]; then
    install_core_texlive
  fi
  resolve_and_install_sty "$STY_FILE"
  if [[ "$SKIP_CORE" != "true" ]]; then
    verify_install
  fi
}

main "$@"

#!/bin/bash

# -------------------------
# Color + formatting macros
# -------------------------
# Disable color if:
# - NO_COLOR is set
# - not a TTY
# - TERM is dumb
_use_color=true
if [[ -n "${NO_COLOR:-}" || ! -t 1 || "${TERM:-dumb}" == "dumb" ]]; then
  _use_color=false
fi

SUDO=""
if [[ "${EUID:-$(id -u)}" -ne 0 ]]; then
  SUDO="sudo"
fi

# Prefer tput when available (handles terminals that aren't ANSI)
if $_use_color && command -v tput >/dev/null 2>&1; then
  if tput colors >/dev/null 2>&1; then
    RST="$(tput sgr0)"
    BLD="$(tput bold)"
    DIM="$(tput dim 2>/dev/null || printf '')"
    RED="$(tput setaf 1)"
    GRN="$(tput setaf 2)"
    YEL="$(tput setaf 3)"
    BLU="$(tput setaf 4)"
    MAG="$(tput setaf 5)"
    CYN="$(tput setaf 6)"
    GRY="$(tput setaf 7)"
  else
    _use_color=false
  fi
fi

# ANSI fallback
if ! $_use_color; then
  RST=""; BLD=""; DIM=""
  RED=""; GRN=""; YEL=""; BLU=""; MAG=""; CYN=""; GRY=""
fi

# Symbols (ASCII safe)
OK="[OK]"
ER="[ERR]"
WRN="[!]"
INF="[-]"

# Print helpers
say()      { printf "%b\n" "$*"; }
info()     { say "${BLU}${INF}${RST} $*"; }
warn()     { say "${YEL}${WRN}${RST} $*"; }
success()  { say "${GRN}${OK}${RST} $*"; }
error()    { say "${RED}${ER}${RST} $*" 1>&2; }
headline() { say "${BLD}$*${RST}"; }

log_message () {
  echo "[$(date --rfc-3339=seconds)] $1" >> install_log.txt
}

secure_download() {
  url=$1
  output_file=$2
  if curl --proto '=https' --tlsv1.2 -fSL "$url" -o "$output_file"; then
    success "Downloaded ${CYN}${url}${RST} → ${MAG}${output_file}${RST}"
    log_message "Downloaded $url successfully."
    return 0
  else
    error "Failed to download ${CYN}${url}${RST}"
    log_message "Error downloading $url."
    return 1
  fi
}

setup_environment() {
  export_path=$1
  headline "Setting up environment variables..."
  shell_rc_file=""

  case "$SHELL" in
    */bash) shell_rc_file="$HOME/.bashrc" ;;
    */zsh)  shell_rc_file="$HOME/.zshrc" ;;
    */ksh)  shell_rc_file="$HOME/.kshrc" ;;
    */fish) shell_rc_file="$HOME/.config/fish/config.fish" ;;
    *)      error "Unsupported shell: $SHELL"; exit 1 ;;
  esac

  # Append PATH line if not already present
  if ! grep -qsE "^export PATH=${export_path//\//\\/}:" "$shell_rc_file"; then
    echo "export PATH=$export_path:\$PATH" >> "$shell_rc_file"
    success "Updated ${CYN}${shell_rc_file}${RST} with PATH entry."
  else
    info "PATH entry already present in ${CYN}${shell_rc_file}${RST}."
  fi

  # shellcheck disable=SC1090
  # Source only for compatible shells
  case "$SHELL" in
    */bash|*/zsh|*/ksh)
      # shellcheck disable=SC1090
      source "$shell_rc_file"
      ;;
    */fish)
      # fish uses different syntax; advise the user
      warn "Detected fish; open a new shell or run: ${CYN}source $shell_rc_file${RST}"
      ;;
  esac
}

is_installed() {
  pacman -Qi "$1" &>/dev/null
}

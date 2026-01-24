install_mise() {
  if command_exists mise; then
    log INFO "mise already installed"
    return 0
  fi

  if [[ "$PKG" == "apt" ]]; then
    log INFO "Installing mise via apt (Ubuntu/Debian)"
    run "sudo apt update -y && sudo apt install -y curl && sudo install -d -m 755 /etc/apt/keyrings && curl -fsSL https://mise.jdx.dev/gpg-key.pub | sudo tee /etc/apt/keyrings/mise-archive-keyring.asc >/dev/null && echo \"deb [signed-by=/etc/apt/keyrings/mise-archive-keyring.asc] https://mise.jdx.dev/deb stable main\" | sudo tee /etc/apt/sources.list.d/mise.list && sudo apt update -y && sudo apt install -y mise"
  else
    log INFO "Installing mise via curl installer"
    run "curl https://mise.run | sh"
  fi
}

get_mise_bin() {
  if command_exists mise; then
    command -v mise
    return 0
  fi

  if [[ -x "$HOME/.local/bin/mise" ]]; then
    echo "$HOME/.local/bin/mise"
    return 0
  fi

  if [[ -x "/usr/bin/mise" ]]; then
    echo "/usr/bin/mise"
    return 0
  fi

  echo ""
  return 1
}

setup_mise_langs() {
  local mise_bin
  mise_bin="$(get_mise_bin)"
  if [[ -z "$mise_bin" ]]; then
    log WARN "mise binary not found, skipping language installs"
    return 0
  fi

  if [[ "$DRY_RUN" == "1" ]]; then
    log INFO "[dry-run] $mise_bin install node@lts python@latest pnpm@latest"
    return 0
  fi

  if ! MISE_HTTP_TIMEOUT=120 "$mise_bin" install node@lts python@latest pnpm@latest rust@latest; then
    log WARN "mise tool install failed (network). You can retry later with:"
    log WARN "  MISE_HTTP_TIMEOUT=120 $mise_bin install node@lts python@latest pnpm@latest rust@latest"
  fi
}

setup_mise_activate_zsh() {
  local zshrc="$HOME/.zshrc"
  local mise_bin
  local line

  mise_bin="$(get_mise_bin)"
  if [[ -z "$mise_bin" ]]; then
    log WARN "mise binary not found, skipping activation setup"
    return 0
  fi
  line="eval \"\$(${mise_bin} activate zsh)\""

  if [[ "$DRY_RUN" == "1" ]]; then
    log INFO "[dry-run] ensure mise activate in $zshrc"
    return 0
  fi

  if [[ ! -f "$zshrc" ]]; then
    log INFO "Creating $zshrc with mise activate"
    printf "%s\n" "$line" > "$zshrc"
    return 0
  fi

  if grep -Fxq "$line" "$zshrc"; then
    log INFO "mise activate already configured in $zshrc"
    return 0
  fi

  if grep -q "mise activate zsh" "$zshrc"; then
    log INFO "mise activate already configured in $zshrc"
  else
    log INFO "Adding mise activate to $zshrc"
    printf "\n# mise\n%s\n" "$line" >> "$zshrc"
  fi
}

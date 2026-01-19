install_zsh_env() {
  log INFO "Setting up zsh environment"

  if [[ "$IS_PIPED" == "1" ]]; then
    log WARN "Running in piped mode (curl | bash), skipping oh-my-zsh install"
    log INFO "If you want to use zsh as default shell later, run:"
    log INFO "  chsh -s $(command -v zsh)"
    return
  fi

  if [[ ! -d ~/.oh-my-zsh ]]; then
    log INFO "Installing oh-my-zsh"
    run 'RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'
  else
    log INFO "oh-my-zsh already installed"
  fi

  if [[ "$SHELL" != *zsh ]]; then
    log INFO "Current default shell is not zsh"
    log INFO "To switch default shell to zsh, run:"
    log INFO "  chsh -s $(command -v zsh)"
    log INFO "Then log out and log back in"
  else
    log INFO "Default shell is already zsh"
  fi
}
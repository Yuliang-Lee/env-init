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

  install_oh_my_zsh_plugins
  configure_oh_my_zsh_plugins
  configure_oh_my_zsh_theme

  if [[ "$SHELL" != *zsh ]]; then
    log INFO "Current default shell is not zsh"
    log INFO "To switch default shell to zsh, run:"
    log INFO "  chsh -s $(command -v zsh)"
    log INFO "Then log out and log back in"
  else
    log INFO "Default shell is already zsh"
  fi
}

configure_oh_my_zsh_theme() {
  local custom_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
  local themes_dir="$custom_dir/themes"
  local theme_file="$themes_dir/xlaoyu.zsh-theme"
  local zshrc="$HOME/.zshrc"
  local theme_name="xlaoyu"
  local theme_content

  if [[ "$DRY_RUN" == "1" ]]; then
    log INFO "[dry-run] write $theme_file and set ZSH_THEME"
    return 0
  fi

  mkdir -p "$themes_dir"
  theme_content=$'PROMPT=\'[%*] %{$fg[cyan]%}%n%{$reset_color%}:%{$fg[green]%}%c%{$reset_color%}$(git_prompt_info) %(!.#.$) \'\n\nZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[yellow]%}git:("\nZSH_THEME_GIT_PROMPT_SUFFIX=")%{$reset_color%}"\n'
  if [[ -f "$theme_file" ]] && grep -Fqx "$theme_content" "$theme_file"; then
    log INFO "Theme file already configured: $theme_file"
  else
    printf "%s" "$theme_content" > "$theme_file"
  fi

  if [[ ! -f "$zshrc" ]]; then
    log INFO "Creating $zshrc with ZSH_THEME=$theme_name"
    printf "ZSH_THEME=\"%s\"\n" "$theme_name" > "$zshrc"
    return 0
  fi

  if grep -q "^ZSH_THEME=\"${theme_name}\"$" "$zshrc"; then
    log INFO "ZSH_THEME already set to $theme_name in $zshrc"
    return 0
  fi

  if grep -q '^ZSH_THEME=' "$zshrc"; then
    log INFO "Updating ZSH_THEME in $zshrc"
    awk -v repl="ZSH_THEME=\"${theme_name}\"" '
      BEGIN { done=0 }
      /^ZSH_THEME=/ && done==0 { print repl; done=1; next }
      { print }
      END { if (done==0) print repl }
    ' "$zshrc" > "$zshrc.tmp" && mv "$zshrc.tmp" "$zshrc"
  else
    log INFO "Adding ZSH_THEME to $zshrc"
    printf "\nZSH_THEME=\"%s\"\n" "$theme_name" >> "$zshrc"
  fi
}

install_oh_my_zsh_plugins() {
  local custom_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
  local plugins_dir="$custom_dir/plugins"

  if [[ "$DRY_RUN" == "1" ]]; then
    log INFO "[dry-run] ensure oh-my-zsh plugins in $plugins_dir"
    return 0
  fi

  mkdir -p "$plugins_dir"

  if [[ ! -d "$plugins_dir/zsh-autosuggestions" ]]; then
    log INFO "Installing zsh-autosuggestions"
    run "GIT_TERMINAL_PROMPT=0 git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions \"$plugins_dir/zsh-autosuggestions\""
  else
    log INFO "zsh-autosuggestions already installed"
  fi

  if [[ ! -d "$plugins_dir/zsh-syntax-highlighting" ]]; then
    log INFO "Installing zsh-syntax-highlighting"
    run "GIT_TERMINAL_PROMPT=0 git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting \"$plugins_dir/zsh-syntax-highlighting\""
  else
    log INFO "zsh-syntax-highlighting already installed"
  fi
}

configure_oh_my_zsh_plugins() {
  local zshrc="$HOME/.zshrc"
  local plugins_line="plugins=(git colorize z extract brew zsh-autosuggestions zsh-syntax-highlighting)"

  if [[ "$DRY_RUN" == "1" ]]; then
    log INFO "[dry-run] set plugins in $zshrc"
    return 0
  fi

  if [[ ! -f "$zshrc" ]]; then
    log INFO "Creating $zshrc with plugins"
    printf "%s\n" "$plugins_line" > "$zshrc"
    return 0
  fi

  if grep -q "^${plugins_line}$" "$zshrc"; then
    log INFO "Plugins already configured in $zshrc"
    return 0
  fi

  if grep -q "^plugins=" "$zshrc"; then
    log INFO "Updating plugins in $zshrc"
    awk -v repl="$plugins_line" '
      BEGIN { done=0 }
      /^plugins=/ && done==0 { print repl; done=1; next }
      { print }
      END { if (done==0) print repl }
    ' "$zshrc" > "$zshrc.tmp" && mv "$zshrc.tmp" "$zshrc"
  else
    log INFO "Adding plugins to $zshrc"
    printf "\n%s\n" "$plugins_line" >> "$zshrc"
  fi
}

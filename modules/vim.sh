setup_vim() {
  local vimrc="$HOME/.vimrc"
  local line_encoding="set encoding=utf-8"
  local line_syntax="syntax on"

  if [[ "$DRY_RUN" == "1" ]]; then
    log INFO "[dry-run] ensure vimrc settings in $vimrc"
    return 0
  fi

  if [[ ! -f "$vimrc" ]]; then
    printf "%s\n%s\n" "$line_encoding" "$line_syntax" > "$vimrc"
    return 0
  fi

  if grep -q "^${line_encoding}$" "$vimrc" && grep -q "^${line_syntax}$" "$vimrc"; then
    log INFO "vimrc already configured"
    return 0
  fi

  if ! grep -q "^${line_encoding}$" "$vimrc"; then
    printf "\n%s\n" "$line_encoding" >> "$vimrc"
  fi
  if ! grep -q "^${line_syntax}$" "$vimrc"; then
    printf "\n%s\n" "$line_syntax" >> "$vimrc"
  fi
}

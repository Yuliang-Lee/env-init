install_mise() {
  command_exists mise || run "curl https://mise.run | sh"
}
setup_mise_langs() {
  run "~/.local/bin/mise install node@lts python@latest pnpm@latest"
}

install_docker() {
  if command_exists docker; then
    log INFO "docker already installed"
    return 0
  fi

  log INFO "Installing docker (may take a while)"
  run "curl -fsSL --connect-timeout 10 --retry 3 --retry-delay 2 https://get.docker.com | sh"
}

install_docker() {
  command_exists docker || run "curl -fsSL https://get.docker.com | sh"
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

install_pkg_manager() {
  [[ "$PKG" == "apt" ]] && run "sudo apt-get update"
}

install_pkg() {
  case "$PKG" in
    brew) run "brew install $1 || true" ;;
    apt) run "sudo apt-get install -y $1" ;;
    yum) run "sudo yum install -y $1" ;;
  esac
}

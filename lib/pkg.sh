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

get_git_installed_version() {
  if ! command_exists git; then
    echo ""
    return 0
  fi

  case "$PKG" in
    apt)
      dpkg-query -W -f='${Version}' git 2>/dev/null || git --version | awk '{print $3}'
      ;;
    yum)
      rpm -q --qf '%{VERSION}-%{RELEASE}' git 2>/dev/null || git --version | awk '{print $3}'
      ;;
    brew)
      git --version | awk '{print $3}'
      ;;
    *)
      git --version | awk '{print $3}'
      ;;
  esac
}

get_git_available_version() {
  case "$PKG" in
    apt)
      apt-cache policy git 2>/dev/null | awk '/Candidate:/ {print $2}'
      ;;
    yum)
      yum --showduplicates list git 2>/dev/null | awk '/^git\./ {print $2}' | sort -V | tail -1
      ;;
    brew)
      echo ""
      ;;
    *)
      echo ""
      ;;
  esac
}

ensure_git_latest() {
  if ! command_exists git; then
    log INFO "git not found, installing"
    install_pkg git
    return 0
  fi

  case "$PKG" in
    apt)
      local installed candidate
      installed=$(get_git_installed_version)
      candidate=$(get_git_available_version)
      if [[ -n "$candidate" && "$candidate" != "(none)" && "$installed" != "$candidate" ]]; then
        log INFO "Upgrading git from $installed to $candidate"
        run "sudo apt-get install -y git"
      else
        log INFO "git is up to date ($installed)"
      fi
      ;;
    yum)
      local installed latest
      installed=$(get_git_installed_version)
      latest=$(get_git_available_version)
      if [[ -n "$latest" && "$installed" != "$latest" ]]; then
        log INFO "Upgrading git from $installed to $latest"
        run "sudo yum update -y git"
      else
        log INFO "git is up to date ($installed)"
      fi
      ;;
    brew)
      if [[ -n "$(brew outdated git 2>/dev/null)" ]]; then
        log INFO "Upgrading git via brew"
        run "brew upgrade git"
      else
        log INFO "git is up to date"
      fi
      ;;
    *)
      log INFO "Unknown package manager, skipping git version check"
      ;;
  esac
}

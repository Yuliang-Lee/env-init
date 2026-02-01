install_docker() {
  if command_exists docker; then
    log INFO "docker already installed"
    
    # Check if current user is in docker group
    if ! groups | grep -q docker; then
      log WARN "Current user is not in docker group, adding now"
      run "sudo usermod -aG docker $USER"
      log WARN "Please logout and login again, or run 'newgrp docker' to use docker without sudo"
    fi
    return 0
  fi

  log INFO "Installing docker (may take a while)"
  run "curl -fsSL --connect-timeout 10 --retry 3 --retry-delay 2 https://get.docker.com | sh"
  
  # Add current user to docker group so they can run docker without sudo
  log INFO "Adding current user to docker group"
  run "sudo usermod -aG docker $USER"
  
  log WARN "Docker installed successfully!"
  log WARN "Please logout and login again, or run 'newgrp docker' to use docker without sudo"
}

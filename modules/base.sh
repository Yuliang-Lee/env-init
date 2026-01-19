install_base() {
  for p in git curl wget unzip vim tmux zsh; do
    install_pkg "$p"
  done
}

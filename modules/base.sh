install_base() {
  ensure_git_latest
  for p in curl wget unzip vim tmux zsh; do
    install_pkg "$p"
  done
}

install_rust() {
  command_exists rustup || run "curl https://sh.rustup.rs -sSf | sh -s -- -y"
}

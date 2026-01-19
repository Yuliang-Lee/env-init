#!/usr/bin/env bash
set -e
ROOT=$(cd "$(dirname "$0")" && pwd)

source "$ROOT/config.sh"
source "$ROOT/lib/log.sh"
source "$ROOT/lib/os.sh"
source "$ROOT/lib/pkg.sh"

source "$ROOT/modules/base.sh"
source "$ROOT/modules/zsh.sh"
source "$ROOT/modules/mise.sh"
source "$ROOT/modules/rust.sh"
source "$ROOT/modules/docker.sh"
source "$ROOT/modules/vim.sh"

detect_os
install_pkg_manager

[[ "$ENABLE_BASE" == "1" ]] && install_base
[[ "$ENABLE_ZSH" == "1" ]] && install_zsh_env
[[ "$ENABLE_MISE" == "1" ]] && install_mise && setup_mise_langs
[[ "$ENABLE_RUST" == "1" ]] && install_rust
[[ "$ENABLE_DOCKER" == "1" ]] && install_docker
[[ "$ENABLE_VIM" == "1" ]] && setup_vim

log INFO "Completed. Version=$VERSION BuildTime=$BUILD_TIME"

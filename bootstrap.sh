#!/usr/bin/env bash
set -e
ROOT=$(cd "$(dirname "$0")" && pwd)

if [[ -f "$ROOT/config.sh" ]]; then
  source "$ROOT/config.sh"
fi
if [[ -f "$ROOT/lib/log.sh" ]]; then
  source "$ROOT/lib/log.sh"
fi
if [[ -f "$ROOT/lib/os.sh" ]]; then
  source "$ROOT/lib/os.sh"
fi
if [[ -f "$ROOT/lib/pkg.sh" ]]; then
  source "$ROOT/lib/pkg.sh"
fi

if [[ -f "$ROOT/modules/base.sh" ]]; then
  source "$ROOT/modules/base.sh"
fi
if [[ -f "$ROOT/modules/zsh.sh" ]]; then
  source "$ROOT/modules/zsh.sh"
fi
if [[ -f "$ROOT/modules/mise.sh" ]]; then
  source "$ROOT/modules/mise.sh"
fi
if [[ -f "$ROOT/modules/docker.sh" ]]; then
  source "$ROOT/modules/docker.sh"
fi
if [[ -f "$ROOT/modules/vim.sh" ]]; then
  source "$ROOT/modules/vim.sh"
fi

detect_os
install_pkg_manager

[[ "$ENABLE_BASE" == "1" ]] && install_base
[[ "$ENABLE_ZSH" == "1" ]] && install_zsh_env
[[ "$ENABLE_MISE" == "1" ]] && install_mise && setup_mise_activate_zsh && setup_mise_langs
[[ "$ENABLE_DOCKER" == "1" ]] && install_docker
[[ "$ENABLE_VIM" == "1" ]] && setup_vim

log INFO "Completed. Version=$VERSION BuildTime=$BUILD_TIME"

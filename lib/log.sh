log_ts() { date +"%Y-%m-%d %H:%M:%S"; }

log() {
  local level="$1"; shift
  echo "$(log_ts) [$level] $*"
}

run() {
  if [[ "$DRY_RUN" == "1" ]]; then
    log INFO "[dry-run] $*"
  else
    eval "$@"
  fi
}

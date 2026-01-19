detect_os() {
  if [[ ! -t 0 ]]; then
    IS_PIPED=1
  else
    IS_PIPED=0
  fi

  if [[ "$OSTYPE" == "darwin"* ]]; then
    PKG="brew"
  else
    . /etc/os-release
    case "$ID" in
      ubuntu|debian) PKG="apt" ;;
      centos|rhel|rocky|almalinux) PKG="yum" ;;
      *) echo "Unsupported OS"; exit 1 ;;
    esac
  fi
}

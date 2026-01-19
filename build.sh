#!/usr/bin/env bash
set -e

# 读取 config.sh VERSION
ROOT=$(cd "$(dirname "$0")" && pwd)
source "$ROOT/config.sh"

if [[ -z "$VERSION" ]]; then
  echo "VERSION not set in config.sh"
  exit 1
fi

OUT=dist/env-init.sh
mkdir -p dist

{
  echo '#!/usr/bin/env bash'
  sed '/^#!/d' config.sh
  sed '/^#!/d' lib/*.sh
  sed '/^#!/d' modules/*.sh
  sed '/^#!/d' bootstrap.sh
} > "$OUT"

chmod +x "$OUT"

# 生成 SHA256 校验
sha256sum "$OUT" > "$OUT.sha256"

echo "Built env-init.sh version $VERSION"
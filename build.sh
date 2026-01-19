#!/usr/bin/env bash
set -e
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
sha256sum "$OUT" > "$OUT.sha256"

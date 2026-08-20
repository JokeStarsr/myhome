#!/bin/bash
# My Home 状态检测 (2026-08-21)：探测各系统并写 status.json 供页面同源读取
SVCS=(
  "cogno:http://127.0.0.1:8090/"
  "bible:http://127.0.0.1/"
  "getinfo:http://127.0.0.1:8200/"
  "springai:http://127.0.0.1:18080/"
  "kefu:http://127.0.0.1:8082/"
  "mission:http://127.0.0.1:8088/"
)
OUT=/www/wwwroot/myhome/status.json
TMP=$OUT.tmp
{
  printf '{"ts":%d' "$(date +%s)"
  for entry in "${SVCS[@]}"; do
    id="${entry%%:*}"; url="${entry#*:}"
    code=$(curl -s -o /dev/null -m 5 -w "%{http_code}" "$url" 2>/dev/null)
    if [ "${code:-000}" -ge 200 ] && [ "${code:-000}" -lt 400 ]; then st="ok"; else st="down"; fi
    printf ',"%s":"%s"' "$id" "$st"
  done
  echo "}"
} > "$TMP"
mv "$TMP" "$OUT"
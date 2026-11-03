#!/usr/bin/env bash
set -euo pipefail
BASE="https://api.businesscentral.dynamics.com/v2.0/$BC_TENANT_ID/$BC_ENVIRONMENT"

token() {
  curl -sf -X POST "https://login.microsoftonline.com/$BC_TENANT_ID/oauth2/v2.0/token" \
    -d grant_type=client_credentials -d client_id="$BC_CLIENT_ID" \
    --data-urlencode client_secret="$BC_CLIENT_SECRET" \
    -d scope=https://api.businesscentral.dynamics.com/.default | jq -r .access_token
}

symbols() {   # lädt Platform/Application + alle Dependencies aus app.json nach .alpackages
  local T; T=$(token); mkdir -p .alpackages
  local app=$(jq -r .application app.json) plat=$(jq -r .platform app.json)
  { echo "Microsoft|System|$plat"
    echo "Microsoft|Application|$app"
    jq -r '.dependencies[]? | "\(.publisher)|\(.name)|\(.version)"' app.json; } |
  while IFS='|' read -r pub name ver; do
    echo "↓ $pub $name $ver"
    curl -sfG "$BASE/dev/packages" -H "Authorization: Bearer $T" \
      --data-urlencode "publisher=$pub" --data-urlencode "appName=$name" \
      --data-urlencode "versionText=$ver" -o ".alpackages/${pub}_${name}_${ver}.app"
  done
}

publish() {   # $1 = .app-Datei
  curl -sf -X POST "$BASE/dev/apps?SchemaUpdateMode=forcesync" \
    -H "Authorization: Bearer $(token)" -F "file=@$1;type=application/octet-stream" \
    && echo "✅ deployed $1"
}

"$@"
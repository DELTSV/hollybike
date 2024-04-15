#bin/bash

repo="${1:-deltsv/hollybike}"
token=$(curl -s "https://ghcr.io/token?service=ghcr.io&scope=repository:${repo}:pull" \
             -u "deltsv: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" \
        | jq -r '.token')
curl -H "Authorization: Bearer $token" \
     -s "https://ghcr.io/v2/${repo}/tags/list" | jq .
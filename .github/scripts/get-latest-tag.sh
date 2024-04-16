#bin/bash

repo="${1:-deltsv/hollybike}"
gh_token=$2
token=$(curl -s "https://ghcr.io/token?service=ghcr.io&scope=repository:${repo}:pull" \
             -u "deltsv:${gh_token}" \
        | jq -r '.token')

curl -H "Authorization: Bearer $token" \
     -s "https://ghcr.io/v2/${repo}/tags/list" | jq .
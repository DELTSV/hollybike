#!/bin/bash

json_data=$(gh api \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
      /orgs/deltsv/packages/container/hollybike/versions)

echo "$json_data" | jq '.[0].metadata.container.tags[0]' | tr -d '"'


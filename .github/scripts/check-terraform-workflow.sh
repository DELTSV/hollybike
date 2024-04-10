#bin/bash

isTerraform=$(gh api -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" "/repos/$2/actions/runs?status=in_progress&event=push" | grep -q "$1" && echo true || echo false)

echo "$isTerraform"

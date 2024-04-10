#bin/bash

# If the result contains Terraform, store true, else store false
isTerraform=$(gh api -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" "/repos/DELTSV/hollybike/actions/runs?status=in_progress&event=push" | jq '.workflow_runs[].jobs[].name' | grep -q "Terraform" && echo true || echo false)

echo "$isTerraform"

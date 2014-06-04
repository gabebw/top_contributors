#!/bin/zsh

# Usage: ./main.zsh ORGANIZATION_NAME TOKEN

ORGANIZATION="$1"
TOKEN="$2"

GIT_NAME=$(git config user.name)

for repo_name in $(./list_all_public_repos.zsh "$ORGANIZATION" "$TOKEN")
do
  echo $repo_name
  if git clone "https://github.com/${ORGANIZATION}/${repo_name}.git"
  then
    cd "$repo_name" &> /dev/null
    git shortlog -ns | nl | ag "${GIT_NAME}$" | awk '{$1=""; print $0 }' | head -1
  fi

done

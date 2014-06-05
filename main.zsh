#!/bin/zsh

# Usage: ./main.zsh ORGANIZATION_NAME TOKEN

ORGANIZATION="$1"
TOKEN="$2"

GIT_NAME=$(git config user.name)
TOPLEVEL_DIR=$(pwd)

for repo_name in $(./list_all_public_repos.zsh "$ORGANIZATION" "$TOKEN")
do
  cd "$TOPLEVEL_DIR"
  if [[ -d "$repo_name" ]]; then
    cd "$repo_name"
    git checkout master &>/dev/null
    git pull origin master &>/dev/null
  else
    git clone "https://github.com/${ORGANIZATION}/${repo_name}.git"
  fi

  cd "$repo_name" &> /dev/null
  rank=$(git shortlog -ns | nl | ag "^\W+[0-9]+\W+[0-9]+\t${GIT_NAME}$" | cut -f1 | xargs echo)

  if [[ -n "$rank" ]]
  then
    echo "$repo_name: #${rank}"
  fi
done

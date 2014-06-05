#!/bin/zsh

# Usage: ./main.zsh ORGANIZATION_NAME TOKEN

ORGANIZATION="$1"
TOKEN="$2"

GIT_NAME=$(git config user.name)
TOPLEVEL_DIR=$(pwd)

mkdir -p repos

function clone_and_cd_into {
  if [[ -d "$repo_name" ]]; then
    cd "$repo_name"
    git checkout master &>/dev/null
    git pull origin master &>/dev/null
  else
    git clone "https://github.com/${ORGANIZATION}/${repo_name}.git"
  fi

  cd "$repo_name" &> /dev/null
}

function rank_for {
  local repo_name="$1"

  cd "$TOPLEVEL_DIR/repos"
  clone_and_cd_into "$repo_name"

  git shortlog -ns | nl | ag "^\W+[0-9]+\W+[0-9]+\t${GIT_NAME}$" | cut -f1 | xargs echo
}

for repo_name in $(./list_all_public_repos.zsh "$ORGANIZATION" "$TOKEN")
do
  rank=$(rank_for "$repo_name")

  if [[ -n "$rank" ]]
  then
    echo "$repo_name: #${rank}"
  else
    echo "$repo_name: No contributions"
  fi
done

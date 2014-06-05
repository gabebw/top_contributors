#!/bin/zsh

ORGANIZATION="$1"
TOKEN="$2"

if [[ $# != 2 ]]; then
  echo "Usage: ./main.zsh ORGANIZATION_NAME TOKEN"
  exit 1
fi

GIT_NAME=$(git config user.name)
TOPLEVEL_DIR=$(pwd)

mkdir -p repos

function clone_or_update_repo {
  cd "$TOPLEVEL_DIR/repos"

  if [[ -d "$repo_name" ]]; then
    cd "$repo_name"
    git checkout master &>/dev/null
    git pull origin master &>/dev/null
  else
    git clone "https://github.com/${ORGANIZATION}/${repo_name}.git"
  fi
}

function rank_for {
  local repo_name="$1"

  cd "$TOPLEVEL_DIR/repos/$repo_name" &> /dev/null

  if git log -1 -q &>/dev/null; then
    git shortlog -ns | nl | ag "^\W+[0-9]+\W+[0-9]+\t${GIT_NAME}$" | cut -f1 | xargs echo
  else
    # Repo has no commits
    echo ""
  fi
}

# Cast repos to an array (ZSH-only)
# @f = Split the result of the expansion at newlines.
# Docs: http://zsh.sourceforge.net/Doc/Release/Expansion.html#Parameter-Expansion-Flags
#
# The parentheses around the RHS cast to an array.
repos=( "${(@f)$(./list_all_public_repos.rb $ORGANIZATION $TOKEN)}" )

echo "Cloning and updating repos..."
for repo_name in $repos
do
  clone_or_update_repo "$repo_name"
done
echo "Done updating repos."

repos_with_rank=0
number_of_repos=0

cd "$TOPLEVEL_DIR"
for repo_name in $repos
do
  rank=$(rank_for "$repo_name")

  if [[ -n "$rank" ]]; then
    echo "$repo_name: #${rank}"
    repos_with_rank=$(($repos_with_rank + 1))
  else
    echo "$repo_name: No contributions"
  fi

  number_of_repos=$(($number_of_repos + 1))
done

percentage_contributed_to=$(bc <<<"scale=0; ($repos_with_rank * 100) / $number_of_repos")
echo "You contributed to ${percentage_contributed_to}% of organization repos"

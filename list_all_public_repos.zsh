#!/bin/zsh

# Usage: ./list_all_repos.zsh ORGANIZATION_NAME personal_access_token
# Get a token here: https://github.com/settings/applications


ORG="$1"
token="$2"

USER_AGENT="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/33.0.1750.152 Safari/537.36"

function query_api {
  local url_path="$1"

  curl \
    -u "${token}:x-oauth-basic" \
    -H 'Accept: application/vnd.github.v3+json' \
    -H "User-Agent: ${USER_AGENT}" \
    "https://api.github.com/${url_path}" \
    2> /dev/null
}

function all_public_repos_in_organization {
  # Some repos are under the user and some are under the org.
  query_api "users/${ORG}/repos" | jq --raw-output '.[].name'
  query_api "orgs/${ORG}/repos?type=public" | jq --raw-output '.[].name'
}

all_public_repos_in_organization | sort | uniq

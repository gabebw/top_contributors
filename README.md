# Are you a top contributor?

Find out where you rank for a given organization's open source repos.

## Requirements

First, get a [personal access token](https://github.com/settings/tokens/new)
with default scopes. Name it, hit "Generate Token", and copy it down.

Then install Octokit: `gem install octokit`.

## Run it

    ./main.zsh ORGANIZATION_NAME TOKEN

It will clone down every public repo in the organization, then start outputting results.

# Are you a top contributor?

Find out where you rank for a given organization's open source repos.

## Requirements

First, get a [personal access token](https://github.com/settings/tokens/new)
with default scopes. Name it, hit "Generate Token", and copy it down.

Then, install [jq](http://stedolan.github.io/jq). `brew install jq` will work.

## Run it

    ./main.zsh ORGANIZATION_NAME TOKEN

It will clone down a lot of repos, but it shouldn't take more than a few seconds
to start outputting results.

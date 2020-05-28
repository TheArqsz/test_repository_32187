#!/usr/bin/env bash

if [ -z "${GITHUB_TOKEN}" ]
then
    echo "GITHUB_TOKEN env var cannot be found - exiting"
    exit 0
fi

export GIT_COMMITTER_EMAIL='travis@travis'
export GIT_COMMITTER_NAME='Travis CI'
export GITHUB_REPO='TheArqsz/AntiPhishMe-backend'

if [ $TRAVIS_BRANCH != "develop" ]; then
    echo "Current branch doesn't match requirements to be merged"
    exit 0
fi

repo_temp=$(mktemp -d)
git clone "https://github.com/TheArqsz/AntiPhishMe-backend" "$repo_temp"

cd "$repo_temp"

printf 'Checking out %s\n' "master" >&2
git checkout "master"

printf 'Merging %s\n' "$TRAVIS_COMMIT" >&2
git merge --ff-only "$TRAVIS_COMMIT"

printf 'Pushing to %s\n' "https://github.com/$GITHUB_REPO" >&2

push_uri="https://$GITHUB_SECRET_TOKEN@github.com/$GITHUB_REPO"

git push "$push_uri" "master" >/dev/null 2>&1
git push "$push_uri" :"$TRAVIS_BRANCH" >/dev/null 2>&1

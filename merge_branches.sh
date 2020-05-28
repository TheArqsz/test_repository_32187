#!/usr/bin/env bash

if [ -z "${GITHUB_TOKEN}" ]
then
    echo "GITHUB_TOKEN env var cannot be found - exiting"
    exit 0
fi

export GIT_COMMITTER_EMAIL='travis@travis'
export GIT_COMMITTER_NAME='Travis CI'
export GIT_BRANCH_FROM='develop'
export GIT_BRANCH_TO='master'

if [ $TRAVIS_BRANCH != $GIT_BRANCH_FROM ]; then
    echo "Current branch doesn't match requirements to be merged"
    exit 0
fi

repo_temp=$(mktemp -d)
git clone "https://github.com/$TRAVIS_REPO_SLUG" "$repo_temp"

cd "$repo_temp"

echo "Checking out $TRAVIS_BRANCH"
git checkout $TRAVIS_BRANCH
echo "Checking out $GIT_BRANCH_TO"
git checkout $GIT_BRANCH_TO

git merge $TRAVIS_BRANCH --squash 
git commit -m "Automerging from $TRAVIS_BRANCH commit $TRAVIS_COMMIT"

echo "Pushing to https://github.com/$TRAVIS_REPO_SLUG"

push_uri="https://$GITHUB_TOKEN@github.com/$TRAVIS_REPO_SLUG"

git push $push_uri $GIT_BRANCH_TO

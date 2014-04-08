#!/usr/bin/env bash
#
# Push a git repository to a SSH URL.
#
# Example call:
# ./push-git-via-ssh.sh project git@GitServer:Project.git GitBranch /path/to/git-ssh.key
#

PROJECT_NAME=$1
GIT_TARGET_URL=$2
GIT_TARGET_BRANCH=$3
GIT_TARGET_SSH_KEY=$4

BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
WORKING_PATH="$BASE_DIR/repos/$PROJECT_NAME/${GIT_TARGET_BRANCH}"

export GIT_SSH_KEY="$GIT_TARGET_SSH_KEY"
export GIT_SSH="$BASE_DIR/git-ssh-helper.sh"

if [ -d "$WORKING_PATH" ]; then
    echo "Pushing Git data to $GIT_TARGET_URL..."

    pushd "$WORKING_PATH"
        git remote remove bridge
        git remote add bridge $GIT_TARGET_URL
        git push bridge $GIT_TARGET_BRANCH:$GIT_TARGET_BRANCH -f
    popd
fi

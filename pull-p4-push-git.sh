#!/usr/bin/env bash
#
# Sync Perforce repositories to Git
#
# Example call:
# ./pull-p4-push-git.sh //P4/Project@all tcp:P4Server:1672 P4User P4Pass git@GitServer:Project.git GitBranch /path/to/git-ssh.key /path/to/ignore.pattern
#

P4_SOURCE_PATH=$1
P4_SOURCE_PORT=$2
P4_SOURCE_USER=$3
P4_SOURCE_PASSWD=$4
GIT_TARGET_URL=$5
GIT_TARGET_BRANCH=$6
GIT_TARGET_SSH_KEY=$7
IGNORE_PATTERN_FILE="$8"

BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
WORKING_PATH="$BASE_DIR/repos/$(echo "$GIT_TARGET_URL" | sed 's/:/\//g' | sed 's/@/\//g')/${GIT_TARGET_BRANCH}"

P4_PATH="$BASE_DIR/p4"
GIT_P4=$BASE_DIR/git/git-p4.py

export PATH="$P4_PATH":"$PATH"
export P4PORT=$P4_SOURCE_PORT
export P4USER=$P4_SOURCE_USER
export P4PASSWD=$P4_SOURCE_PASSWD
export GIT_SSH_KEY="$GIT_TARGET_SSH_KEY"
export GIT_SSH="$BASE_DIR/git-ssh-helper.sh"


if [ ! -f "$P4_PATH/p4" ]; then
    echo "P4: Command-Line Client not found! Trying to download it..."

    if [[ "$(uname)" == "Darwin" ]]; then
        P4_CMD_LINE_TOOL_URL="http://filehost.perforce.com/perforce/r14.1/bin.macosx105x86_64/p4"
    elif [[ "$(uname)" == "Linux" ]]; then
        P4_CMD_LINE_TOOL_URL="http://filehost.perforce.com/perforce/r14.1/bin.linux26x86_64/p4"
    else
        echo "Unknown platform! Please download the client manually from http://www.perforce.com/downloads/Perforce/Customer"
        exit 1
    fi

    mkdir -p "$P4_PATH"
    pushd "$P4_PATH"
        curl --remote-name $P4_CMD_LINE_TOOL_URL
        chmod u+x ./p4
    popd
fi

echo "Log in to Perforce..."
echo -e "$P4_SOURCE_PASSWD\n" | "$P4_PATH/p4" login

if [ ! -d "$WORKING_PATH" ]; then
    echo "Initializing $P4_SOURCE_PATH..."

    ESCAPED_P4_PATH=$(echo "$P4_SOURCE_PATH" | sed 's/\//\\\//g' | sed 's/@all//g')
    IGNORE_PATTERN_CMD="sed 's/^/-${ESCAPED_P4_PATH}\\//' $IGNORE_PATTERN_FILE"
    IGNORE_PATTERN=$(eval $IGNORE_PATTERN_CMD)

    mkdir -p "$WORKING_PATH"

    pushd "$WORKING_PATH"
        $GIT_P4 clone $P4_SOURCE_PATH $IGNORE_PATTERN .

        git config --add git-p4.skipSubmitEdit true
        git config --add git-p4.detectRenames true
        git config --add git-p4.detectCopies true

        git remote add bridge $GIT_TARGET_URL
    popd
else
    echo "Syncing $P4_SOURCE_PATH..."

    pushd "$WORKING_PATH"
        git checkout p4/master
        LAST_GIT_HASH=$(git rev-parse p4/master)

        # Sync change lists from P4 to git
        $GIT_P4 sync

        if [ -f $IGNORE_PATTERN_FILE ]; then
            # Remove ignored files from history since the last commit
            git filter-branch --force --index-filter "git rm -r --cached --ignore-unmatch --force $(tr '\n' ' ' < $IGNORE_PATTERN_FILE)" $LAST_GIT_HASH..p4/master
        fi

        git branch -D $GIT_TARGET_BRANCH
        git checkout -b $GIT_TARGET_BRANCH
        git push bridge $GIT_TARGET_BRANCH:$GIT_TARGET_BRANCH -f
    popd
fi

#!/usr/bin/env bash
#
# This is kind of a daemon to perform the sync periodically. I recommend to run in a tmux session on some server.
#

# Ensure we are working with up-to-date user email addresses from Perforce.
rm ~/.gitp4-usercache.txt

BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

pushd "$BASE_DIR"
    while true
    do
        # Add your syncs here...

        # ./pull-p4-push-git.sh //P4/Project@all tcp:P4Server:1672 P4User P4Pass git@GitServer:Project.git GitBranch /path/to/git-ssh.key /path/to/ignore.pattern

        sleep 10
    done
popd

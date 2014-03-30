#!/usr/bin/env bash
#
# If the GIT_SSH environment variable is set to this file, git will execute the given ssh command
# to establish the connection. The GIT_SSH_KEY environment variable is used to set the SSH key.
# c.f. http://alvinabad.wordpress.com/2013/03/23/how-to-specify-an-ssh-key-file-with-the-git-command/
#
# Attention: Strict host key checking is explicitly disabled here to ease automation. Maybe this
# should be reverted if the service is mature to avoid potential man-in-the-middle attacks.
#
ssh -i "$GIT_SSH_KEY" -o StrictHostKeyChecking=no "$@"

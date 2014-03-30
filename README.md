git-p4-bridge
=============

Here is how you use it:

1. Define the source path of your Perforce repository that you want to sync to Git.
2. If necessary, create a list of ignored directories and store them in a file (see [example](https://raw.githubusercontent.com/larsxschneider/git-p4-bridge/master/example.ignore)). This file is used to ignore all irrelevant Perforce paths on
the [initial sync](https://github.com/larsxschneider/git-p4-bridge/blob/master/pull-p4-push-git.sh#L62) as well
as on every [subsequent sync](https://github.com/larsxschneider/git-p4-bridge/blob/master/pull-p4-push-git.sh#L82). 
3. Run the [pull-p4-push-git.sh](https://github.com/larsxschneider/git-p4-bridge/blob/master/pull-p4-push-git.sh) script:
```
./pull-p4-push-git.sh //P4/Project@all tcp:P4Server:1672 P4User P4Pass git@GitServer:Project.git GitBranch /path/to/git-ssh.key /path/to/ignore.pattern
```

If this works as expected you can [add](https://github.com/larsxschneider/git-p4-bridge/blob/master/daemon-bridge.sh#L16)
the call to script similar to [daemon-bridge.sh](https://github.com/larsxschneider/git-p4-bridge/blob/master/daemon-bridge.sh)
in order to run in periodically. I usually run this script in a [tmux](http://robots.thoughtbot.com/a-tmux-crash-course)
session on a server.

## License / 3rd Party Components

git-p4-bridge is available under the BSD license. See the LICENSE file for more info.  
[git](https://github.com/git/git)  
[p4](http://www.perforce.com/downloads/Perforce/Customer)  

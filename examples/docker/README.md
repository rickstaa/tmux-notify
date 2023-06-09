# Docker example

This example shows how to make tmux-notify work inside a docker container. You can test it out by executing the following inside your terminal:

```bash
bash docker_test.sh
```

This command will open a Tmux session inside a docker container, and if you have installed [tmp](https://github.com/tmux-plugins/tpm) and [tmux-notify](https://github.com/rickstaa/tmux-notify), on your host machine you should be able to use [tmux-notify](https://github.com/rickstaa/tmux-notify) as usual. For more information on how this works, see [this guide](https://github.com/mviereck/x11docker/wiki/How-to-connect-container-to-DBus-from-host#dbus-user-session-daemon).

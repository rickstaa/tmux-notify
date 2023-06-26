# Command line example with all parameters needed to run tmux-notify inside a docker container.
docker build -t tmux-notify-docker-test:latest .
docker run -e DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus \
-v /run/user/1000/bus:/run/user/1000/bus \
-v /etc/group:/etc/group:ro \
-v /etc/passwd:/etc/passwd:ro \
-v $HOME/.tmux:$HOME/.tmux \
-v $HOME/.tmux.conf:$HOME/.tmux.conf \
-v $HOME/.tmux.conf.local:$HOME/.tmux.conf.local \
--security-opt apparmor=unconfined \
-u $(id -u):$(id -g) \
-it tmux-notify-docker-test:latest tmux

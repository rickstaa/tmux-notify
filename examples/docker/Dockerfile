# A small Dockerfile to build a container in which tmux-notify can be tested.
FROM ubuntu:latest

# Install required packages.
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y \
    libnotify-bin \
    dbus \
    tmux \
    git

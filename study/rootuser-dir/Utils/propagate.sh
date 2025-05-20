#!/bin/bash

# Sync settings from current dir to skel and users

if [ ! -d ./.config ] ; then
    echo "Must start from root's home."
    exit 1
fi

restglob=$(shopt -p dotglob)
shopt -s dotglob

syncone() {
    echo "Syncing: '$1'"
    sudo rsync -avu  \
            --exclude=.cache \
            --exclude=.local \
            --exclude=.ICE* \
            --exclude=.X* \
            --exclude=.config.org \
            --exclude=.lesshst \
            --exclude=.gnupg \
            --exclude=.dbus \
                * $1

    sudo chown -R $2 $1/*
}

syncone /etc/skel   root.root
syncone /home/user  user.users
syncone /home/guest guest.users

$restglob

# EOF

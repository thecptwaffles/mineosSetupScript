#!/bin/sh

# download the necessary prerequisite components for mineos
pacman -S --noconfirm screen wget git rsync rdiff-backup python2-pip jre7-openjdk
pip2 install cherrypy==3.2.3

# download the most recent mineos web-ui files from github
mkdir -p /usr/games
cd /usr/games
git clone git://github.com/hexparrot/mineos minecraft
cd minecraft
git config core.filemode false
chmod +x server.py mineos_console.py generate-sslcert.sh
ln -s /usr/games/minecraft/mineos_console.py /usr/local/bin/mineos

# distribute service related files
cd /usr/games/minecraft
cp init/mineos.arch /etc/systemd/system/mineos.service
cp init/minecraft.arch /etc/systemd/system/minecraft.service
systemctl enable mineos.service
systemctl enable minecraft.service
cp mineos.conf /etc/

# generate self-signed certificate
./generate-sslcert.sh

# start the background service
systemctl start mineos.service

#!/bin/sh -e

#This script will compile and install a HBlink and HBmonitor


# Globals
DMR_UTILS="https://github.com/n0mjs710/dmr_utils3.git"
HBLINK="https://github.com/n0mjs710/HBlink3.git"
HBMONITOR="https://github.com/n0mjs710/HBmonitor.git"
PIP="https://bootstrap.pypa.io/get-pip.py"
WORK_DIR="/srv"
DMRUTL_DIR="$WORK_DIR/dmr_utils3"
HBLINK_DIR="$WORK_DIR/HBlink3"
HBMON_DIR="$WORK_DIR/HBmonitor"
HBMON_LOG="/var/log/link"

####  Routines  ################################################

Wget() { wget -cN "$@"; }
Git() { git clone "$@" -b master; }
Pip2() { pip2 install -r "$@"; }
Pip3() { pip3 install -r "$@"; }
PKGS="autoconf automake libtool patch make cmake bzip2 unzip wget git mercurial"

installLibs() {
    sudo apt-get update
    sudo apt-get -y --force-yes install $PKGS \
      build-essential pkg-config python2.7 python3 python-pip python3-pip python-twisted python3-twisted.
    python -m easy_install --upgrade pyOpenSSL
}

installpip() {
     Wget "$PIP"
     python2.7 get-pip.py
     python3 get-pip.py
}

installHBlink() {
     echo "Installing HBlink"
     cd "$WORK_DIR/"
     test -d HBlink3 || Git "$HBLINK"
     cd $HBLINK_DIR
     git pull
     Pip3 $HBLINK_DIR/requirements.txt
}

installHBlinkService() {    
}

installHBmonitor() {
     echo "Installing HBmonitor"
     cd "$WORK_DIR/"
     test -d HBmonitor || Git "$HBMONITOR"
     cd $HBMON_DIR
     git pull
     Pip2 $HBMON_DIR/requirements.txt
     mkdir -p $HBMON_LOG
}

installHBmonitorService() {
}

installLibs
installpip
installHBlink
installHBlinkService
installHBmonitor
installHBmonitorService

echo "Complete!"

## END ##

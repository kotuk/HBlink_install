#!/bin/sh -e

#This script will compile and install a HBlink and HBmonitor

# Globals
HBLINK="https://github.com/n0mjs710/HBlink3.git"
HBMONITOR="https://github.com/n0mjs710/HBmonitor.git"
PIP="https://bootstrap.pypa.io/get-pip.py"
WORK_DIR="/srv"
DMRUTL_DIR="$WORK_DIR/dmr_utils3"
HBLINK_DIR="$WORK_DIR/HBlink3"
HBMON_DIR="$WORK_DIR/HBmonitor"
HBMON_LOG="/var/log/link"
SYSCTL="/lib/systemd/system"
SYSCTL_HBL="hblink.service"
START_HBM="start_mon.sh"
SYSCTL_HBM="hbmonitor.service"

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
     cd $HBLINK_DIR
     echo "[Unit]" >> $SYSCTL_HBL
     echo "Description=Start HBlink" >> $SYSCTL_HBL
     echo >> $SYSCTL_HBL
     echo "[Service]" >> $SYSCTL_HBL
     echo "ExecStart=/usr/bin/python3 $HBLINK_DIR/bridge.py" >> $SYSCTL_HBL
     echo >> $SYSCTL_HBL
     echo "[Install]" >> $SYSCTL_HBL
     echo "WantedBy=multi-user.target" >> $SYSCTL_HBL
     mv $SYSCTL_HBL $SYSCTL/$SYSCTL_HBL
     systemctl daemon-reload
     systemctl enable $SYSCTL_HBL
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
     cd $HBMON_DIR
     echo "#!/bin/sh" >> $START_HBM
     echo >> $START_HBM
     echo "cd $HBMON_DIR" >> $START_HBM
     echo "/usr/bin/python ./web_tables.py" >> $START_HBM
     chmod +x $START_HBM
     echo "[Unit]" >> $SYSCTL_HBM
     echo "Description=Start HBmonitor" >> $SYSCTL_HBM
     echo >> $SYSCTL_HBM
     echo "[Service]" >> $SYSCTL_HBM
     echo "ExecStart=$HBMON_DIR/$START_HBM" >> $SYSCTL_HBM
     echo >> $SYSCTL_HBM
     echo "[Install]" >> $SYSCTL_HBM
     echo "WantedBy=multi-user.target" >> $SYSCTL_HBM
     mv $SYSCTL_HBM $SYSCTL/$SYSCTL_HBM
     systemctl daemon-reload
     systemctl enable $SYSCTL_HBM
}

installLibs
installpip
installHBlink
installHBlinkService
installHBmonitor
installHBmonitorService

echo "Complete!"
echo "Please before starting services don't forget to make and edit configuration files"
echo "To start HBlink enter : service hblink start or systemctl start hblink"
echo "To start HBmonitor enter : service hbmonitor start or systemctl start hbmonitor"

## END ##

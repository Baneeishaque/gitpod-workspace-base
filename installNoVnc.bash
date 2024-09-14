./updatePackageIndex.bash
sudo apt install -y tigervnc-standalone-server \
    tigervnc-xorg-extension \
    dbus \
    dbus-x11 \
    gnome-keyring \
    xfce4 \
    xfce4-terminal \
    xdg-utils \
    x11-xserver-utils \
    pip

sudo git clone --depth 1 https://github.com/novnc/noVNC.git /opt/novnc
sudo git clone --depth 1 https://github.com/novnc/websockify /opt/novnc/utils/websockify
sudo -H pip3 install numpy
sudo cp novnc-index.html /opt/novnc/index.html
sudo cp gp-vncsession /usr/bin/
sudo chmod 0755 "$(which gp-vncsession)"
cp .xinitrc $HOME/

cp tigerVncGeometry.txt $HOME
searchKey='test -e "$GITPOD_REPO_ROOT"' && TIGERVNC_GEOMETRY=$(cat $HOME/tigerVncGeometry.txt) && sed -i "s|$searchKey && gp-vncsession|export TIGERVNC_GEOMETRY=$TIGERVNC_GEOMETRY \&\& $searchKey \&\& gp-vncsession|" $HOME/.bashrc

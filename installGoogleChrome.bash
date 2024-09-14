cd /tmp
glink="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
wget "$glink"
./updatePackageIndex.bash
sudo apt install -y libasound2-dev \
    libgtk-3-dev \
    libnss3-dev \
	fonts-noto \
    fonts-noto-cjk \
    ./"${glink##*/}"	
ln -srf /usr/bin/google-chrome /usr/bin/chromium
# Extra chrome tweaks
## Disables welcome screen
t="$HOME/.config/google-chrome/First Run" && sudo -u gitpod mkdir -p "${t%/*}" && sudo -u gitpod touch "$t"
## Disables default browser prompt
t="/etc/opt/chrome/policies/managed/managed_policies.json" && mkdir -p "${t%/*}" && printf '{ "%s": %s }\n' DefaultBrowserSettingEnabled false > "$t"

echo "export QTWEBENGINE_DISABLE_SANDBOX=1" >>~/.bashrc

FROM gitpod/workspace-full-vnc

RUN sudo rm -rf /etc/localtime && sudo ln -s /usr/share/zoneinfo/Asia/Kolkata /etc/localtime

RUN intellijIdeaInstallationFile=ideaIU.tar.gz \
 && wget --output-document=$intellijIdeaInstallationFile "https://download.jetbrains.com/product?code=IIU&latest&distribution=linux" \
 && sudo tar -xvf $intellijIdeaInstallationFile -C /usr/local/ \
 && rm $intellijIdeaInstallationFile

ARG keyExplorerDownloadUrl="https://github.com/kaikramer/keystore-explorer/releases/download/v5.5.1/kse_5.5.1_all.deb"
ARG dBeaverDownloadPageUrl="https://dbeaver.com/files/ea/ultimate"
ARG gitKrakenDownloadUrl="https://release.gitkraken.com/linux/gitkraken-amd64.deb"
ARG peaZipDownloadUrl="https://downloads.sourceforge.net/project/peazip/8.9.0/peazip_8.9.0.LINUX.GTK2-1_amd64.deb"
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
 && sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
 && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
 && wget ${keyExplorerDownloadUrl} \
 && keyExplorerInstallationFile=$(basename ${keyExplorerDownloadUrl}) \
 && visualStudioCodeInstallationFile=visualStudioCode.deb \
 && wget --output-document=$visualStudioCodeInstallationFile "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" \
 && visualStudioCodeInsidersInstallationFile=visualStudioCodeInsiders.deb \
 && wget --output-document=$visualStudioCodeInsidersInstallationFile "https://code.visualstudio.com/sha/download?build=insider&os=linux-deb-x64" \
 && brew install pup \
 && dBeaverDownloadUrl=$(echo ${dBeaverDownloadPageUrl}/$(wget -O - ${dBeaverDownloadPageUrl} | pup 'table.s3_listing_files tbody tr td a attr{href}' | grep '.deb')) \
 && wget $dBeaverDownloadUrl \
 && dBeaverInstallationFile=$(basename $dBeaverDownloadUrl) \
 && wget ${gitKrakenDownloadUrl} \
 && gitKrakenInstallationFile=$(basename ${gitKrakenDownloadUrl}) \
 && wget ${peaZipDownloadUrl} \
 && peaZipInstallationFile=$(basename ${peaZipDownloadUrl}) \
 && sudo add-apt-repository -y ppa:persepolis/ppa \
 && wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add - \
 && sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main" \
 && sudo apt update \
 && sudo apt install -y \
     libxtst6 aria2 gh ./$keyExplorerInstallationFile tree ./$visualStudioCodeInstallationFile ./$visualStudioCodeInsidersInstallationFile rclone-browser ./$dBeaverInstallationFile firefox qbittorrent persepolis ./$gitKrakenInstallationFile ./$peaZipInstallationFile p7zip-full software-properties-common apt-transport-https wget microsoft-edge-dev squid \
 && sudo rm -rf /var/lib/apt/lists/* \
 && rm $keyExplorerInstallationFile \
 && rm $visualStudioCodeInstallationFile \
 && rm $visualStudioCodeInsidersInstallationFile \
 && rm $dBeaverInstallationFile \
 && rm $gitKrakenInstallationFile \
 && rm $peaZipInstallationFile \
 && phpMyAdminDownloadUrl=$(wget -O - https://www.phpmyadmin.net/downloads | pup 'a.download_popup attr{href}' | grep --max-count=1 'english.zip') \
 && wget $phpMyAdminDownloadUrl \
 && phpMyAdminArchieveFile=$(basename $phpMyAdminDownloadUrl) \
 && sudo unzip $phpMyAdminArchieveFile -d /opt/ \
 && rm $phpMyAdminArchieveFile \
 && phpMyAdminFolder=$(echo $phpMyAdminArchieveFile | sed 's/\(.*\)\..*/\1/') \
 && sudo cp /opt/$phpMyAdminFolder/config.sample.inc.php /opt/$phpMyAdminFolder/config.inc.php \
 && printf "\n\$cfg['AllowArbitraryServer'] = true;" | sudo tee -a /opt/$phpMyAdminFolder/config.inc.php >/dev/null

ARG chromeDriverDownloadUrl=https://chromedriver.storage.googleapis.com/105.0.5195.52/chromedriver_linux64.zip
RUN wget ${chromeDriverDownloadUrl} \
 && chromeDriverArchieve=$(basename ${chromeDriverDownloadUrl}) \
 && unzip $chromeDriverArchieve \
 && rm $chromeDriverArchieve \
 && chromeDriverExecutable=chromedriver \
 && sudo mv $chromeDriverExecutable /usr/bin/ \
 && sudo chmod a+x /usr/bin/$chromeDriverExecutable

RUN curl https://rclone.org/install.sh | sudo bash -s beta

ARG androidCommandLineToolsLinuxDownloadUrl="https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip"
RUN cd $HOME \
 && wget ${androidCommandLineToolsLinuxDownloadUrl} \
 && androidCommandLineToolsArchieve=$(basename ${androidCommandLineToolsLinuxDownloadUrl}) \
 && unzip $androidCommandLineToolsArchieve \
 && mkdir -p Android/Sdk/cmdline-tools/latest \
 && mv cmdline-tools/* Android/Sdk/cmdline-tools/latest/ \
 && rmdir cmdline-tools/ \
 && rm $androidCommandLineToolsArchieve

ENV JAVA_HOME="$HOME/.sdkman/candidates/java/current"

# ARG androidPlatformVersion="android-33"
# ARG androidBuildToolsVersion="33.0.0"
# ARG androidSourcesPlatformVersion="android-33-ext3"
# ARG cmakeVersion="3.22.1"
# ARG ndkVersion="25.1.8937393"
# RUN yes | Android/Sdk/cmdline-tools/latest/bin/sdkmanager --licenses \
#  && Android/Sdk/cmdline-tools/latest/bin/sdkmanager "platforms;${androidPlatformVersion}" "build-tools;${androidBuildToolsVersion}" "sources;${androidPlatformVersion}" "cmake;${cmakeVersion}" "ndk;${ndkVersion}"

ENV ANDROID_SDK_ROOT="$HOME/Android/Sdk"

ENV PATH=$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:$PATH

# ARG eclipseDownloadUrl="https://ftp.yz.yamagata-u.ac.jp/pub/eclipse/technology/epp/downloads/release/2022-09/R/eclipse-java-2022-09-R-linux-gtk-x86_64.tar.gz"
# RUN wget ${eclipseDownloadUrl} \
#  && eclipseInstallationFile=$(basename ${eclipseDownloadUrl}) \
#  && sudo tar -xvf $eclipseInstallationFile --directory=/usr/local/  --no-same-owner \
#  && rm $eclipseInstallationFile

ENV KONAN_DATA_DIR=/workspace/.konan/

ARG androidStudioCanaryDownloadUrl="https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2022.2.1.6/android-studio-2022.2.1.6-linux.tar.gz"
RUN cd $HOME \
 && wget ${androidStudioCanaryDownloadUrl} \
 && androidStudioCanaryInstallationFile=$(basename ${androidStudioCanaryDownloadUrl}) \
 && sudo tar -xvf $androidStudioCanaryInstallationFile -C /usr/local/ \
 && sudo mv /usr/local/android-studio/ /usr/local/android-studio-canary/ \
 && rm $androidStudioCanaryInstallationFile

# ARG androidStudioBetaDownloadUrl="https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2021.3.1.15/android-studio-2021.3.1.15-linux.tar.gz"
# RUN cd $HOME \
#  && wget ${androidStudioBetaDownloadUrl} \
#  && androidStudioBetaInstallationFile=$(basename ${androidStudioBetaDownloadUrl}) \
#  && sudo tar -xvf $androidStudioBetaInstallationFile -C /usr/local/ \
#  && sudo mv /usr/local/android-studio/ /usr/local/android-studio-beta/ \
#  && rm $androidStudioBetaInstallationFile

RUN pip install --upgrade pip && pip install getgist

RUN curl -sSL https://install.python-poetry.org | python3 - --git https://github.com/python-poetry/poetry.git@master
# RUN curl -sSL https://install.python-poetry.org | python3 - --git https://github.com/python-poetry/poetry.git@master \
#  && poetry completions bash >> ~/.bash_completion

# RUN brew install thefuck \
#  && echo 'eval "$(thefuck --alias)"' >> ~/.bashrc

# RUN brew install gradle-completion \
#  && echo '[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"' >> ~/.bash_profile

ARG pyCharmDownloadUrl="https://download.jetbrains.com/python/pycharm-professional-223.6160.21.tar.gz"
RUN wget ${pyCharmDownloadUrl} \
 && pyCharmInstallationFile=$(basename ${pyCharmDownloadUrl}) \
 && sudo tar -xvf $pyCharmInstallationFile -C /usr/local/ \
 && rm $pyCharmInstallationFile

RUN cd $HOME \
 && wget https://github.com/java-decompiler/jd-gui/releases/download/v1.6.6/jd-gui-1.6.6.jar

ARG apktoolDownloadUrl="https://github.com/iBotPeaches/Apktool/releases/download/v2.6.1/apktool_2.6.1.jar"
RUN cd $HOME \
 && mkdir apktool \
 && cd apktool \
 && wget https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/linux/apktool ${apktoolDownloadUrl} \
 && apktoolJarFile=$(basename ${apktoolDownloadUrl}) \
 && mv $apktoolJarFile apktool.jar \
 && chmod +x apktool apktool.jar

ENV PATH=$HOME/apktool:$PATH

ARG jadxDownloadUrl="https://github.com/skylot/jadx/releases/download/v1.4.5/jadx-1.4.5.zip"
RUN cd $HOME \
 && wget ${jadxDownloadUrl} \
 && jadxArchieveFile=$(basename ${jadxDownloadUrl}) \
 && jadxFolder=$(echo $jadxArchieveFile | sed 's/\(.*\)\..*/\1/') \
 && unzip $jadxArchieveFile -d $jadxFolder \
 && rm $jadxArchieveFile \
 && sed -i 's/DEFAULT_JVM_OPTS=""/DEFAULT_JVM_OPTS='"'"'"-Dsun.java2d.xrender=false"'"'"'/g' $HOME/$jadxFolder/bin/jadx-gui \
 && echo $jadxFolder > $HOME/jadxFolder

ARG dexToolsDownloadUrl="https://github.com/pxb1988/dex2jar/releases/download/v2.2-SNAPSHOT-2021-10-31/dex-tools-2.2-SNAPSHOT-2021-10-31.zip"
RUN cd $HOME \
 && wget ${dexToolsDownloadUrl} \
 && dexToolsArchieveFile=$(basename ${dexToolsDownloadUrl}) \
 && unzip $dexToolsArchieveFile \
 && rm $dexToolsArchieveFile \
 && echo $dexToolsArchieveFile | sed 's/\(.*\)\..*/\1/' | cut -d '-' -f1,2,3,4 > $HOME/dexToolsFolder

RUN cd $HOME \
 && wget "https://gist.githubusercontent.com/SergLam/3adb64051a1c8ebd8330191aedcefe47/raw/7936d8acde59cc31f487bc455904e3942d7ecbda/xcode-downloader.rb" \
 && chmod a+x xcode-downloader.rb \
 && sudo mv xcode-downloader.rb /usr/local/bin/

RUN sudo systemctl enable squid \
 && sudo sed -i 's/http_access deny all/http_access allow all/g' /etc/squid/squid.conf \
 && sudo service squid restart

RUN brew tap leoafarias/fvm \
 && brew install fvm

ENV PATH=$HOME/fvm/default/bin:$PATH

COPY tigerVncGeometry.txt $HOME
RUN searchKey='test -e "$GITPOD_REPO_ROOT"' && TIGERVNC_GEOMETRY=$(cat $HOME/tigerVncGeometry.txt) && sed -i "s|$searchKey && gp-vncsession|export TIGERVNC_GEOMETRY=$TIGERVNC_GEOMETRY \&\& $searchKey \&\& gp-vncsession|" $HOME/.bashrc

RUN bash -c ". /home/gitpod/.sdkman/bin/sdkman-init.sh && sdk update"
FROM gitpod/workspace-full-vnc

ENV TIGERVNC_GEOMETRY=1846x968

RUN sudo rm -rf /etc/localtime && sudo ln -s /usr/share/zoneinfo/Asia/Kolkata /etc/localtime

ARG phpMyAdminDownloadUrl=https://files.phpmyadmin.net/phpMyAdmin/5.2.0/phpMyAdmin-5.2.0-all-languages.zip
RUN wget ${phpMyAdminDownloadUrl} \
 && phpMyAdminArchieveFile=$(basename ${phpMyAdminDownloadUrl}) \
 && sudo unzip $phpMyAdminArchieveFile -d /opt/ \
 && rm $phpMyAdminArchieveFile \
 && phpMyAdminFolder=$(echo $phpMyAdminArchieveFile | sed 's/\(.*\)\..*/\1/') \
 && sudo cp /opt/$phpMyAdminFolder/config.sample.inc.php /opt/$phpMyAdminFolder/config.inc.php \
 && printf "\n\$cfg['AllowArbitraryServer'] = true;" | sudo tee -a /opt/$phpMyAdminFolder/config.inc.php >/dev/null
 
ARG intellijIdeaDownloadUrl="https://download.jetbrains.com/idea/ideaIU-2022.2.1.tar.gz"
RUN wget ${intellijIdeaDownloadUrl} \
 && intellijIdeaInstallationFile=$(basename ${intellijIdeaDownloadUrl}) \
 && sudo tar -xvf $intellijIdeaInstallationFile -C /usr/local/ \
 && rm $intellijIdeaInstallationFile
RUN sudo apt update \
 && sudo apt install -y \
     libxtst6 \
 && sudo rm -rf /var/lib/apt/lists/*

ARG chromeDriverDownloadUrl=https://chromedriver.storage.googleapis.com/105.0.5195.52/chromedriver_linux64.zip
RUN wget ${chromeDriverDownloadUrl} \
 && chromeDriverArchieve=$(basename ${chromeDriverDownloadUrl}) \
 && unzip $chromeDriverArchieve \
 && rm $chromeDriverArchieve \
 && chromeDriverExecutable=chromedriver \
 && sudo mv $chromeDriverExecutable /usr/bin/ \
 && sudo chmod a+x /usr/bin/$chromeDriverExecutable

RUN curl https://rclone.org/install.sh | sudo bash -s beta

RUN sudo apt update \
 && sudo apt install -y \
     aria2 \
 && sudo rm -rf /var/lib/apt/lists/*

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

ARG androidPlatformVersion="android-33"
ARG androidBuildToolsVersion="33.0.0"
ARG androidSourcesPlatformVersion="android-33-ext3"
ARG cmakeVersion="3.22.1"
ARG ndkVersion="25.1.8937393"
RUN yes | Android/Sdk/cmdline-tools/latest/bin/sdkmanager --licenses \
 && Android/Sdk/cmdline-tools/latest/bin/sdkmanager "platforms;${androidPlatformVersion}" "build-tools;${androidBuildToolsVersion}" "sources;${androidPlatformVersion}" "cmake;${cmakeVersion}" "ndk;${ndkVersion}"

ENV ANDROID_SDK_ROOT="$HOME/Android/Sdk"

ENV PATH=$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:$PATH

RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
 && sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
 && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
 && sudo apt update \
 && sudo apt install -y \
     gh \
 && sudo rm -rf /var/lib/apt/lists/*

ARG eclipseDownloadUrl="https://ftp.yz.yamagata-u.ac.jp/pub/eclipse//technology/epp/downloads/release/2022-09/RC1/eclipse-java-2022-09-RC1-linux-gtk-x86_64.tar.gz"
RUN wget ${eclipseDownloadUrl} \
 && eclipseInstallationFile=$(basename ${eclipseDownloadUrl}) \
 && sudo tar -xvf $eclipseInstallationFile --directory=/usr/local/  --no-same-owner \
 && rm $eclipseInstallationFile

ARG keyExplorerDownloadUrl="https://github.com/kaikramer/keystore-explorer/releases/download/v5.5.1/kse_5.5.1_all.deb"
RUN wget ${keyExplorerDownloadUrl} \
 && keyExplorerInstallationFile=$(basename ${keyExplorerDownloadUrl}) \
 && sudo apt update \
 && sudo apt install -y \
     ./$keyExplorerInstallationFile \
 && sudo rm -rf /var/lib/apt/lists/* \
 && rm $keyExplorerInstallationFile

ENV KONAN_DATA_DIR=/workspace/.konan/

ARG androidStudioCanaryDownloadUrl="https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2022.1.1.10/android-studio-2022.1.1.10-linux.tar.gz"
RUN cd $HOME \
 && wget ${androidStudioCanaryDownloadUrl} \
 && androidStudioCanaryInstallationFile=$(basename ${androidStudioCanaryDownloadUrl}) \
 && sudo tar -xvf $androidStudioCanaryInstallationFile -C /usr/local/ \
 && sudo mv /usr/local/android-studio/ /usr/local/android-studio-canary/ \
 && rm $androidStudioCanaryInstallationFile
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

ARG keyExplorerDownloadUrl="https://github.com/kaikramer/keystore-explorer/releases/download/v5.5.1/kse_5.5.1_all.deb"
ARG intellijIdeaDownloadUrl="https://download.jetbrains.com/idea/ideaIU-2022.2.2.tar.gz"
ARG visualStudioCodeDownloadUrl="https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
ARG visualStudioCodeInsidersDownloadUrl="https://code.visualstudio.com/sha/download?build=insider&os=linux-deb-x64"
ARG dBeaverDownloadUrl="https://dbeaver.com/files/ea/ultimate/dbeaver-ue_22.2.2_amd64.deb"
RUN wget ${intellijIdeaDownloadUrl} \
 && intellijIdeaInstallationFile=$(basename ${intellijIdeaDownloadUrl}) \
 && sudo tar -xvf $intellijIdeaInstallationFile -C /usr/local/ \
 && rm $intellijIdeaInstallationFile
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
 && sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
 && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
 && wget ${keyExplorerDownloadUrl} \
 && keyExplorerInstallationFile=$(basename ${keyExplorerDownloadUrl}) \
 && visualStudioCodeInstallationFile=visualStudioCode.deb \
 && visualStudioCodeInsidersInstallationFile=visualStudioCodeInsiders.deb \
 && wget --output-document=$visualStudioCodeInstallationFile ${visualStudioCodeDownloadUrl} \
 && wget --output-document=$visualStudioCodeInsidersInstallationFile ${visualStudioCodeInsidersDownloadUrl} \
 && wget ${dBeaverDownloadUrl} \
 && dBeaverInstallationFile=$(basename ${dBeaverDownloadUrl}) \
 && sudo apt update \
 && sudo apt install -y \
     libxtst6 aria2 gh ./$keyExplorerInstallationFile tree ./$visualStudioCodeInstallationFile ./$visualStudioCodeInsidersInstallationFile rclone-browser ./$dBeaverInstallationFile firefox \
 && sudo rm -rf /var/lib/apt/lists/* \
 && rm $keyExplorerInstallationFile \
 && rm $visualStudioCodeInstallationFile \
 && rm $visualStudioCodeInsidersInstallationFile \
 && rm $dBeaverInstallationFile

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

ARG androidPlatformVersion="android-33"
ARG androidBuildToolsVersion="33.0.0"
ARG androidSourcesPlatformVersion="android-33-ext3"
ARG cmakeVersion="3.22.1"
ARG ndkVersion="25.1.8937393"
RUN yes | Android/Sdk/cmdline-tools/latest/bin/sdkmanager --licenses \
 && Android/Sdk/cmdline-tools/latest/bin/sdkmanager "platforms;${androidPlatformVersion}" "build-tools;${androidBuildToolsVersion}" "sources;${androidPlatformVersion}" "cmake;${cmakeVersion}" "ndk;${ndkVersion}"

ENV ANDROID_SDK_ROOT="$HOME/Android/Sdk"

ENV PATH=$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:$PATH

ARG eclipseDownloadUrl="https://ftp.yz.yamagata-u.ac.jp/pub/eclipse/technology/epp/downloads/release/2022-09/R/eclipse-java-2022-09-R-linux-gtk-x86_64.tar.gz"
RUN wget ${eclipseDownloadUrl} \
 && eclipseInstallationFile=$(basename ${eclipseDownloadUrl}) \
 && sudo tar -xvf $eclipseInstallationFile --directory=/usr/local/  --no-same-owner \
 && rm $eclipseInstallationFile

ENV KONAN_DATA_DIR=/workspace/.konan/

ARG androidStudioCanaryDownloadUrl="https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2022.1.1.10/android-studio-2022.1.1.10-linux.tar.gz"
RUN cd $HOME \
 && wget ${androidStudioCanaryDownloadUrl} \
 && androidStudioCanaryInstallationFile=$(basename ${androidStudioCanaryDownloadUrl}) \
 && sudo tar -xvf $androidStudioCanaryInstallationFile -C /usr/local/ \
 && sudo mv /usr/local/android-studio/ /usr/local/android-studio-canary/ \
 && rm $androidStudioCanaryInstallationFile

ARG androidStudioBetaDownloadUrl="https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2021.3.1.15/android-studio-2021.3.1.15-linux.tar.gz"
RUN cd $HOME \
 && wget ${androidStudioBetaDownloadUrl} \
 && androidStudioBetaInstallationFile=$(basename ${androidStudioBetaDownloadUrl}) \
 && sudo tar -xvf $androidStudioBetaInstallationFile -C /usr/local/ \
 && sudo mv /usr/local/android-studio/ /usr/local/android-studio-beta/ \
 && rm $androidStudioBetaInstallationFile

RUN pip install getgist

RUN curl -sSL https://install.python-poetry.org | python3 - --git https://github.com/python-poetry/poetry.git@master
# RUN curl -sSL https://install.python-poetry.org | python3 - --git https://github.com/python-poetry/poetry.git@master \
#  && poetry completions bash >> ~/.bash_completion

# RUN brew install thefuck \
#  && echo 'eval "$(thefuck --alias)"' >> ~/.bashrc

# RUN brew install gradle-completion \
#  && echo '[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"' >> ~/.bash_profile
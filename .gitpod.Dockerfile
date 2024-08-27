FROM gitpod/workspace-full-vnc

ENV BUILDKIT_PROGRESS=plain

RUN echo "demo content to trigger rebuild due to the change in Dockerfile"

RUN sudo rm -rf /etc/localtime && sudo ln -s /usr/share/zoneinfo/Asia/Kolkata /etc/localtime

ENV ANDROID_HOME="/workspace/Android/Sdk"
ENV PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH

ENV KONAN_DATA_DIR=/workspace/.konan/

# ARG pyCharmDownloadUrl="https://download.jetbrains.com/python/pycharm-professional-223.6160.21.tar.gz"
# RUN wget ${pyCharmDownloadUrl} \
#  && pyCharmInstallationFile=$(basename ${pyCharmDownloadUrl}) \
#  && sudo tar -xvf $pyCharmInstallationFile -C /usr/local/ \
#  && rm $pyCharmInstallationFile

# RUN cd $HOME \
#  && wget https://github.com/java-decompiler/jd-gui/releases/download/v1.6.6/jd-gui-1.6.6.jar

# ARG apktoolDownloadUrl="https://github.com/iBotPeaches/Apktool/releases/download/v2.6.1/apktool_2.6.1.jar"
# RUN cd $HOME \
#  && mkdir apktool \
#  && cd apktool \
#  && wget https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/linux/apktool ${apktoolDownloadUrl} \
#  && apktoolJarFile=$(basename ${apktoolDownloadUrl}) \
#  && mv $apktoolJarFile apktool.jar \
#  && chmod +x apktool apktool.jar

# ENV PATH=$HOME/apktool:$PATH

# ARG jadxDownloadUrl="https://github.com/skylot/jadx/releases/download/v1.4.5/jadx-1.4.5.zip"
# RUN cd $HOME \
#  && wget ${jadxDownloadUrl} \
#  && jadxArchieveFile=$(basename ${jadxDownloadUrl}) \
#  && jadxFolder=$(echo $jadxArchieveFile | sed 's/\(.*\)\..*/\1/') \
#  && unzip $jadxArchieveFile -d $jadxFolder \
#  && rm $jadxArchieveFile \
#  && sed -i 's/DEFAULT_JVM_OPTS=""/DEFAULT_JVM_OPTS='"'"'"-Dsun.java2d.xrender=false"'"'"'/g' $HOME/$jadxFolder/bin/jadx-gui \
#  && echo $jadxFolder > $HOME/jadxFolder

# ARG dexToolsDownloadUrl="https://github.com/pxb1988/dex2jar/releases/download/v2.2-SNAPSHOT-2021-10-31/dex-tools-2.2-SNAPSHOT-2021-10-31.zip"
# RUN cd $HOME \
#  && wget ${dexToolsDownloadUrl} \
#  && dexToolsArchieveFile=$(basename ${dexToolsDownloadUrl}) \
#  && unzip $dexToolsArchieveFile \
#  && rm $dexToolsArchieveFile \
#  && echo $dexToolsArchieveFile | sed 's/\(.*\)\..*/\1/' | cut -d '-' -f1,2,3,4 > $HOME/dexToolsFolder

# RUN cd $HOME \
#  && wget "https://gist.githubusercontent.com/SergLam/3adb64051a1c8ebd8330191aedcefe47/raw/7936d8acde59cc31f487bc455904e3942d7ecbda/xcode-downloader.rb" \
#  && chmod a+x xcode-downloader.rb \
#  && sudo mv xcode-downloader.rb /usr/local/bin/

ENV FVM_CACHE_PATH=/workspace/fvm

RUN brew tap leoafarias/fvm \
 && brew install leoafarias/fvm/fvm glab \
#  && brew install dart-sdk \
#  && dart pub global activate very_good_cli \
#  && brew uninstall dart-sdk \
 && brew autoremove \
 && brew cleanup

ENV PATH=$FVM_CACHE_PATH/default/bin:$HOME/.pub-cache/bin:$PATH

COPY tigerVncGeometry.txt $HOME
RUN searchKey='test -e "$GITPOD_REPO_ROOT"' && TIGERVNC_GEOMETRY=$(cat $HOME/tigerVncGeometry.txt) && sed -i "s|$searchKey && gp-vncsession|export TIGERVNC_GEOMETRY=$TIGERVNC_GEOMETRY \&\& $searchKey \&\& gp-vncsession|" $HOME/.bashrc

RUN bash -c ". /home/gitpod/.sdkman/bin/sdkman-init.sh && sdk update && sdk upgrade"

ENV PATH=$PATH:/usr/lib/postgresql/16/bin
ENV PGDATA=/home/gitpod/.pg_ctl/data
ENV PATH=$PATH:$HOME/.pg_ctl/bin
ENV DATABASE_URL="postgresql://gitpod@localhost"

ENV PATH=$PATH:$HOME/.dotnet/tools
RUN git config --global lfs.activitytimeout 1000 \
 && git config --global credential.credentialStore cache \
 && git config --global credential.cacheOptions "--timeout 1576800000" \
 && git config --global http.postBuffer 1048576000 \
 && git config --global https.postBuffer 1048576000

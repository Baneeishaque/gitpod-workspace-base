FROM gitpod/workspace-full-vnc

ENV BUILDKIT_PROGRESS=plain

RUN echo "demo content to trigger rebuild due to the change in Dockerfile"

RUN sudo rm -rf /etc/localtime && sudo ln -s /usr/share/zoneinfo/Asia/Kolkata /etc/localtime

ENV ANDROID_HOME="/workspace/Android/Sdk"
ENV PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH

ENV KONAN_DATA_DIR=/workspace/.konan/

# ENV PATH=$HOME/apktool:$PATH

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

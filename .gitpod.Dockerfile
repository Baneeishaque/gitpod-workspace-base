FROM gitpod/workspace-base:2025-07-31-18-26-59

ENV BUILDKIT_PROGRESS=plain

RUN echo "demo content to trigger rebuild due to the change in Dockerfile"

USER root
RUN rm -f /etc/localtime && ln -s /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
USER gitpod

ENV ANDROID_HOME="/workspace/Android/Sdk"
ENV PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH

ENV KONAN_DATA_DIR=/workspace/.konan/

ENV PATH=$HOME/apktool:$PATH

ENV FVM_CACHE_PATH=/workspace/fvm
ENV PATH=$FVM_CACHE_PATH/default/bin:$HOME/.pub-cache/bin:$PATH

ENV PATH=$PATH:/usr/lib/postgresql/16/bin
ENV PGDATA=/home/gitpod/.pg_ctl/data
ENV PATH=$PATH:$HOME/.pg_ctl/bin
ENV DATABASE_URL="postgresql://gitpod@localhost"

ENV PATH=$PATH:$HOME/.dotnet/tools

ENV PATH=/home/linuxbrew/.linuxbrew/bin:$PATH

USER root
RUN printf 'Dir::Cache::Archives "/workspace/apt-cache";\nBinary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/99persistent-cache
USER gitpod

ENV HOMEBREW_INSTALL_FROM_API=1
ENV HOMEBREW_CACHE="/workspace/homebrew-cache"

ENV MISE_CACHE_DIR="/workspace/mise-cache"
ENV MISE_DATA_DIR="/workspace/mise-data"

ENV GRADLE_USER_HOME="/workspace/.gradle"

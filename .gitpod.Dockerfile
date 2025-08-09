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
ENV PATH=$FVM_CACHE_PATH/default/bin:$PATH

ENV PATH=$PATH:/usr/lib/postgresql/16/bin
ENV PGDATA=/home/gitpod/.pg_ctl/data
ENV PATH=$PATH:$HOME/.pg_ctl/bin
ENV DATABASE_URL="postgresql://gitpod@localhost"

ENV PATH=/home/linuxbrew/.linuxbrew/bin:$PATH

USER root
RUN printf 'Dir::Cache::Archives "/workspace/apt-cache";\nBinary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/99persistent-cache
USER gitpod

ENV HOMEBREW_INSTALL_FROM_API=1
ENV HOMEBREW_CACHE="/workspace/homebrew-cache"

ENV MISE_CACHE_DIR="/workspace/mise-cache"
ENV MISE_DATA_DIR="/workspace/mise-data"

ENV GRADLE_USER_HOME="/workspace/.gradle"

ENV NPM_CONFIG_CACHE="/workspace/npm-cache"

ENV PIP_CACHE_DIR="/workspace/pip_cache"
ENV PYTHONPYCACHEPREFIX="/workspace/pycache"

ENV PUB_CACHE="/workspace/dart_pub_cache"
ENV PATH=$PUB_CACHE/bin:$PATH

ENV GOMODCACHE="/workspace/go_mod_cache"

ENV CCACHE_DIR="/workspace/ccache"

ENV R_LIBS="/workspace/r_libs"

ENV IVY_CACHE_DIR="/workspace/ant_ivy"

ENV CARGO_HOME="/workspace/rust_cargo"
ENV CARGO_TARGET_DIR="/workspace/rust_target"

ENV CABAL_DIR="/workspace/haskell_cabal"
ENV CABAL_STORE_DIR="/workspace/haskell_store"
ENV STACK_ROOT="/workspace/haskell_stack"

ENV OPAMROOT="/workspace/ocaml_opam"
ENV DUNE_CACHE_ROOT="/workspace/ocaml_dune"

ENV COMPOSER_CACHE_DIR="/workspace/php_composer"

ENV NUGET_PACKAGES="/workspace/nuget_packages"
ENV DOTNET_CLI_HOME="/workspace/dotnet"
ENV PATH=$PATH:$DOTNET_CLI_HOME/tools

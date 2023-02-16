FROM ubuntu:jammy
RUN apt-get -y update && apt-get -y upgrade && apt-get -y install make wget git patch bash vim mc screen automake autoconf libtool build-essential
RUN apt-get update && apt-get -y dist-upgrade && apt-get -y install \
      apt-utils \
      aptitude \
      binutils \
      build-essential \
      bzip2 \
      curl \
      devscripts \
      equivs \
      fakeroot \
      file \
      gawk \
      git \
      git \
      gnupg \
      jq \
      less \
      lib32atomic1 \
      lib32stdc++6 \
      lib32z1 \
      libasound2 \
      libc6-i386 \
      libdbus-glib-1-2 \
      libgtk-3-0 \
      libucl1 \
      make \
      mercurial \
      p7zip-full \
      patch \
      procps \
      python3 \
      python3-dev \
      python3-pip \
      python3-distutils-extra \
      python3-minimal \
      python3-psutil \
      python3-venv \
      rsync \
      screen \
      tar \
      unzip \
      uuid \
      vim-tiny \
      wget \
      x11-utils \
      xz-utils \
      zip \
      zstd 

RUN git clone --recursive https://gitlab.com/librewolf-community/browser/windows.git
WORKDIR windows/linux
RUN pwd && ls -l
RUN make setup-debian
RUN make fetch
RUN make bootstrap
RUN make veryclean

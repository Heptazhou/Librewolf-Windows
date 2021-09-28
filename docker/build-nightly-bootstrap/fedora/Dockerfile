FROM fedora
MAINTAINER Bert van der Weerd <bert@stanzabird.nl>
RUN dnf -y update
# locale stuff, see: https://superuser.com/questions/959380/how-do-i-install-generate-all-locales-on-fedora
RUN echo "%_install_langs C:en:en_US:en_US.UTF-8" > /etc/rpm/macros.image-language-conf
RUN dnf -y reinstall glibc-common
# Install build dependencies..
run dnf -y install wget python3 python3-devel mercurial
# Build mozilla nightly..
run wget -q https://hg.mozilla.org/mozilla-central/raw-file/default/python/mozboot/bin/bootstrap.py
run echo '***' python3 bootstrap.py --no-interactive --application-choice=browser




#
## packages required to build and run apiserver.
#RUN dnf -y install g++ gcc make automake autoconf libtool libcurl-devel
#COPY apiserver-0.1.1.tar.gz /
#WORKDIR /
#RUN tar xvf apiserver-0.1.1.tar.gz
#WORKDIR apiserver-0.1.1
#RUN zsh ./configure --prefix=/usr --disable-dependency-tracking
#RUN ["make", "install"]
#RUN ["make", "dist"]
#

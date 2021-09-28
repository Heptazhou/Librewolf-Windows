FROM debian
MAINTAINER Bert van der Weerd <bert@stanzabird.nl>
RUN dnf -y update
RUN dnf -y install bash
# locale stuff, see: https://superuser.com/questions/959380/how-do-i-install-generate-all-locales-on-fedora
RUN echo "%_install_langs C:en:en_US:en_US.UTF-8" > /etc/rpm/macros.image-language-conf
RUN dnf -y reinstall glibc-common
# packages required to build and run apiserver.
RUN dnf -y install g++ gcc make automake autoconf libtool libcurl-devel
COPY apiserver-0.1.1.tar.gz /
WORKDIR /
RUN tar xvf apiserver-0.1.1.tar.gz
WORKDIR apiserver-0.1.1
RUN zsh ./configure --prefix=/usr --disable-dependency-tracking
RUN ["make", "install"]
EXPOSE 8000
ENTRYPOINT ["/usr/bin/apiserver"]

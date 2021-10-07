FROM fedora:34
MAINTAINER Bert van der Weerd <bert@stanzabird.nl>
RUN dnf -y update

# locale stuff, see: https://superuser.com/questions/959380/how-do-i-install-generate-all-locales-on-fedora
RUN echo "%_install_langs C:en:en_US:en_US.UTF-8" > /etc/rpm/macros.image-language-conf
RUN dnf -y reinstall glibc-common

# Install build dependencies..
run dnf -y install wget python3 python3-pip python3-devel mercurial

# Fetch mozilla nightly..
run wget -q https://hg.mozilla.org/mozilla-central/raw-file/default/python/mozboot/bin/bootstrap.py
run python3 bootstrap.py --no-interactive --application-choice=browser
run rm bootstrap.py

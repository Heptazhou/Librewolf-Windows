FROM linuxmintd/mint20.2-amd64
MAINTAINER Bert van der Weerd <bert@stanzabird.nl>
RUN apt-get -y update && apt-get -y upgrade
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Amsterdam

# Install build dependencies..
run apt-get -y install wget python3 python3-pip python3-dev mercurial

# Fetch mozilla nightly..
run wget -q https://hg.mozilla.org/mozilla-central/raw-file/default/python/mozboot/bin/bootstrap.py
run python3 bootstrap.py --no-interactive --application-choice=browser
run rm -rf mozilla-unified bootstrap.py

# Build it..
copy version /

run wget -q https://archive.mozilla.org/pub/firefox/releases/$(cat /version)/source/firefox-$(cat /version).source.tar.xz
run tar xf firefox-$(cat /version).source.tar.xz
run ln -s firefox-$(cat /version) work

workdir work

run ./mach build
run ./mach package

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

# Build it..



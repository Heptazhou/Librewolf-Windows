FROM ubuntu:20.04
MAINTAINER Bert van der Weerd <bert@stanzabird.nl>
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Amsterdam
RUN apt-get -y update && apt-get -y upgrade

# Install build dependencies..
run apt-get -y install wget python3 python3-pip python3-dev mercurial

# Build mozilla nightly..
run wget -q https://hg.mozilla.org/mozilla-central/raw-file/default/python/mozboot/bin/bootstrap.py
run python3 bootstrap.py --no-interactive --application-choice=browser
run rm bootstrap.py

FROM ubuntu:jammy
#FROM fedora:36

RUN apt-get -y update && apt-get -y upgrade && apt-get -y install make wget git patch
#RUN dnf -y update && dnf -y install make wget git patch

WORKDIR /
RUN git clone https://gitlab.com/librewolf-community/browser/windows.git
WORKDIR /windows/linux

RUN make setup-debian && make fetch && make bootstrap && make veryclean
#RUN make setup-fedora && make fetch && make bootstrap && make veryclean

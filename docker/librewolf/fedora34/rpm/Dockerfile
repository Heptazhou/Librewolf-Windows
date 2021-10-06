from librewolf/release-fedora34

run ./build.py --version $(cat /version) lw_artifacts
run mkdir /artifacts
run cp librewolf-$(cat /version).en-US.rpm.zip /artifacts

run sudo dnf -y install rpm-build

workdir /
copy build-rpm.sh .
copy librewolf.spec .
run ./build-rpm.sh

run rm -f /artifacts/build_tag && date > /artifacts/build_tag

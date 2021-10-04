from librewolf/release-debian11
run ./build.py --version $(cat /version) lw_artifacts
run mkdir /artifacts
run cp librewolf-$(cat /version).en-US.deb.zip /artifacts
workdir /
copy build-deb.sh /
run ./build-deb.sh
run rm -f artifacts/build_tag && date > artifacts/build_tag

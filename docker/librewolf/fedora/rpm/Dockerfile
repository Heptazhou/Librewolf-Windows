from librewolf/release-debian
run ./build.py --version $(cat /version) lw_artifacts
run mkdir /artifacts
run cp librewolf-$(cat /version).en-US.deb.zip /artifacts



# Sending termination shock signal.
run rm -f /artifacts/build_tag && date > /artifacts/build_tag

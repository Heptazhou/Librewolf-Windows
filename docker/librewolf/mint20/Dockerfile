from mozilla/buildenv-mint20
run rm -rf mozilla-unified

# Build it..
copy version /
run wget -q https://archive.mozilla.org/pub/firefox/releases/$(cat /version)/source/firefox-$(cat /version).source.tar.xz

# dependencies, tools, distro build tools,...
run apt-get install -y git
run ## [build trigger] (add or remove a few hashes in front to trigger build from here)
run git clone --recursive https://gitlab.com/librewolf-community/browser/windows.git
workdir windows
run tar xf /firefox-$(cat /version).source.tar.xz

run ./build.py --version $(cat /version) lw_do_patches
run ./build.py --version $(cat /version) build
run ./build.py --version $(cat /version) lw_post_build
run ./build.py --version $(cat /version) package

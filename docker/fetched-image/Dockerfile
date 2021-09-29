from mozilla/buildenv-debian
run rm -rf mozilla-unified

# Build it..
copy version /
run wget -q https://archive.mozilla.org/pub/firefox/releases/$(cat /version)/source/firefox-$(cat /version).source.tar.xz
run tar xf firefox-$(cat /version).source.tar.xz
run ln -s firefox-$(cat /version) work
workdir work

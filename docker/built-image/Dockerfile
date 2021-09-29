from librewolf/fetched-image
# dependencies
run apt-get install -y git

workdir /
run git clone --recursive https://gitlab.com/librewolf-community/browser/windows.git
workdir windows
run ln -s /firefox-$(cat /version)
run ls -l
run pwd
run ls -l /
run python3 build.py --version $(cat /version) fetch
run python3 build.py lw_do_patches
run python3 build.py build
run python3 build.py lw_post_build
run python3 build.py package

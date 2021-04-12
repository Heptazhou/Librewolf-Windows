#!/bin/bash

pkgver=87.0
private_token=$1
if [ -z $private_token ]; then
    echo "Please specify the Gitlab PRIVATE TOKEN on the commandline."
    exit 1
fi

echo ""
echo ""

curl --request POST --header "PRIVATE-TOKEN: ${private_token}" --form "file=@librewolf-${pkgver}.en-US.win64-setup.exe" "https://gitlab.com/api/v4/projects/13852981/uploads"
echo ""
echo ""

curl --request POST --header "PRIVATE-TOKEN: ${private_token}" --form "file=@librewolf-${pkgver}.en-US.win64.zip" "https://gitlab.com/api/v4/projects/13852981/uploads"
echo ""
echo ""

curl --request POST --header "PRIVATE-TOKEN: ${private_token}" --form "file=@librewolf-${pkgver}.en-US.win64-permissive-nightly-setup.exe" "https://gitlab.com/api/v4/projects/13852981/uploads"
echo ""
echo ""


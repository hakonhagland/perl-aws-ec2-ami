#! /bin/bash
 
curdir=$(dirname "$(readlink -f "$0")")
pack_fn="$curdir/../ubuntu_packages_to_install.txt"
echo
echo "Installing packages.."
echo "---------------------"
echo
while read line; do
    echo 
    echo "Installing \"$line\".."
    echo "--------------------------------------"
    sleep 0.3
    sudo apt-get install --yes $line
done <"$pack_fn"

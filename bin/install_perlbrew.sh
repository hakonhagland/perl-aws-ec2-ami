#! /bin/bash

curdir=$(dirname "$(readlink -f "$0")")
echo
echo "Installing perlbrew.."
echo "---------------------"
export PERLBREW_ROOT=~/perlbrew
curl -L https://install.perlbrew.pl | bash
source "$PERLBREW_ROOT/etc/bashrc"
version=perl-5.30.0
perlbrew install "$version"
perlbrew install-cpanm
perlbrew switch  "$version"
cp "$curdir/activate_perlbrew_bashrc.sh" ~/
echo '[[ -f ~/.perlbrew.sh ]] && source ~/.perlbrew.sh' >> ~/.bashrc

# Pyenv


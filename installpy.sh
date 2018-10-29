#!/bin/bash


# Installing of python 3.6, via a chroot
# Takes aprox 15 Min (download speed may vary)

cd ~
mkdir Temporary_Installing
cd Temporary_Installing

echo "Installing Python 3.6"


sudo apt-get -qq --yes install debootstrap schroot
sudo mkdir -p /srv/chroot/buster

echo "[buster]" > buster.conf
cat <<EOT >> buster.conf
type=directory
description=A buster environment
directory=/srv/chroot/buster
users=pi
root-users=root
preserve-environment=false
profile=default
EOT
sudo cp buster.conf /etc/schroot/chroot.d/
sudo rm buster.conf

sudo debootstrap --variant=buildd --arch=armel buster /srv/chroot/buster/ http://ftp.debian.org/debian/
sudo schroot -c buster -- apt -qq --yes install python3

xhost +

sudo cat <<"EOC" >> ~/.bashrc
### CHROOT CODE ###


if [ "$LANG" = en_CA.UTF-8 ]
then
        alias python3='schroot -c buster python3'
        alias buster="schroot -c buster"
        alias rbuster="sudo schroot -c buster"
else
        export LANG=en_CA.UTF-8
        export LC_ALL=C
        export DISPLAY=:0.0
        #echo ""
        #echo "~~~~~~~~Buster Environment Opened~~~~~~~~~"
        #echo "           Type exit to quit"
        #echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        #echo ""
fi

EOC

source ~/.bashrc


sudo cat <<"EOC" >> ~/testPy3.py
var = "World"
version = "3.6"
print(f"Hello {var} from {version}")
EOC




cd ~
sudo rm -r /home/pi/Temporary_Installing



echo ""
echo "DONE"
echo 'To Test to see if it worked, type in "source .bashrc" (or re-open the terminal window) followed by "python3 testPy3.py"'
echo "To see the contents of testPy3.py, open it in your prefered text editor."
echo ""

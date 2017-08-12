#!/bin/bash

#Author: Momodou Jaiteh

# this is to ensure that all dependencies will be installed.
grep 'deb http://ftp.de.debian.org/debian wheezy main' /etc/apt/sources.list > /tmp/test123 
if [ ! -s /tmp/test123 ]; then
  echo 'deb http://ftp.de.debian.org/debian wheezy main' >> /etc/apt/sources.list 
fi
apt update

apt-get install sudo 

rm -rf ./binwalk
git clone https://github.com/devttys0/binwalk.git
cd binwalk
sudo ./deps.sh
sudo python ./setup.py install
sudo apt-get install python-lzma
sudo -H pip install git+https://github.com/ahupp/python-magic
cd ..

sudo apt-get install busybox-static fakeroot git kpartx netcat-openbsd nmap python-psycopg2 python3-psycopg2 snmp uml-utilities util-linux vlan qemu-system-arm qemu-system-mips qemu-system-x86 qemu-utils -y

rm -rf ./firmadyne
rm -rf ./fat
git clone --recursive https://github.com/firmadyne/firmadyne.git
echo "Just changing name of firmadyne to fat"
mv ./firmadyne fat
cd ./fat; ./download.sh 

rm -rf ./firmware-analysis-toolkit
git clone https://github.com/momodou86/firmware-analysis-toolkit
mv firmware-analysis-toolkit/fat.py .
mv firmware-analysis-toolkit/reset.sh .
chmod +x fat.py 
chmod +x reset.sh
cd ..

sudo apt-get install postgresql
sudo systemctl start postgresql
sudo -u postgres psql -c "CREATE USER firmadyne WITH PASSWORD 'firmadyne';"
sudo -u postgres psql -c "DROP DATABASE IF EXISTS firmware;"
sudo -u postgres psql -c "CREATE DATABASE firmware OWNER firmadyne;"
sudo -u postgres psql -d firmware < ./fat/database/schema

sudo apt-get install git build-essential zlib1g-dev liblzma-dev python-magic -y

rm -rf ./firmware-mod-kit
rm -rf ./fmk 
#git clone https://github.com/mirror/firmware-mod-kit.git
git clone https://github.com/momodou86/firmware-mod-kit.git
mv firmware-mod-kit fmk

rm -rf firmwalker
git clone https://github.com/craigz28/firmwalker.git

sudo systemctl status postgresql

FAT=FIRMWARE_DIR=\'`pwd`/fat/\'
sed -i "4s,.*,$FAT," ./fat/firmadyne.config

FIRMPATH=firmadyne_path=\'`pwd`/fat\'
sed -i "9s,.*,$FIRMPATH," ./fat/fat.py

binwalk_path=binwalk_path=\'`which binwalk`\'
sed -i "10s,.*,$binwalk_path," ./fat/fat.py

BINWALK=BINWALK=\'`which binwalk`\'
sed -i "11s,.*,$BINWALK," ./fmk/shared-ng.inc

echo "done Yay!!! :)"
echo " "
ls

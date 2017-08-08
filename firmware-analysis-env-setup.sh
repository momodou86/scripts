#!/bin/bash

#Author: Momodou Jaiteh


apt-get install sudo dhclient
dhclient
sleep 5

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
sudo -u postgres psql -c "DROP DATABASE IF EXISTS firmware;"
sudo -u postgres psql -c "CREATE DATABASE firmware OWNER firmadyne;"
sudo -u postgres psql -c "CREATE USER firmadyne WITH PASSWORD 'firmadyne';"
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

echo " "
echo -e "\e[101mPLEASE READ AND MAKE THESE CHANGES BELOW\e[0m"
echo " "
echo -e "\e[31m(1)\e[0m"
echo "***********************************"
echo "Edit the firmadyne.config file in \"fat\" directory and change the value of" 
echo "FIRMWARE_DIR to be \"`pwd`/fat/\" and uncomment it - i.e remove the \# symbol "
echo " "
echo -e "\e[31m(2)\e[0m"
echo "************************************"
echo "Edit line number 9 in the fat.py file located in the fat folder to" 
echo "firmadyne_path =\"`pwd`/fat\""
echo " "
echo "***********************************"
echo -e "\e[31m(3)\e[0m"
echo "***********************************"
echo "The value of BINWALK in 'shared-ng.inc' located in \"fmk\" directory"
echo "is set to  \"/usr/local/bin/binwwalk\" if it is different from \"`which binwalk`\", go change it to the later"
echo "***********************************"

echo "done Yay!!! :)"
echo " "
ls

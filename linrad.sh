#!/bin/bash
echo "
Script to install linrad on a Raspberry Pi 3 or 4 running Raspbian Buster.
"
echo "
------------------------------
Installing dependencies
------------------------------
"

sudo apt update
sudo sudo apt install -y subversion libx11-dev libxext-dev libusb-1.0-0-dev libusb-dev cmake libportaudio-dev ||
{ echo ' Installing dependencies failed!'; exit 1; }

echo "
----------------------------------
Starting radio driver installation
----------------------------------
"
echo "
---------------------------
Installing Mirics drivers..
---------------------------
"
cd ~
git clone https://github.com/f4exb/libmirisdr-4.git
cd libmirisdr-4
mkdir build
cd build
cmake ..

echo "
-----------------
finished Mirics 
-----------------
"
read dummy 

echo " 
--------------------------------
Installing Airspy One drivers ..
--------------------------------
"
cd ~
# If exists remove old copy of master.zip
if [ -e master.zip ] ; then
	rm master.zip
fi

wget https://github.com/airspy/airspyone_host/archive/master.zip

unzip -o /home/pi/master.zip
sudo rm /home/pi/master.zip
cd airspyone_host-master

mkdir -p build
cd build
cmake ../ -DINSTALL_UDEV_RULES=ON
make
sudo make install
sudo ldconfig

echo " 
-------------------------------------
Now installing AirspyHF+ drivers ..."
-------------------------------------

cd ~

if [ -e master.zip ] ; then
	rm master.zip
fi
wget https://github.com/airspy/airspyhf/archive/master.zip
unzip -o /home/pi/master.zip
cd airspyhf-master
mkdir build
cd build
cmake ../ -DINSTALL_UDEV_RULES=ON
make
sudo make install
sudo ldconfig


echo "
----------------------------------
Now installing rtl-sdr drivers ...
-----------------------------------
"
# -------------------------------------------------------------------------------------------
cd ~

echo "Delete old rtl-sdr downloads"

sudo rm -rf /home/pi/rtl-sdr
echo "Downloading rtl-sdr code from osmocom ..."
git clone git://git.osmocom.org/rtl-sdr.git
echo "Installing rtl-sdr ....."
cd /home/pi/rtl-sdr
mkdir -p /home/pi/rtl-sdr/build
cd build
cmake ../ -DINSTALL_UDEV_RULES=ON
make
sudo make install
sudo ldconfig


echo "
--------------------------------------
Blacklisting TV drivers for RTL-SDR..
--------------------------------------
"
sudo bash -c 'cat <<EOT >> /etc/modprobe.d/blacklist-rtlsdr.conf
blacklist dvb_usb_rtl28xxu
blacklist rtl2832
blacklist rtl2830
EOT'

# Tidy-up installation
sudo rm -rf /home/pi/rtl-sdr
sudo rm /home/pi/master.zip
sudo rm -rf /home/pi/airspyhf-master
sudo rm -rf /home/pi/airspyone_host-master

echo "

-----------------
Radios installed!
-----------------
Press return to continue

echo "

read dummy
echo "
---------------------------------
Downloading the source code ...
---------------------------------
"
cd ~
svn checkout https://svn.code.sf.net/p/linrad/code/trunk linrad

echo "
---------------------
Configuring Linrad...
---------------------
"

cd linrad

sudo ./configure ||
{ echo ' Configuring linrad failed! Run ./configure manually from the /linrad directory'; exit 1;}

sudo make xlinrad ||
{ echo ' Making linrad failed! Run make xlinrad manually from the /linrad directory'; exit 1;}

echo "
------------
FINISHED!!!
------------

----------------------------
Hit return to end
----------------------------
"
read dummy



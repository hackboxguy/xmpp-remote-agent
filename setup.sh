#!/bin/sh
#./setup.sh -u myuser@jabber.de -p myjabberpw
USAGE="usage:$0 -u <xmpp-username> -p <xmpp-pw>"
XMPP_USR="none"
XMPP_PW="none"
while getopts u:p: f
do
	case $f in
	u) XMPP_USR=$OPTARG ;;
	p) XMPP_PW=$OPTARG ;;
	esac
done

if [ $XMPP_USR = "none" ]; then
	echo "xmpp-username arg is a must"
	echo $USAGE
	exit 1
fi
if [ $XMPP_PW = "none" ]; then
	echo "xmpp-pw arg is a must"
	echo $USAGE
	exit 1
fi
#if [ $(id -u) -ne 0 ]; then
#        echo "run setup as root ==> sudo ./setup.sh -u <xmpp-username> -p <xmpp-pw>"
#        exit
#fi

printf "Installing dependencies ................................ "
DEBIAN_FRONTEND=noninteractive sudo apt-get update --fix-missing < /dev/null > /dev/null
DEBIAN_FRONTEND=noninteractive sudo apt-get install -qq avahi-daemon avahi-discover libnss-mdns avahi-utils cmake git libjson-c-dev libgloox-dev openssl libmodbus-dev libgammu-dev usb-modeswitch < /dev/null > /dev/null
test 0 -eq $? && echo "[OK]" || echo "[FAIL]"

printf "Configuring xmpp-remote-agent components................ "
cmake -H. -BOutput -DCMAKE_INSTALL_PREFIX=~/xmpp-remote-agent/out -DINSTALL_CLIENT=ON -DAUTO_SVN_VERSION=OFF 1>/dev/null 2>/dev/null
test 0 -eq $? && echo "[OK]" || echo "[FAIL]"

printf "Building xmpp-remote-agent components................... "
cmake --build Output -- install -j$(nproc) 1>/dev/null 2>/dev/null
test 0 -eq $? && echo "[OK]" || echo "[FAIL]"

mkdir -p ~/xmpp-remote-agent/out/etc/xmproxy/
echo "user: $XMPP_USR" > ~/xmpp-remote-agent/out/etc/xmproxy/xmpp-login.txt;echo "pw: $XMPP_PW" >>~/xmpp-remote-agent/out/etc/xmproxy/xmpp-login.txt

#setup auto startup script
printf "Customizing rc.local ................................... "
sudo cp rc.local /etc/
test 0 -eq $? && echo "[OK]" || echo "[FAIL]"

echo   "Setup completed successfully! Reboot the HW ............ "

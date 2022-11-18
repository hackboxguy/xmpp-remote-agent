# xmpp-remote-agent
Installer scripts for deploying xmpp based remote agent client service on Linux machines(with provision to connect sim-card to xmpp instant messaging)

## Maintainer
	Albert David (albert.david@gmail.com)

## Installation steps raspbian based raspiberry-pi hw(replace xmpp user/pw with your custom one)
    sudo apt-get install -y git
    git clone --recursive https://github.com/hackboxguy/xmpp-remote-agent.git
    cd xmpp-remote-agent
    ./setup.sh -u raspi-sim-1@jabber.de -p my-raspi-xmpp-secret-pw
    suro reboot;exit

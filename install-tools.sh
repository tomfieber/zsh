#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

export PATH=$HOME/.local/bin:$HOME/go/bin:$HOME/.cargo/env:/usr/local/go/bin:/usr/sbin:$PATH

SYSARCH=$(uname -m)
echo -e "${GREEN}System Architecture:${NC} $SYSARCH"

# Get desktop environment
DESKTOP=$XDG_CURRENT_DESKTOP
echo "[+] $DESKTOP desktop environment detected"

# Do an update
sudo apt update && sudo apt full-upgrade

# Install some basic necessities 
echo "[+] Installing some basic necessities"
sudo apt install -y git libssl-dev libpcap-dev libffi-dev python3-netifaces python-dev-is-python3 build-essential libbz2-dev libreadline-dev libsqlite3-dev curl zlib1g-dev libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev direnv virtualenvwrapper python3-quamash python3-pyfiglet python3-pandas python3-shodan patchelf

# Autoremove
sudo apt autoremove
echo "=========="
echo


# Install Go tools
echo "[+] Install chaos"
go install -v github.com/projectdiscovery/chaos-client/cmd/chaos@latest
echo "[+] Installing subfinder"
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
echo "[+] Installing nuclei"
go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest
echo "[+] Installing naabu"
go install -v github.com/projectdiscovery/naabu/v2/cmd/naabu@latest
echo "[+] Installing httpx"
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
echo "[+] Installing katana"
go install github.com/projectdiscovery/katana/cmd/katana@latest
echo "[+] Installing dnsx"
go install -v github.com/projectdiscovery/dnsx/cmd/dnsx@latest
echo "[+] Installing tlsx"
go install github.com/projectdiscovery/tlsx/cmd/tlsx@latest
echo "[+] Installing uncover"
go install -v github.com/projectdiscovery/uncover/cmd/uncover@latest
echo "[+] Installing amass"
go install -v github.com/owasp-amass/amass/v4/...@master
echo "[+] Installing blacksheepwall"
go install github.com/tomsteele/blacksheepwall@latest
echo "[+] Installing ffuf"
go install github.com/ffuf/ffuf/v2@latest
echo "[+] Installing kerbrute"
go install github.com/ropnop/kerbrute@latest
echo "[+] Installing gowitness"
go install github.com/sensepost/gowitness@latest
echo "[+] Installing pretender"
go install -v github.com/RedTeamPentesting/pretender@latest
echo "=========="
echo

# Installing pipx tools
echo "${GREEN}[+] Installing some tools from pipx${NC}"
pipx install certipy-ad
pipx install bloodhound
pipx install git+https://github.com/blacklanternsecurity/MANSPIDER
pipx install tldr
echo "=========="
echo


# Install pyenv
echo "[+] Installing pyenv"
if [ ! -d $HOME/.pyenv ]; then
    curl https://pyenv.run | bash
fi

# Install rustup
echo "[+] Installing rustup"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh


echo -e "${green}Install complete.${NC}" 

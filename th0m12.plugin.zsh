autoload -Uz colors && colors

unction ligolo-setup() {
	interface="$(ip tuntap show | grep -v ligolo | cut -d : -f1 | head -n 1)"
	ip="$(ip a s "${interface}" 2>/dev/null \
        | grep -o -P '(?<=inet )[0-9]{1,3}(\.[0-9]{1,3}){3}')"
	echo "Name of the user to add (Enter for current user): "
	read NAME
	echo "Port to listen on (Enter for default port 11601): "
	read PORT
	FINAL_NAME=${NAME:-$USER}
	FINAL_PORT=${PORT:-11601}
	eval sudo ip tuntap add user $FINAL_NAME mode tun ligolo
	eval sudo ip link set ligolo up
	print -- $fg_bold[green]Use the following command to connect back to the server$reset_color
	echo
	echo "==Windows=="
	echo -e "Start-Process -FilePath C:\\Windows\\Tasks\\\\agent.exe -ArgumentList \"-connect\",\"$ip:$FINAL_PORT,\"-ignore-cert\""
	echo
	echo "==Linux=="
	echo "( nohup ./agent -connect $ip:$FINAL_PORT -ignore-cert & )"
	echo
	eval /opt/tools/ligolo-ng/proxy -laddr 0.0.0.0:$FINAL_PORT -selfcert

}

function add-ligolo-route() {
	echo "Enter the range to add: "
	read range
	eval sudo ip route add $range dev ligolo
}

function createdir() {
	echo "Enter a name for the directory: "
	read NAME
	DIRNAME=${NAME:-newdir}
	echo "Enter an IP if there is one (useful for HTB): "
	read IP
	FINAL_IP=${IP:-""}
	echo "Enter a HOST IP (e.g., a tun0 VPN IP): "
	read LHOST
	FINAL_LHOST=${LHOST:-""}
	mkdir $DIRNAME
	cd $DIRNAME
	mkdir -p {Admin,Deliverables,Evidence/{Findings,"Logging output","Misc files",Notes,OSINT,Scans/{"AD Enumeration",Service,Vuln,Web},Wireless},Retest}
	echo "# Administrative Information" > Evidence/Notes/"1. Administrative Information.md"
	echo "# Scoping Information" > Evidence/Notes/"2. Scoping Information.md"
	echo "# Activity Log" > Evidence/Notes/"3. Activity Log.md"
	echo "# Payload Log" > Evidence/Notes/"4. Payload Log.md"
	echo "# OSINT Data" > Evidence/Notes/"5. OSINT Data.md"
	echo "# Credentials" > Evidence/Notes/"6. Credentials.md"
	echo "# Web Application Research" > Evidence/Notes/"7. Web Application Research.md"
	echo "# Vulnerability Scan Research" > Evidence/Notes/"8. Vulnerability Scan Research.md"
	echo "# Service Enumeration Research" > Evidence/Notes/"9. Service Enumeration Research.md"
	echo "# AD Enumeration Research" > Evidence/Notes/"10. AD Enumeration Research.md"
	echo "# Attack Path" > Evidence/Notes/"11. Attack Path.md"
	echo "# Findings" > Evidence/Notes/"12. Findings.md"
	echo "export name=$DIRNAME" > .envrc
	echo "export ip=$FINAL_IP" >> .envrc
	direnv allow
}

function get_vpn_ip() {
	interface="$(ip tuntap show | grep -v ligolo | cut -d : -f1 | head -n 1)"
	ip="$(ip a s "${interface}" 2>/dev/null | grep -o -P '(?<=inet )[0-9]{1,3}(\.[0-9]{1,3}){3}')"
	if [[ "${ip}" != "" ]]
	then
		print -P "%F{%(#.blue.red)}[%B%F{yellow}$ip%b%F{%(#.blue.red)}]─"
	fi
}

function start-bloodhound() {
	docker-compose -f /opt/tools/BloodHound/examples/docker-compose/docker-compose.yml up
}

function link-impacket() {
	for i in $(ls /home/thomas/.local/share/pipx/venvs/impacket/bin/ | egrep ".py$");do sudo ln -s /home/thomas/.local/share/pipx/venvs/impacket/bin/$i /usr/local/bin/$i;done
}

function add_host() {
	echo "Enter the IP: "
	read IP
	echo "Enter the hostname: "
	read HOSTNAME
	echo -n "$IP\t$HOSTNAME" | sudo tee -a /etc/hosts
}

function get_ports() {
	machine_name=$1
	cat $machine_name.gnmap | grep "Ports:" | awk -F ':' '{print $3}' | tr ',' '\n' | sed 's/IgnoredState//g' | sed 's/\/\//\//g' | sed -E 's/\/\t$//g;s/\/$//g;s/^ //g'
}

alias subl='/opt/sublime_text/sublime_text'
alias ll='ls -la --group-directories-first --color=auto'
alias vim='nvim'
alias ls='ls --group-directories-first --color=auto'
alias vpn-thm='sudo openvpn --config ~/OVPN/thomfieber.ovpn'
alias vpn-htb='sudo openvpn --config ~/OVPN/lab_th0m12.ovpn'
alias vpn-academy='sudo openvpn --config ~/OVPN/academy-regular.ovpn'
alias vpn-seasonal='sudo openvpn --config ~/OVPN/competitive_th0m12.ovpn'
alias vpn-pg='sudo openvpn --config ~/OVPN/universal.ovpn'
alias vpn-vl='sudo openvpn --config ~/OVPN/aws.ovpn'

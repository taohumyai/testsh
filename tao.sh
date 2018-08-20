#!/bin/bash

if [[ "$EUID" -ne 0 ]]; then
	echo ""
	echo "กรุณาเข้าสู่ระบบผู้ใช้ root ก่อนทำการใช้งานสคริปท์"
	echo "คำสั่งเข้าสู่ระบบผู้ใช้ root คือ sudo -i"
	echo ""
	exit
fi

ln -fs /usr/share/zoneinfo/Asia/Bangkok /etc/localtime
clear
# Color
GRAY='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'

IP=$(wget -4qO- "http://whatismyip.akamai.com/")
# Menu
if
echo -e "ฟังก์ชั่นสคริปท์ ${GRAY}✿.｡.:* *.:｡✿*ﾟ’ﾟ･✿.｡.:*${NC}"
	echo ""
	if [[ -e /etc/openvpn/server.conf ]]; then
		echo -e "|${GRAY} 1${NC}| REMOVE OPENVPN TERMINAL CONTROL ${GREEN}  ${NC}"
	else
		echo -e "|${GRAY} 1${NC}| INSTALL OPENVPN TERMINAL CONTROL ${GREEN}   ${NC}"
echo ""
	read -p "Select a Function Script : " FUNCTIONSCRIPT
fi

case $FUNCTIONSCRIPT in
1) # ==================================================================================================================

newclient () {
	cp /etc/openvpn/client-common.txt ~/$1.ovpn
	echo "<ca>" >> ~/$1.ovpn
	cat /etc/openvpn/easy-rsa/pki/ca.crt >> ~/$1.ovpn
	echo "</ca>" >> ~/$1.ovpn
	echo "<cert>" >> ~/$1.ovpn
	cat /etc/openvpn/easy-rsa/pki/issued/$1.crt >> ~/$1.ovpn
	echo "</cert>" >> ~/$1.ovpn
	echo "<key>" >> ~/$1.ovpn
	cat /etc/openvpn/easy-rsa/pki/private/$1.key >> ~/$1.ovpn
	echo "</key>" >> ~/$1.ovpn
	echo "<tls-auth>" >> ~/$1.ovpn
	cat /etc/openvpn/ta.key >> ~/$1.ovpn
	echo "</tls-auth>" >> ~/$1.ovpn
}

else
	clear
	echo ""
	read -p "IP Server : " -e -i $IP IP
	read -p "Port Server : " -e -i 1194 PORT
	read -p "Port Proxy : " -e -i 8080 PROXY
	echo ""
	echo -e " |${GRAY}1${NC}| UDP"
	echo -e " |${GRAY}2${NC}| TCP"
	echo ""
	read -p "Protocol : " -e -i 2 PROTOCOL
	case $PROTOCOL in
		1) 
		PROTOCOL=udp
		;;
		2) 
		PROTOCOL=tcp
		;;
	esac
	echo ""
	echo -e " |${GRAY}1${NC}| DNS Current System"
	echo -e " |${GRAY}2${NC}| DNS Google"
	echo ""
	read -p "DNS : " -e -i 1 DNS
	echo ""
	echo -e " |${GRAY}1${NC}| Please Enter"

	echo ""
	read -p "Server System : " -e OPENVPNSYSTEM
	echo ""
	read -p "Server Name: " -e CLIENT
	echo ""
	case $OPENVPNSYSTEM in
		2)
		read -p "Your Username : " -e Usernames
		read -p "Your Password : " -e Passwords
		;;
	esac
	echo ""
	read -n1 -r -p "กด Enter 1 ครั้งเพื่อเริ่มทำการติดตั้ง หรือกด CTRL+C เพื่อยกเลิก"

	apt-get update
	apt-get install openvpn iptables openssl ca-certificates -y

	if [[ -d /etc/openvpn/easy-rsa/ ]]; then
		rm -rf /etc/openvpn/easy-rsa/
	fi

	wget -O ~/EasyRSA-3.0.4.tgz "https://github.com/OpenVPN/easy-rsa/releases/download/v3.0.4/EasyRSA-3.0.4.tgz"
	tar xzf ~/EasyRSA-3.0.4.tgz -C ~/
	mv ~/EasyRSA-3.0.4/ /etc/openvpn/
	mv /etc/openvpn/EasyRSA-3.0.4/ /etc/openvpn/easy-rsa/
	chown -R root:root /etc/openvpn/easy-rsa/
	rm -rf ~/EasyRSA-3.0.4.tgz
	cd /etc/openvpn/easy-rsa/
	./easyrsa init-pki
	./easyrsa --batch build-ca nopass
	./easyrsa gen-dh
	./easyrsa build-server-full server nopass
	./easyrsa build-client-full $CLIENT nopass
	EASYRSA_CRL_DAYS=3650 ./easyrsa gen-crl
	cp pki/ca.crt pki/private/ca.key pki/dh.pem pki/issued/server.crt pki/private/server.key pki/crl.pem /etc/openvpn
	chown nobody:$GROUPNAME /etc/openvpn/crl.pem
	openvpn --genkey --secret /etc/openvpn/ta.key

	echo "port $PORT
proto $PROTOCOL
dev tun
sndbuf 0
rcvbuf 0
ca ca.crt
cert server.crt
key server.key
dh dh.pem
auth SHA512
tls-auth ta.key 0
topology subnet
server 10.8.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt" > /etc/openvpn/server.conf
	echo 'push "redirect-gateway def1 bypass-dhcp"' >> /etc/openvpn/server.conf
	case $DNS in
		1)
		if grep -q "127.0.0.53" "/etc/resolv.conf"; then
			RESOLVCONF='/run/systemd/resolve/resolv.conf'
		else
			RESOLVCONF='/etc/resolv.conf'
		fi
		# Obtain the resolvers from resolv.conf and use them for OpenVPN
		grep -v '#' $RESOLVCONF | grep 'nameserver' | grep -E -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | while read line; do
			echo "push \"dhcp-option DNS $line\"" >> /etc/openvpn/server.conf
		done
		;;
		2)
		echo 'push "dhcp-option DNS 8.8.8.8"' >> /etc/openvpn/server.conf
		echo 'push "dhcp-option DNS 8.8.4.4"' >> /etc/openvpn/server.conf
		;;
	esac
	echo "keepalive 10 120
cipher AES-256-CBC
comp-lzo
user nobody
group $GROUPNAME
persist-key
persist-tun
status openvpn-status.log
verb 3
crl-verify crl.pem" >> /etc/openvpn/server.conf
	case $OPENVPNSYSTEM in
		1)
		echo "client-to-client" >> /etc/openvpn/server.conf
		;;
		2)
		if [[ "$VERSION_ID" = 'VERSION_ID="7"' ]]; then
			echo "plugin /usr/lib/openvpn/openvpn-auth-pam.so /etc/pam.d/login" >> /etc/openvpn/server.conf
			echo "client-cert-not-required" >> /etc/openvpn/server.conf
			echo "username-as-common-name" >> /etc/openvpn/server.conf
		else
			echo "plugin /usr/lib/openvpn/openvpn-plugin-auth-pam.so /etc/pam.d/login" >> /etc/openvpn/server.conf
			echo "client-cert-not-required" >> /etc/openvpn/server.conf
			echo "username-as-common-name" >> /etc/openvpn/server.conf
		fi
		;;
		3)
		echo "duplicate-cn" >> /etc/openvpn/server.conf
		;;
	esac

	sed -i '/\<net.ipv4.ip_forward\>/c\net.ipv4.ip_forward=1' /etc/sysctl.conf
	if ! grep -q "\<net.ipv4.ip_forward\>" /etc/sysctl.conf; then
		echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf
	fi

	echo 1 > /proc/sys/net/ipv4/ip_forward
	if pgrep firewalld; then
		firewall-cmd --zone=public --add-port=$PORT/$PROTOCOL
		firewall-cmd --zone=trusted --add-source=10.8.0.0/24
		firewall-cmd --permanent --zone=public --add-port=$PORT/$PROTOCOL
		firewall-cmd --permanent --zone=trusted --add-source=10.8.0.0/24
		firewall-cmd --direct --add-rule ipv4 nat POSTROUTING 0 -s 10.8.0.0/24 ! -d 10.8.0.0/24 -j SNAT --to $IP
		firewall-cmd --permanent --direct --add-rule ipv4 nat POSTROUTING 0 -s 10.8.0.0/24 ! -d 10.8.0.0/24 -j SNAT --to $IP
	else
		if [[ "$OS" = 'debian' && ! -e $RCLOCAL ]]; then
			echo '#!/bin/sh -e
exit 0' > $RCLOCAL
		fi
		chmod +x $RCLOCAL

		iptables -t nat -A POSTROUTING -s 10.8.0.0/24 ! -d 10.8.0.0/24 -j SNAT --to $IP
		sed -i "1 a\iptables -t nat -A POSTROUTING -s 10.8.0.0/24 ! -d 10.8.0.0/24 -j SNAT --to $IP" $RCLOCAL
		if iptables -L -n | grep -qE '^(REJECT|DROP)'; then
			iptables -I INPUT -p $PROTOCOL --dport $PORT -j ACCEPT
			iptables -I FORWARD -s 10.8.0.0/24 -j ACCEPT
			iptables -I FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
			sed -i "1 a\iptables -I INPUT -p $PROTOCOL --dport $PORT -j ACCEPT" $RCLOCAL
			sed -i "1 a\iptables -I FORWARD -s 10.8.0.0/24 -j ACCEPT" $RCLOCAL
			sed -i "1 a\iptables -I FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT" $RCLOCAL
		fi
	fi

	if hash sestatus 2>/dev/null; then
		if sestatus | grep "Current mode" | grep -qs "enforcing"; then
			if [[ "$PORT" != '1194' || "$PROTOCOL" = 'tcp' ]]; then
				semanage port -a -t openvpn_port_t -p $PROTOCOL $PORT
			fi
		fi
	fi


	echo "client
dev tun
proto $PROTOCOL
sndbuf 0
rcvbuf 0
remote $CLIENT 999 udp
remote $IP:$PORT@anywhere.truevisions.tv.ps.line.naver.jp.coral.dtac.co.th $PORT
http-proxy $IP $PROXY
resolv-retry infinite
nobind
persist-key
persist-tun
remote-cert-tls server
auth SHA512
cipher AES-256-CBC
comp-lzo
setenv opt block-outside-dns
key-direction 1
verb 3" > /etc/openvpn/client-common.txt

	case $OPENVPNSYSTEM in
		2)
		echo "auth-user-pass" >> /etc/openvpn/client-common.txt
		;;
	esac

	cd
	apt-get -y install nginx
	cat > /etc/nginx/nginx.conf <<END
user www-data;
worker_processes 2;
pid /var/run/nginx.pid;
events {
	multi_accept on;
        worker_connections 1024;
}
http {
	autoindex on;
        sendfile on;
        tcp_nopush on;
        tcp_nodelay on;
        keepalive_timeout 65;
        types_hash_max_size 2048;
        server_tokens off;
        include /etc/nginx/mime.types;
        default_type application/octet-stream;
        access_log /var/log/nginx/access.log;
        error_log /var/log/nginx/error.log;
        client_max_body_size 32M;
	client_header_buffer_size 8m;
	large_client_header_buffers 8 8m;
	fastcgi_buffer_size 8m;
	fastcgi_buffers 8 8m;
	fastcgi_read_timeout 600;
        include /etc/nginx/conf.d/*.conf;
}
END
	mkdir -p /home/vps/public_html
	echo "<pre>Source by Tao | Donate via TrueMoney Wallet : 095-9965558</pre>" > /home/vps/public_html/index.html
	echo "<?phpinfo(); ?>" > /home/vps/public_html/info.php
	args='$args'
	uri='$uri'
	document_root='$document_root'
	fastcgi_script_name='$fastcgi_script_name'
	cat > /etc/nginx/conf.d/vps.conf <<END
server {
    listen       81;
    server_name  127.0.0.1 localhost;
    access_log /var/log/nginx/vps-access.log;
    error_log /var/log/nginx/vps-error.log error;
    root   /home/vps/public_html;
    location / {
        index  index.html index.htm index.php;
	try_files $uri $uri/ /index.php?$args;
    }
    location ~ \.php$ {
        include /etc/nginx/fastcgi_params;
        fastcgi_pass  127.0.0.1:9000;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    }
}
END

	if [[ "$VERSION_ID" = 'VERSION_ID="7"' || "$VERSION_ID" = 'VERSION_ID="8"' || "$VERSION_ID" = 'VERSION_ID="14.04"' ]]; then
		if [[ -e /etc/squid3/squid.conf ]]; then
			apt-get -y remove --purge squid3
		fi

		apt-get -y install squid3
		cat > /etc/squid3/squid.conf <<END
http_port $PROXY
acl localhost src 127.0.0.1/32 ::1
acl to_localhost dst 127.0.0.0/8 0.0.0.0/32 ::1
acl localnet src 10.0.0.0/8
acl localnet src 172.16.0.0/12
acl localnet src 192.168.0.0/16
acl SSL_ports port 443
acl Safe_ports port 80
acl Safe_ports port 21
acl Safe_ports port 443
acl Safe_ports port 70
acl Safe_ports port 210
acl Safe_ports port 1025-65535
acl Safe_ports port 280
acl Safe_ports port 488
acl Safe_ports port 591
acl Safe_ports port 777
acl CONNECT method CONNECT
acl SSH dst xxxxxxxxx-xxxxxxxxx/255.255.255.255
http_access allow SSH
http_access allow localnet
http_access allow localhost
http_access deny all
refresh_pattern ^ftp:           1440    20%     10080
refresh_pattern ^gopher:        1440    0%      1440
refresh_pattern -i (/cgi-bin/|\?) 0     0%      0
refresh_pattern .               0       20%     4320
END
		IP2="s/xxxxxxxxx/$IP/g";
		sed -i $IP2 /etc/squid3/squid.conf;
		if [[ "$VERSION_ID" = 'VERSION_ID="14.04"' ]]; then
			service squid3 restart
			/etc/init.d/openvpn restart
			/etc/init.d/nginx restart
		else
			/etc/init.d/squid3 restart
			/etc/init.d/openvpn restart
			/etc/init.d/nginx restart
		fi

	

fi

	wget -O /usr/local/bin/menu "https://raw.githubusercontent.com/taohumyai/v2u/master/Menu"
	chmod +x /usr/local/bin/menu
	wget -O /usr/local/bin/Auto-Delete-Client "https://raw.githubusercontent.com/taohumyai/v2u/master/Auto-Delete-Client"
	chmod +x /usr/local/bin/Auto-Delete-Client 
	apt-get -y install vnstat
	cd /etc/openvpn/easy-rsa/
	./easyrsa build-client-full $CLIENT nopass
	newclient "$CLIENT"
	cp /root/$CLIENT.ovpn /home/vps/public_html/
	rm -f /root/$CLIENT.ovpn
	case $OPENVPNSYSTEM in
		2)
		useradd $Usernames
		echo -e "$Passwords\n$Passwords\n"|passwd $Usernames &> /dev/null
		;;
	esac
	clear
	echo ""
	echo "OpenVPN, Squid Proxy, Nginx .....Install finish."
	echo "IP Server : $IP"
	echo "Port Server : $PORT"
	if [[ "$PROTOCOL" = 'udp' ]]; then
		echo "Protocal : UDP"
	elif [[ "$PROTOCOL" = 'tcp' ]]; then
		echo "Protocal : TCP"
	fi
	echo "Port Nginx : 80"
	echo "IP Proxy : $IP"
	echo "Port Proxy : $PROXY"
	echo ""
	case $OPENVPNSYSTEM in
		1)
		echo "Download My Config : http://$IP:80/$CLIENT.ovpn"
		;;
		2)
		echo "Download Config : http://$IP:80/$CLIENT.ovpn"
		echo ""
		echo "Your Username : $Usernames"
		echo "Your Password : $Passwords"
		echo "Expire : Never"
		;;
		3)
		echo "Download Config : http://$IP:80/$CLIENT.ovpn"
		;;
	esac
	echo ""
	echo ""
	echo "====================================================="
	echo -e "ติดตั้งสำเร็จ... กรุณาพิมพ์คำสั่ง${GRAY} menu ${NC} เพื่อไปยังขั้นตอนถัดไป"
	echo "====================================================="
	echo ""
	exit

	;;


	3) # ==================================================================================================================

if [[ -e /etc/default/dropbear ]]; then
	echo ""
	echo "IP นี้ได้ติดตั้ง SSH Dropbear ไปก่อนหน้านี้แล้ว"
	echo ""
	exit

elif [[ ! -e /etc/default/dropbear ]]; then
	apt-get -y install dropbear
	sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
	/etc/init.d/dropbear restart
	PORTSSH=$(grep '^Port ' /etc/ssh/sshd_config | cut -d " " -f 2)
	clear
	echo ""
	echo "SSH Dropbear .....Install Finish."
	echo "IP Addrsss : $IP"
	echo "Port SSH : $PORTSSH"
	echo ""
	if [[ -e /etc/squid3/squid.conf ]]; then
			PROXY=$(grep '^http_port ' /etc/squid3/squid.conf | cut -d " " -f 2)
			echo "IP Proxy : $IP"
			echo "Port Proxy : $PROXY"
	elif [[ -e /etc/squid/squid.conf ]]; then
			PROXY=$(grep '^http_port ' /etc/squid/squid.conf | cut -d " " -f 2)
			echo "IP Proxy : $IP"
			echo "Port Proxy : $PROXY"
			
	else
		echo "No Proxy"
	fi
	echo ""
	exit
fi

	;;

	4) # ==================================================================================================================
	;;

	5) # ==================================================================================================================

if [[ -e /etc/squid3/squid.conf ]]; then
	apt-get -y remove --purge squid3
	clear
	echo ""
	echo "Squid Proxy .....Removed."
	exit
elif [[ -e /etc/squid/squid.conf ]]; then
	apt-get -y remove --purge squid
	clear
	echo ""
	echo "Squid Proxy .....Removed."
	exit
fi

read -p "Port Proxy : " -e -i 8080 PROXY

if [[ "$VERSION_ID" = 'VERSION_ID="7"' || "$VERSION_ID" = 'VERSION_ID="8"' || "$VERSION_ID" = 'VERSION_ID="14.04"' ]]; then
	apt-get -y install squid3
	cat > /etc/squid3/squid.conf <<END
http_port $PROXY
acl localhost src 127.0.0.1/32 ::1
acl to_localhost dst 127.0.0.0/8 0.0.0.0/32 ::1
acl localnet src 10.0.0.0/8
acl localnet src 172.16.0.0/12
acl localnet src 192.168.0.0/16
acl SSL_ports port 443
acl Safe_ports port 80
acl Safe_ports port 21
acl Safe_ports port 443
acl Safe_ports port 70
acl Safe_ports port 210
acl Safe_ports port 1025-65535
acl Safe_ports port 280
acl Safe_ports port 488
acl Safe_ports port 591
acl Safe_ports port 777
acl CONNECT method CONNECT
acl SSH dst xxxxxxxxx-xxxxxxxxx/255.255.255.255
http_access allow SSH
http_access allow localnet
http_access allow localhost
http_access deny all
refresh_pattern ^ftp:           1440    20%     10080
refresh_pattern ^gopher:        1440    0%      1440
refresh_pattern -i (/cgi-bin/|\?) 0     0%      0
refresh_pattern .               0       20%     4320
END
	

	;;

	0) # ==================================================================================================================

esac










#!/bin/bash
#
# DevBy Tao
# ==================================================

# initialisasi var
export DEBIAN_FRONTEND=noninteractive
OS=`uname -m`;
MYIP=$(wget -qO- ipv4.icanhazip.com);
MYIP2="s/xxxxxxxxx/$MYIP/g";

# go to root
cd

# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

# install wget and curl
apt-get update;apt-get -y install wget curl;

# set time GMT +7
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
service ssh restart

# set repo
wget -O /etc/apt/sources.list "http://taohumyai.000webhostapp.com/ovpn/sources.list.debian8"
wget "http://taohumyai.000webhostapp.com/ovpn/dotdeb.gpg"
wget "http://taohumyai.000webhostapp.com/ovpn/jcameron-key.asc"
cat dotdeb.gpg | apt-key add -;rm dotdeb.gpg
cat jcameron-key.asc | apt-key add -;rm jcameron-key.asc

# update
apt-get update

# install webserver
apt-get -y install nginx


# install essential package
apt-get -y install nano iptables dnsutils openvpn screen whois ngrep unzip unrar

# install neofetch
echo "deb http://dl.bintray.com/dawidd6/neofetch jessie main" | sudo tee -a /etc/apt/sources.list
curl -L "https://bintray.com/user/downloadSubjectPublicKey?username=bintray" -o Release-neofetch.key && sudo apt-key add Release-neofetch.key && rm Release-neofetch.key
apt-get update
apt-get install neofetch

echo "clear" >> .bashrc
echo 'echo -e "Welcome to the TAO server $HOSTNAME"' >> .bashrc
echo 'echo -e "Dev By Tao 095-9965558"' >> .bashrc
echo 'echo -e "Open menu to display command list"' >> .bashrc
echo 'echo -e ""' >> .bashrc

# install webserver
cd
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
wget -O /etc/nginx/nginx.conf "http://taohumyai.000webhostapp.com/ovpn/nginx.conf"
mkdir -p /home/vps/public_html
wget -O /etc/nginx/conf.d/vps.conf "http://taohumyai.000webhostapp.com/ovpn/vps.conf"
service nginx restart


# install openvpn
wget -O /etc/openvpn/openvpn.tar "http://taohumyai.000webhostapp.com/ovpn/openvpn-debian.tar"
cd /etc/openvpn/
tar xf openvpn.tar
wget -O /etc/openvpn/1194.conf "http://taohumyai.000webhostapp.com/ovpn/1194.conf"
service openvpn restart
sysctl -w net.ipv4.ip_forward=1
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
iptables -t nat -I POSTROUTING -s 192.168.100.0/24 -o eth0 -j MASQUERADE
iptables-save > /etc/iptables_yg_baru_dibikin.conf
wget -O /etc/network/if-up.d/iptables "http://taohumyai.000webhostapp.com/ovpn/iptables"
chmod +x /etc/network/if-up.d/iptables
service openvpn restart

# config openvpn
cd /etc/openvpn/
wget -O /etc/openvpn/client.ovpn "http://taohumyai.000webhostapp.com/ovpn/client-1194.conf"
sed -i $MYIP2 /etc/openvpn/client.ovpn;
cp client.ovpn /home/vps/public_html/

# install badvpn
cd
wget -O /usr/bin/badvpn-udpgw "http://taohumyai.000webhostapp.com/ovpn/badvpn-udpgw"
if [ "$OS" == "x86_64" ]; then
  wget -O /usr/bin/badvpn-udpgw "http://taohumyai.000webhostapp.com/ovpn/badvpn-udpgw64"
fi
sed -i '$ i\screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300' /etc/rc.local
chmod +x /usr/bin/badvpn-udpgw
screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300

# setting port ssh
cd
sed -i 's/Port 22/Port 22/g' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 143' /etc/ssh/sshd_config
service ssh restart

# install dropbear
apt-get -y install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=443/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 443 -p 80"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
service ssh restart
service dropbear restart

# install squid3
cd
apt-get -y install squid3
wget -O /etc/squid3/squid.conf "http://taohumyai.000webhostapp.com/ovpn/squid3.conf"
sed -i $MYIP2 /etc/squid3/squid.conf;
service squid3 restart

# install webmin
cd
wget http://taohumyai.000webhostapp.com/webmin_1.831_all.deb
dpkg --install webmin_1.831_all.deb
sed -i 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf
rm -f webmin_1.831_all.deb
/usr/share/webmin/changepass.pl /etc/webmin root 11Assa
service webmin restart

# download script
cd /usr/bin
wget -O menu "http://taohumyai.000webhostapp.com/ovpn/menu.sh"
wget -O add "http://taohumyai.000webhostapp.com/ovpn/add.sh"
wget -O addmulti "http://taohumyai.000webhostapp.com/ovpn/addmulti.sh"
wget -O trial "http://taohumyai.000webhostapp.com/ovpn/trial.sh"
wget -O del "http://taohumyai.000webhostapp.com/ovpn/del.sh"
wget -O view "http://taohumyai.000webhostapp.com/ovpn/view.sh"
wget -O tao "http://taohumyai.000webhostapp.com/ovpn/tao.sh"
wget -O res "http://taohumyai.000webhostapp.com/ovpn/res.sh"
wget -O speedtest "http://taohumyai.000webhostapp.com/ovpn/speedtest.py"
wget -O info "http://taohumyai.000webhostapp.com/ovpn/info.sh"
wget -O about "http://taohumyai.000webhostapp.com/ovpn/about.sh"
wget -O online "http://taohumyai.000webhostapp.com/ovpn/online.sh"

echo "0 0 * * * root /sbin/reboot" > /etc/cron.d/reboot

chmod +x menu
chmod +x add
chmod +x addmulti
chmod +x trial
chmod +x del
chmod +x view
chmod +x tao
chmod +x res
chmod +x speedtest
chmod +x info
chmod +x about
chmod +x online

# finishing
cd
chown -R www-data:www-data /home/vps/public_html
service nginx start
service openvpn restart
service cron restart
service ssh restart
service dropbear restart
service squid3 restart
service webmin restart
rm -rf ~/.bash_history && history -c
echo "Canceled HISTFILE" >> /etc/profile

# info
clear
echo "Include:" | tee log-install.txt
echo "===========================================" | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Service"  | tee -a log-install.txt
echo "-------"  | tee -a log-install.txt
echo "OpenSSH  : 22, 143"  | tee -a log-install.txt
echo "Dropbear : 80, 443"  | tee -a log-install.txt
echo "Squid3   : 8080, 3128 (limit to IP SSH)"  | tee -a log-install.txt
echo "OpenVPN  : TCP 1194 (client config : http://$MYIP:81/client.ovpn)"  | tee -a log-install.txt
echo "badvpn   : badvpn-udpgw port 7300"  | tee -a log-install.txt
echo "nginx    : 81"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Script"  | tee -a log-install.txt
echo "------"  | tee -a log-install.txt
echo "menu (show list of menu)"  | tee -a log-install.txt
echo "add (Add New User SSH  1 Session)"  | tee -a log-install.txt
echo "addmulti (Add New User SSH  20 Session)"  | tee -a log-install.txt
echo "trial (Add Trial Accoint)"  | tee -a log-install.txt
echo "del (delete user SSH & OpenVPN)"  | tee -a log-install.txt
echo "view (View User Login)"  | tee -a log-install.txt
echo "tao (View All User SSH)"  | tee -a log-install.txt
echo "online (View All User Online SSH)"  | tee -a log-install.txt
echo "res (Restart Service dropbear, webmin, squid3, openvpn dan ssh)"  | tee -a log-install.txt
echo "reboot (Reboot VPS)"  | tee -a log-install.txt
echo "speedtest (Speedtest VPS)"  | tee -a log-install.txt
echo "info (info this system)"  | tee -a log-install.txt
echo "about (info this script auto install)"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Other features"  | tee -a log-install.txt
echo "----------"  | tee -a log-install.txt
echo "Webmin   : http://$MYIP:10000/"  | tee -a log-install.txt
echo "Timezone : Asia/Jakarta (GMT +7)"  | tee -a log-install.txt
echo "IPv6     : [off]"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Dev By TAO 095-9965558

Fb.com/T4O.iT"  | tee -a log-install.txt
echo "Auto Setup By TAO"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Log of installer --> /root/log-install.txt"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "VPS AUTO REBOOT 00.00"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "==========================================="  | tee -a log-install.txt
cd
rm -f /root/ovpn-taohumyai.sh

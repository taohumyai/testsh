#!/bin/bash
#
# DevBySkyTsDev Please Don't Change Credit
# http://2dth.club
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
wget -O /etc/apt/sources.list "https://taohumyai.000webhostapp.com/ovpn/26092560/sources.list.debian8"
wget "https://taohumyai.000webhostapp.com/ovpn/26092560/dotdeb.gpg"
wget "https://taohumyai.000webhostapp.com/ovpn/26092560/jcameron-key.asc"
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
echo 'echo -e "Welcome to the neko server $HOSTNAME"' >> .bashrc
echo 'echo -e "Dev By SkyTsDev 2016-2017"' >> .bashrc
echo 'echo -e "Open menu to display command list"' >> .bashrc
echo 'echo -e ""' >> .bashrc

# install webserver
cd
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
wget -O /etc/nginx/nginx.conf "https://taohumyai.000webhostapp.com/ovpn/26092560/nginx.conf"
mkdir -p /home/vps/public_html
echo "!--
===========================================================

[ 2DSS1 , HTML File ]

  Template Name : 2DTH[SS1] Responsive Web TP
  
  Version    :  1.0 
  
  Author     :  Akira_Risuto
  
  Author URI :  http://skyts.2dth.club
  
  Author Email : m.skycore@gmail.com

==========================================================
-->

<!doctype html>
<html lang='en' class='no-js'>
<head>
    
    <!--===============
    1 ) Head Section
    ================-->
    
    <meta charset='UTF-8'>
    <meta http-equiv='X-UA-Compatible' content='IE=edge'>
    <meta name='viewport' content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no;'>
    <title>2DTH : : รักอนิเมะรัก 2D ไม่มีวันเปลี่ยนความคิดถ้าโลกยังคงเป็นเช่นนี้</title>
    
    <!--( a ) Fav Icon -->
    
    <link rel='icon' href='http://2dth.club/images/icon/fav_icon.png'>
    
    <!--( b ) CSS Stylesheets -->
    
        <!-- Bootstrap -->
    <link type='text/css' rel='stylesheet' href='http://2dth.club/bootstrap/css/bootstrap.min.css'>
    
        <!-- Library -->
    
    <link type='text/css' rel='stylesheet' href='http://2dth.club/library/font-awesome/css/font-awesome.min.css'>
    <link type='text/css' rel='stylesheet' href='http://2dth.club/library/popup/popup.css'>
    <link type='text/css' rel='stylesheet' href='http://2dth.club/library/owl-carousel/owl.carousel.css'>
    <link type='text/css' rel='stylesheet' href='http://2dth.club/library/owl-carousel/owl.theme.css'>
        
        <!-- STYLE Sheets -->
    
    <link type='text/css' rel='stylesheet' href='http://2dth.club/css/style.css'>
    <link type='text/css' rel='stylesheet' href='http://2dth.club/css/responsive.css'>
    
    <!--( c ) Javascript For Browser Support Issues -->
    
    <script type='text/javascript' src='http://2dth.club/library/modernizr/modernizr.js'></script>
    <!--[if lt IE 9]>
    <script src='https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js'></script>
    <script src='https://oss.maxcdn.com/respond/1.4.2/respond.min.js'></script>
    <![endif]-->
    
</head>
<body>
    
    <!--===========
    2 ) Preloader
    ============-->
    
    <div id='preloader'>
        <div class='loader'>
            <span></span>
            <span></span>
            <span></span>
            <span></span>
        </div>
    </div>
    
    <!--=========
    3 ) Homepage
    ==========-->
    
    <div class='home-page'>
        
        <!--( a ) Introduction -->
        
        <div class='introduction'>
            <img alt='' src='http://2dth.club/images/home_dp.jpg'>
            <div class='mask'>
            </div>
            <div class='intro-content'>
                <h1>2DTH<br>
                We <span><font color='lightblue'> Love</font></span> Anime</h1>
               <div align='center'><h5> <font color='white'>2D ดิจิทอล ออนไลน์ ไทยเเลนด์ [ชมรมคนรักอนิเมะ]</font></h5></div>
                <p class='social-media hidden-xs'>
                    <a href='www.facebook.com/emidesth' class='fa fa-facebook' data-toggle='tooltip' title='Facebook'></a>
     </p>
                
                <!-- Social Media Icons [ END ] -->
                
            </div>
        </div>
        
        <!-- ( b ) Navigation Menu -->
        
        <div class='menu'>
         <a href='http://me.2dth.club'> 
          <div class='profile-btn'>
			 <img alt='' src='http://2dth.club/images/menu/web_btn.jpg'>
                <div class='mask'>
                </div>
                <div class='heading col-xs-11 col-xs-offset-1'>
                    <div class='col-xs-2 hidden-xs'>
                        <i class='fa fa-user'></i>
                    </div>
                    <div class='col-sm-10'>
                        <h2>เข้า<span><font color='yellow'>สู่</font></span>เว็บ</h2>
                        <h3>ดูการ์ตูนเเละอนิเมะต่างๆ</h3>
                    </div>
                </div>
            </div>
            </a>

            <!-- Single Navigation Menu Button [ END ]  -->
            
			<a href='http://rd.2dth.club/'>
            <div class='resume-btn'>
                <img alt='' src='http://2dth.club/images/menu/resume_btn.jpg'>
                <div class='mask'>
                </div>
                <div class='heading col-xs-11 col-xs-offset-1'>
                    <div class='col-xs-2 hidden-xs'>
                        <i class='fa fa-graduation-cap'></i>
                    </div>
                    <div class='col-sm-10'>
                          <h2>Ra<span><font color='lightgreen'>d</font></span>io</h2>
                        <h3>ฟังเพลง JP ใหม่เเละเก่าเพราะๆเพลินๆ</h3>
                    </div>
                </div>
            </div>
			</a>
            
            <!-- Single Navigation Menu Button [ END ]  -->
            
			<a href='http://skd.2dth.club'>
            <div class='portfolio-btn'>
                <img alt='' src='http://2dth.club/images/menu/portfolio_btn.jpg'>
                <div class='mask'>
                </div>
                <div class='heading col-xs-11 col-xs-offset-1'>
                    <div class='col-xs-2 hidden-xs'>
                        <i class='fa fa-briefcase'></i>
                    </div>
                    <div class='col-sm-10'>
                              <h2>Suk<span><font color='orange'>i</font></span>desu</h2>
                        <h3>ชมรมคนรักคลับมหาหื่น</h3>
                    </div>
                </div>
            </div>
			</a>
            
            <!-- Single Navigation Menu Button [ END ]  -->
            
            <a href='http://2dth.club/service.html'>
            <div class='contact-btn'>
				<img alt='' src='http://2dth.club/images/menu/contact_btn.jpg'>
                <div class='mask'>
                </div>
                <div class='heading col-xs-11 col-xs-offset-1'>
                    <div class='col-xs-2 hidden-xs'>
                        <i class='fa fa-envelope-o'></i>
                    </div>
                    <div class='col-sm-10'>
                              <h2>Se<span><font color='red'>r</font></span>vice</h2>
                        <h3>บริการเเละสิ่งต่างๆจากเรา</h3>
                    </div>
                </div>
            </div>
            </a>

            <!-- Single Navigation Menu Button [ END ]  -->
            
        </div>
    </div>
    

                
                    
            
  
    
    <!--============
    9 ) Javascript
    =============-->
    
    <script type='text/javascript' src='http://2dth.club/js/jquery-1.11.3.min.js'></script>
    <script type='text/javascript' src='http://2dth.club/bootstrap/js/bootstrap.min.js'></script>
    <script type='text/javascript' src='http://2dth.club/library/jquery-easing/jquery.easing.min.js'></script>
    <script type='text/javascript' src='http://2dth.club/library/easy-pie-charts/jquery.easypiechart.min.js'></script>
    <script type='text/javascript' src='http://2dth.club/library/mixitup/jquery.mixitup.min.js'></script>
    <script type='text/javascript' src='http://2dth.club/library/popup/jquery.popup.min.js'></script>
    <script type='text/javascript' src='http://2dth.club/library/owl-carousel/owl.carousel.min.js'></script>
    <script type='text/javascript' src='https://maps.google.com/maps/api/js?sensor=true'></script>
    <script type='text/javascript' src='http://2dth.club/library/gMap/jquery.gmap.min.js'></script>
    <script type='text/javascript' src='http://2dth.club/js/script.js'></script>
</body>
</html>" > /home/vps/public_html/index.html
wget -O /etc/nginx/conf.d/vps.conf "https://taohumyai.000webhostapp.com/ovpn/26092560/vps.conf"
service nginx restart

# install openvpn
wget -O /etc/openvpn/openvpn.tar "https://taohumyai.000webhostapp.com/ovpn/26092560/openvpn-debian.tar"
cd /etc/openvpn/
tar xf openvpn.tar
wget -O /etc/openvpn/1194.conf "https://taohumyai.000webhostapp.com/ovpn/26092560/1194.conf"
service openvpn restart
sysctl -w net.ipv4.ip_forward=1
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
iptables -t nat -I POSTROUTING -s 192.168.100.0/24 -o eth0 -j MASQUERADE
iptables-save > /etc/iptables_yg_baru_dibikin.conf
wget -O /etc/network/if-up.d/iptables "https://taohumyai.000webhostapp.com/ovpn/26092560/iptables"
chmod +x /etc/network/if-up.d/iptables
service openvpn restart

# config openvpn
cd /etc/openvpn/
wget -O /etc/openvpn/client.ovpn "https://taohumyai.000webhostapp.com/ovpn/26092560/client-1194.conf"
sed -i $MYIP2 /etc/openvpn/client.ovpn;
cp client.ovpn /home/vps/public_html/

# install badvpn
cd
wget -O /usr/bin/badvpn-udpgw "https://taohumyai.000webhostapp.com/ovpn/26092560/badvpn-udpgw"
if [ "$OS" == "x86_64" ]; then
  wget -O /usr/bin/badvpn-udpgw "https://taohumyai.000webhostapp.com/ovpn/26092560/badvpn-udpgw64"
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
wget -O /etc/squid3/squid.conf "https://taohumyai.000webhostapp.com/ovpn/26092560/squid3.conf"
sed -i $MYIP2 /etc/squid3/squid.conf;
service squid3 restart

# install webmin
cd
wget -O webmin-current.deb "https://taohumyai.000webhostapp.com/ovpn/webmin-current.deb"
dpkg -i --force-all webmin-current.deb;
apt-get -y -f install;
rm /root/webmin-current.deb
service webmin restart

# download script
cd /usr/bin
wget -O usernew "https://taohumyai.000webhostapp.com/ovpn/26092560/usernew.sh" 
wget -O addmulti "https://taohumyai.000webhostapp.com/ovpn/addmulti.sh"
wget -O menu "https://taohumyai.000webhostapp.com/ovpn/26092560/menu.sh" 
wget -O deleuser "https://taohumyai.000webhostapp.com/ovpn/26092560/deleuser.sh"
wget -O trial "https://taohumyai.000webhostapp.com/ovpn/26092560/trial.sh"
wget -O view "https://taohumyai.000webhostapp.com/ovpn/26092560/view.sh"
wget -O acc "https://taohumyai.000webhostapp.com/ovpn/26092560/acc.sh"
wget -O res "https://taohumyai.000webhostapp.com/ovpn/26092560/res.sh"
wget -O speedtest "https://taohumyai.000webhostapp.com/ovpn/26092560/speedtest.py"
wget -O info "https://taohumyai.000webhostapp.com/ovpn/26092560/info.sh"
wget -O about "https://taohumyai.000webhostapp.com/ovpn/26092560/about.sh"
wget -O online "https://taohumyai.000webhostapp.com/ovpn/26092560/online.sh"

echo "0 0 * * * root /sbin/reboot" > /etc/cron.d/reboot

chmod +x usernew
chmod +x addmulti
chmod +x menu 
chmod +x deleuser
chmod +x trial
chmod +x view
chmod +x acc
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
echo "Thank For Buy: 26092560" | tee log-install.txt
echo "Neko Include:" | tee log-install.txt
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
echo "usernew (Add New User SSH)"  | tee -a log-install.txt
echo "addmulti (Add New User SSH  20 Session)"  | tee -a log-install.txt
echo "trial (Add Trial Accoint)"  | tee -a log-install.txt
echo "deluser (delete user SSH & OpenVPN)"  | tee -a log-install.txt
echo "view (View User Login)"  | tee -a log-install.txt
echo "acc (View All User SSH)"  | tee -a log-install.txt
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
echo "Dev By SkyTsDev 2016-2017
AinzSoulSnow
2DTH.CLUB
http://2dth.club
http://app4dev.ml
https://www.youtube.com/channel/UCCvqLDLpB8PGgwMN7ObhwVg"  | tee -a log-install.txt
echo "Auto Setup By SkyTsDev"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Log of installer --> /root/log-install.txt"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "VPS AUTO REBOOT 00.00"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "==========================================="  | tee -a log-install.txt
cd
rm -f /root/ovpn-skytsdev.sh

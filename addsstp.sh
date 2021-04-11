#!/bin/bash
IP=$(wget -qO- ifconfig.co);
pass2="vpn"
psk="vpn"
read -p "Username: " user
read -p "Password: " pass
read -p "Expired (days): " masaaktif
exp=`date -d "$masaaktif days" +"%Y-%m-%d"` 
(printf "1\n\n\n$pass2\n"; sleep 1; printf "Hub $psk\n"; sleep 1; printf "UserCreate $user\n\n\n\n"; sleep 1; printf "UserPasswordSet $user\n$pass\n$pass\n"; sleep 1; printf "UserExpiresSet $user\n$exp 00:00:00\n") | /usr/local/vpnserver/./vpncmd &> /dev/null
echo -e "\n### $user $exp">>"/var/lib/premium-script/data-user-sstp"
tgl=$(echo "$exp" | cut -d- -f3)
bln=$(echo "$exp" | cut -d- -f2)
cat << EOF >> /etc/crontab
# BEGIN_SSTP $user
*/1 0 $tgl $bln * root printf "$user" | xp-sstp
# END_SSTP $user
EOF
service cron restart
clear
cat <<EOF

================================
SSTP VPN 
Server IP     : $IP
Host	        : ${domain}
Username      : $user
Password      : $pass
Port          : 5555
Cert          : http://$IP:81/cert.zip
Expired Until : $exp
================================
By LostServer
EOF

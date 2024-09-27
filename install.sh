#!/bin/bash

green='\033[1;92m'        # Green
White='\033[0m'        # White
yellow='\033[1;93m'       # Yellow
clear
echo -e  "-------------------------------------------"
echo -e  ""
echo -e  "-------------${green} Input Data Set ${White}--------------"
echo -e  ""
echo -e  "-------------------------------------------"
read -p "Please Insert Maximum CPU Threshold :" cpu
echo -e  ""
read -p "Please Insert Maximum Memmory Threshold :" ram
echo -e  ""
read -p "Please Insert Your Telegram CHAT_ID :" id
echo -e  ""
read -p "Please Insert Your Telegram BOT_TOKEN:" token
echo -e  ""
echo -e  ""
echo -e  "${yellow}Start installing Script ...${White}"

wget --no-check-certificate -O /var/log/monitor.sh https://raw.githubusercontent.com/sh-vp/server-monitoring/main/monitoring.sh
chmod +x /var/log/monitor.sh
croncmd1="cd /var/log && bash monitor.sh -c ${cpu} -r ${ram} -i ${id} -t ${token} > /dev/null 2>&1"
croncmd2="sleep 30 && cd /var/log && bash monitor.sh -i ${id} -t ${token} > /dev/null 2>&1"
cronjob1="*/5 * * * * $croncmd1"
cronjob2="@reboot $croncmd2"
( crontab -l | grep -v -F "$croncmd" ; echo "$cronjob" ) | crontab -
( crontab -l | grep -v -F "$croncmd2" ; echo "$cronjob2" ) | crontab -
SERVER_IP=$(hostname -I | awk '{print $1}')
SERVER_HOSTNAME=$(hostname)
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
read -r -d '' msg <<EOT
✅ <b>Server Monitor Installed Successfully !</b>

📌 <b>Host Name: $SERVER_HOSTNAME</b>

🌐 <b>IP Address : $SERVER_IP</b>

📅 <b>Install Time : $TIMESTAMP</b>

--
EOT

curl --data chat_id="${id}" --data-urlencode "text=${msg}" "https://api.telegram.org/bot${token}/sendMessage?parse_mode=HTML" > /dev/null
clear
echo -e  "Server Monitor Installed ${green}Successfully !${White}"

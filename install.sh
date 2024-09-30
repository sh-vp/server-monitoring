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
read -p "Please ENter Send Alert Method (1-Telegram_bot | 2-Gotify :" mod
echo -e  ""
if [[ ${mod} == 2 ]]; then
read -p "Please Insert Your Gotify Login Domain or IP :" id
echo -e  ""
read -p "Please Insert Your Gotify API_TOKEN:" token
echo -e  ""
else
read -p "Please Insert Your Telegram CHAT_ID :" id
echo -e  ""
read -p "Please Insert Your Telegram BOT_TOKEN:" token
echo -e  ""
fi
echo -e  ""
echo -e  "${yellow}Start installing Script ...${White}"

wget --no-check-certificate -O /var/log/monitor.sh https://raw.githubusercontent.com/sh-vp/server-monitoring/main/monitoring.sh
chmod +x /var/log/monitor.sh
SERVER_IP=$(hostname -I | awk '{print $1}')
SERVER_HOSTNAME=$(hostname)
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

if [[ ${mod} == 2 ]]; then
croncmd1="bash /var/log/monitor.sh -m 2 -c ${cpu} -r ${ram} -i ${id} -t ${token} > /dev/null 2>&1"
croncmd2="sleep 30 && bash /var/log/monitor.sh -m 2 -i ${id} -t ${token} > /dev/null 2>&1"
curl -X POST ${id}/message?token=${token} -H "Accept: application/json," -H "Content-Type: application/json" --data-binary @- <<DATA
{
  "title":"✅ Server Monitor Activated Successfully !",
    "message":"📌 Host Name: $SERVER_HOSTNAME\n🌐 IP Address : $SERVER_IP\n📅 Time : $TIMESTAMP",
    "priority":5
}
DATA
else
croncmd1="bash /var/log/monitor.sh -m 1 -c ${cpu} -r ${ram} -i ${id} -t ${token} > /dev/null 2>&1"
croncmd2="sleep 30 && bash /var/log/monitor.sh -m 1 -i ${id} -t ${token} > /dev/null 2>&1"
read -r -d '' msg <<EOT
✅ <b>Server Monitor Activated Successfully !</b>

📌 <b>Host Name: $SERVER_HOSTNAME</b>

🌐 <b>IP Address : $SERVER_IP</b>

📅 <b>Time : $TIMESTAMP</b>

--
EOT

curl --data chat_id="${id}" --data-urlencode "text=${msg}" "https://api.telegram.org/bot${token}/sendMessage?parse_mode=HTML" > /dev/null
fi
cronjob1="*/5 * * * * $croncmd1"
cronjob2="@reboot $croncmd2"
( crontab -l | grep -v -F "$croncmd1" ; echo "$cronjob1" ) | crontab -
( crontab -l | grep -v -F "$croncmd2" ; echo "$cronjob2" ) | crontab -
clear
echo -e  "Server Monitor Installed ${green}Successfully !${White}"

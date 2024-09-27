#!/bin/bash

RED='\033[1;91m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

while getopts "c:r:i:t:" arg; do
  case $arg in
    c) cpu=$OPTARG;;
    r) ram=$OPTARG;;
    i) chatid=$OPTARG;;
    t) token=$OPTARG;;
  esac
done

# Get current CPU and memory usage
cores=$(nproc)
total_memory_demical=$(free -h | awk '/^Mem:/ {print $2}')
decimal_CPU=$(top -b -n 1 | grep "%Cpu(s)" | awk '{print $2}' | cut -d. -f1)
decimal_MEMORY=$(free | awk '/Mem/{printf("%.2f"), $3/$2*100}')

CURRENT_CPU=$(expr "$decimal_CPU" : '^\([0-9]*\)')
CURRENT_MEMORY=$(expr "$decimal_MEMORY" : '^\([0-9]*\)')
total_memory=$(expr "$total_memory_demical" : '^\([0-9]*\)')
# Get server IP address and hostname
SERVER_IP=$(hostname -I | awk '{print $1}')
SERVER_HOSTNAME=$(hostname)
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
if [[ -n "$cpu" && -n "$ram" && -n "$chatid" && -n "$token" ]]; then
# Check if CPU or memory usage exceeds the threshold
if [ "$CURRENT_CPU" -gt "${cpu}" ] || [ "$CURRENT_MEMORY" -gt "${ram}" ]; then
    
    ALERT_MESSAGE="High resource usage detected! CPU Core : $cores, CPU: $CURRENT_CPU%, Memmory Capacity : $total_memory GB, Memory: $CURRENT_MEMORY%"
read -r -d '' msg <<EOT
⚠️ <b>Server Usage Alert !</b>

📌 <b>Host Name: $SERVER_HOSTNAME</b>

🌐 <b>IP Address : $SERVER_IP</b>

🔺 <b>CPU Core : $cores</b>

📊 <b>CPU Usage : $CURRENT_CPU %</b>

🔺 <b>Memmory Capacity : $total_memory GB</b>

📈 <b>Memmory Usage : $CURRENT_MEMORY %</b>

📅 <b>Time : $TIMESTAMP</b>

--
EOT

curl --data chat_id="${chatid}" --data-urlencode "text=${msg}" "https://api.telegram.org/bot${token}/sendMessage?parse_mode=HTML" > /dev/null
    echo "$TIMESTAMP - $ALERT_MESSAGE (Server IP: $SERVER_IP, Hostname: $SERVER_HOSTNAME)" >> /var/log/resource_alert.log
fi
elif [[ -n "$chatid" && -n "$token" ]]; then
read -r -d '' msg <<EOT
🔄 <b>Server Reboot Alert !</b>

📌 <b>Host Name: $SERVER_HOSTNAME</b>

🌐 <b>IP Address : $SERVER_IP</b>

🔺 <b>CPU Core : $cores</b>

📊 <b>CPU Usage : $CURRENT_CPU %</b>

🔺 <b>Memmory Capacity : $total_memory GB</b>

📈 <b>Memmory Usage : $CURRENT_MEMORY %</b>

📅 <b>Time : $TIMESTAMP</b>

--
EOT

curl --data chat_id="${chatid}" --data-urlencode "text=${msg}" "https://api.telegram.org/bot${token}/sendMessage?parse_mode=HTML" > /dev/null
    echo "$TIMESTAMP - Server Usage Alert ! (Server IP: $SERVER_IP, Hostname: $SERVER_HOSTNAME)" >> /var/log/resource_alert.log
else
  clear
  echo -e  ""
  echo -e  "${YELLOW}Script Alert!${NC}"
  echo -e  ""
  echo -e "${RED}Please Insert ${BLUE}-c ${GREEN}<CPU> ${BLUE}-r ${GREEN}<Memmory> ${BLUE}-i ${GREEN}<ChatID> ${BLUE}-t ${GREEN}<Telegram_Token>${NC} !"
  echo -e  ""
    fi

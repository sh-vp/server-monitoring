#!/bin/bash

green='\033[1;92m'     # Green
White='\033[0m'        # White
yellow='\033[1;93m'    # Yellow
clear
echo -e  "-------------------------------------------"
echo -e  ""
echo -e  "-------------${green} Input Data Set ${White}--------------"
echo -e  ""
echo -e  "-------------------------------------------"
read -p "Please Insert Your Gotify Login Domain or IP :" id
echo -e  ""
read -p "Please Insert Your Gotify API_TOKEN:" token
echo -e  ""

echo -e  ""
echo -e  "${yellow}Start installing Script ...${White}"

curl -X POST ${id}/message?token=${token} -H "Accept: application/json," -H "Content-Type: application/json" --data-binary @- <<DATA
{
  "title":"✅ Server Monitor Installed Successfully !",
    "message":"📌 Host Name: $SERVER_HOSTNAME\n🌐 IP Address : $SERVER_IP\n📅 Time : $TIMESTAMP",
    "priority":5
}
DATA

echo -e  "Server Monitor Installed ${green}Successfully !${White}"

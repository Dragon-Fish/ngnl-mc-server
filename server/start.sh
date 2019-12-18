#!/bin/bash
while true
  do
    echo -e "\e[1;42m正在启动Minecraft服务器...\e[0m"
    java -Xms1024M -Xmx3200M -jar server.jar nogui
    echo ""
    echo -e "\e[1;45mMinecraft服务器即将自动重启... \e[0m"
    if read -n1 -t 5 -p ">>>在5秒内按任意键取消..."
    then
      echo "检测到操作 - 行动取消"
      echo -e "\e[1;41mMinecraft自动重启程序已终止!\e[0m"
      exit 0
    else
      echo "无操作 - 行动确认"
      echo -e "\e[1;43m重新启动Minecraft服务器...\e[0m"
    fi
done

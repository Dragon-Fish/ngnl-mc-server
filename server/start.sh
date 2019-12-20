#!/bin/bash
# 自动存档函数
function autoSaveWorld() {
  # 变量
  ymd=$(date +"%Y-%m-%d")
  timestamp=$(date +"%Y%m%d%H%M%S")
  fileName="Auto-archive-${timestamp}.tar.gz"
  # echo
  echo -e "\e[1;43m正在自动备份存档...\e[0m"
  cat > world/Auto-archive.log <<EOF
# 游戏人生wikiMinecraft服务器存档自动备份程序 NGNL_Server_Auto-archive_System Ver.2.2.0
# Copyright: 机智的小鱼君
## 此日志文件由程序自动生成
[NGNL_Server_Auto-archive_System]
备份开始！
开始时间 $(date)
- 正在获取基础信息...
 - 存档绝对路径: /opt/minecraft/world
 - 存档日期: ${ymd}
 - Timestamp: ${timestamp}
- 开始清理过旧存档
 - 完成
EOF
  # 先执行清理任务以防硬盘爆炸
  echo "清理过旧的存档..."
  # 最多只保留3天内的文件夹，每天只保留最后5个文件
  maxFileNum=4
  maxDirNum=3
  fileDir="world_autosave/"
  todayDir="${fileDir}${ymd}/"
  fileList=`ls -c $fileDir`
  todayList=`ls -c $todayDir`
  fromNum1=0
  fromNum2=0
  # 清理超过3天的文件夹
  for file in $fileList
  do
    fromNum1=`expr $fromNum1 + 1`
    if [ $fromNum1 -gt $maxDirNum ]; then
      rm -rf $fileDir$file
    fi
  done
  # 清理当日过多的文件
  for file in $todayList
  do
    fromNum2=`expr $fromNum2 + 1`
    if [ $fromNum2 -gt $maxFileNum ]; then
      rm -rf $todayDir$file
    fi
  done
  # 开始压缩当前存档
  echo "正在新建文件夹..."
  mkdir "world_autosave"
  mkdir "world_autosave/${ymd}"
  echo "正在压缩文件..."
  cat >> world/Auto-archive.log <<EOF
- 新建文件夹
 - 完成
  - 备份目录: ${todayDir}
- 压缩存档
  - 完成
   - 文件名: ${fileName}
完成于 $(date)
全部完成！
EOF
  tar -czf "${todayDir}${fileName}" world
  echo "存档备份完毕。"
}
# 开始循环
while true
  do
    echo -e "\e[1;42m正在启动Minecraft服务器...\e[0m"
    java -Xms1024M -Xmx3200M -jar server.jar nogui
    echo ""
    echo -e "\e[1;45mMinecraft服务器即将自动重启... \e[0m"
    if read -n1 -t 5 -p ">>>在5秒内按任意键取消..."
    then
      echo "检测到操作 - 开始自动备份存档并终止程序"
      autoSaveWorld
      clear
      echo -e "\e[1;41mMinecraft服务器已关闭!\e[0m"
      exit 0
    else
      echo "无操作 - 开始自动备份存档并重启服务器"
      autoSaveWorld
      echo -e "\e[1;43m重新启动Minecraft服务器...\e[0m"
    fi
done

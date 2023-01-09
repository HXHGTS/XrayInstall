#!/bin/sh

echo 正在配置IPV6安装环境. . .

cp -f /etc/resolv.conf /etc/resolv.conf.bak

echo 'nameserver 2606:4700:4700::1111' > /etc/resolv.conf

echo 'nameserver 2606:4700:4700::1001' >> /etc/resolv.conf

echo 正在关闭xray. . .

systemctl disable xray

systemctl stop xray

echo 正在进行更新前准备. . .

mkdir -p /var/tmp/xray

apt install wget unzip -y

echo 正在下载最新版Xray X64. . .

wget https://summer-poetry-7fa8.qq0mjpmkt9z.workers.dev/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip -O /var/tmp/Xray-linux-64.zip

echo 正在解压并安装. . .

unzip -o -d /var/tmp/xray /var/tmp/Xray-linux-64.zip

mv -f /var/tmp/xray/xray /usr/local/bin/xray

chmod +x /usr/local/bin/xray

mv -f /var/tmp/xray/geoip.dat /usr/local/share/xray/geoip.dat

mv -f /var/tmp/xray/geosite.dat /usr/local/share/xray/geosite.dat

systemctl enable xray

systemctl start xray

echo 正在清理残余文件. . .

rm -rf /var/tmp/xray

rm -f /var/tmp/Xray-linux-64.zip

echo 正在恢复IPV6网络环境. . .

cp -f /etc/resolv.conf.bak /etc/resolv.conf

echo Xray 更新成功!

echo -------Xray版本号-------

xray --version | grep Xray

echo 

echo ------------------------

exit 0

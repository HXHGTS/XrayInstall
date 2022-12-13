#!/bin/sh

echo 正在清理已安装xray. . .

systemctl disable xray

systemctl stop xray

rm -rf /usr/local/etc/xray

echo 正在进行安装前准备. . .

mkdir -p /usr/local/etc/xray

mkdir -p /var/tmp/xray

mkdir -p /usr/local/share/xray

mkdir -p /etc/systemd/system/xray.service.d

mkdir -p /etc/systemd/system/xray@.service.d

apt install wget unzip -y

echo 正在下载最新测试版Xray X64. . .

wget https://github.com/XTLS/Xray-core/releases/download/v1.6.6-2/Xray-linux-64.zip -O /var/tmp/Xray-linux-64.zip

echo 正在下载配置文件. . .

curl -sSL https://raw.githubusercontent.com/HXHGTS/XrayInstall/main/services/xray.service > /etc/systemd/system/xray.service

curl -sSL https://raw.githubusercontent.com/HXHGTS/XrayInstall/main/services/xray@.service > /etc/systemd/system/xray@.service

curl -sSL https://raw.githubusercontent.com/HXHGTS/XrayInstall/main/services/xray.service.d/10-donot_touch_single_conf.conf > /etc/systemd/system/xray.service.d/10-donot_touch_single_conf.conf

curl -sSL https://raw.githubusercontent.com/HXHGTS/XrayInstall/main/services/xray@.service.d/10-donot_touch_single_conf.conf > /etc/systemd/system/xray@.service.d/10-donot_touch_single_conf.conf

systemctl daemon-reload

echo 正在解压并安装. . .

unzip -o -d /var/tmp/xray /var/tmp/Xray-linux-64.zip

mv -f /var/tmp/xray/xray /usr/local/bin/xray

chmod +x /usr/local/bin/xray

mv -f /var/tmp/xray/geoip.dat /usr/local/share/xray/geoip.dat

mv -f /var/tmp/xray/geosite.dat /usr/local/share/xray/geosite.dat

echo '{}' > /usr/local/etc/xray/config.json

systemctl enable xray

systemctl start xray

echo 正在清理残余文件. . .

rm -rf /var/tmp/xray

rm -f /var/tmp/Xray-linux-64.zip

echo Xray 安装成功!

echo -------Xray版本号-------

xray --version | grep Xray

echo 

echo ------------------------

exit 0

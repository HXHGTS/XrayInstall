#!/bin/sh

echo 正在关闭xray. . .
if systemctl is-active --quiet xray; then
    echo Xray正在运行，正在停止Xray. . .
    systemctl disable xray --now
else
    echo Xray未运行.
fi

echo 正在进行更新前准备. . .
[ ! -d /var/tmp/xray ] && mkdir -p /var/tmp/xray

echo 正在下载最新版Xray X64. . .
wget https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip -O /var/tmp/Xray-linux-64.zip

echo 正在解压并安装. . .
unzip -o -d /var/tmp/xray /var/tmp/Xray-linux-64.zip

rm -f /var/tmp/xray/geoip.dat
rm -f /var/tmp/xray/geosite.dat

mv -f /var/tmp/xray/xray /usr/local/bin/xray
chmod +x /usr/local/bin/xray

wget -O /usr/local/share/xray/geoip.dat https://github.com/v2fly/geoip/releases/latest/download/geoip.dat
wget -O /usr/local/share/xray/geosite.dat https://github.com/v2fly/domain-list-community/releases/latest/download/dlc.dat

echo 正在清理残余文件. . .
rm -rf /var/tmp/xray
rm -f /var/tmp/Xray-linux-64.zip

echo 正在启动xray. . .
systemctl enable xray --now

echo Xray 更新成功!

echo -------Xray版本号-------
xray --version | grep Xray
echo ------------------------

exit 0

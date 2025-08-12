#!/bin/sh

echo 正在清理已安装xray. . .

if systemctl is-active --quiet xray; then
    echo Xray正在运行，正在停止Xray. . .
    systemctl disable xray --now
else
    echo Xray未运行.
fi

if [ -d /usr/local/etc/xray ]; then
    echo 正在删除/usr/local/etc/xray目录. . .
    rm -rf /usr/local/etc/xray
else
    echo /usr/local/etc/xray目录不存在.
fi

echo 正在进行安装前准备. . .

[ ! -d /usr/local/etc/xray ] && mkdir -p /usr/local/etc/xray
[ ! -d /var/tmp/xray ] && mkdir -p /var/tmp/xray
[ ! -d /var/log/xray ] && mkdir -p /var/log/xray
[ ! -d /usr/local/share/xray ] && mkdir -p /usr/local/share/xray
[ ! -d /etc/systemd/system/xray.service.d ] && mkdir -p /etc/systemd/system/xray.service.d
[ ! -d /etc/systemd/system/xray@.service.d ] && mkdir -p /etc/systemd/system/xray@.service.d

apt install wget unzip -y

echo 正在下载最新版Xray X64. . .
wget https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip -O /var/tmp/Xray-linux-64.zip

echo 正在下载配置文件. . .
curl -sSL https://raw.githubusercontent.com/HXHGTS/XrayInstall/main/services/xray.service >/etc/systemd/system/xray.service
curl -sSL https://raw.githubusercontent.com/HXHGTS/XrayInstall/main/services/xray@.service >/etc/systemd/system/xray@.service
curl -sSL https://raw.githubusercontent.com/HXHGTS/XrayInstall/main/services/xray.service.d/10-donot_touch_single_conf.conf >/etc/systemd/system/xray.service.d/10-donot_touch_single_conf.conf
curl -sSL https://raw.githubusercontent.com/HXHGTS/XrayInstall/main/services/xray@.service.d/10-donot_touch_single_conf.conf >/etc/systemd/system/xray@.service.d/10-donot_touch_single_conf.conf

systemctl daemon-reload

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

echo Xray 安装成功!

echo -------Xray版本号-------
xray --version | grep Xray
echo ------------------------

exit 0

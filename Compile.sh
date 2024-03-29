#!/bin/sh

echo 正在清理已安装xray. . .

systemctl disable xray

systemctl stop xray

rm -rf /usr/local/etc/xray

echo '正在安装/升级必需插件. . .'

apt update

apt install -y curl wget tar gawk sed git

echo '正在打开Go环境. . .'

source /root/.bashrc

go version

echo '正在编译linux版xray核心. . .'

rm -rf /root/Xray-core

git clone https://github.com/XTLS/Xray-core.git

cd Xray-core && go mod download

env GOOS=linux GOARCH=amd64 GOAMD64=v3 CGO_ENABLED=0 go build -o xray -trimpath -ldflags "-s -w -buildid=" ./main

mv -f xray /usr/local/bin/xray

chmod +x /usr/local/bin/xray

echo 正在进行安装前准备. . .

mkdir -p /usr/local/etc/xray

mkdir -p /var/tmp/xray

mkdir -p /usr/local/share/xray

mkdir -p /etc/systemd/system/xray.service.d

mkdir -p /etc/systemd/system/xray@.service.d

curl -sSL https://raw.githubusercontent.com/HXHGTS/XrayInstall/main/services/xray.service > /etc/systemd/system/xray.service

curl -sSL https://raw.githubusercontent.com/HXHGTS/XrayInstall/main/services/xray@.service > /etc/systemd/system/xray@.service

curl -sSL https://raw.githubusercontent.com/HXHGTS/XrayInstall/main/services/xray.service.d/10-donot_touch_single_conf.conf > /etc/systemd/system/xray.service.d/10-donot_touch_single_conf.conf

curl -sSL https://raw.githubusercontent.com/HXHGTS/XrayInstall/main/services/xray@.service.d/10-donot_touch_single_conf.conf > /etc/systemd/system/xray@.service.d/10-donot_touch_single_conf.conf

wget -O /usr/local/share/xray/geoip.dat https://github.com/Loyalsoldier/geoip/releases/latest/download/geoip.dat

wget -O /usr/local/share/xray/geosite.dat https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat

echo '{}' > /usr/local/etc/xray/config.jsonc

systemctl daemon-reload

systemctl enable xray

systemctl start xray

echo -------Xray版本号-------

xray --version | grep Xray

echo 

echo ------------------------

exit 0

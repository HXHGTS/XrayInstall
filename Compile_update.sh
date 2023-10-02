#!/bin/sh

echo '正在进行数据库更新. . .'

wget -O /usr/local/share/xray/geoip.dat https://raw.githubusercontent.com/Loyalsoldier/geoip/release/geoip.dat

wget -O /usr/local/share/xray/geosite.dat https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat

echo '正在安装/升级必需插件. . .'

apt update

apt install -y curl wget tar gawk sed git

echo '正在安装/升级go. . .'

apt remove -y --purge golang

apt autoremove -y

rm -rf /usr/local/go

Go_Version=$(curl https://github.com/golang/go/tags | grep '/releases/tag/go' | head -n 1 | gawk -F/ '{print $6}' | gawk -F\" '{print $1}')

wget -O /var/tmp/${Go_Version}.linux-amd64.tar.gz https://go.dev/dl/${Go_Version}.linux-amd64.tar.gz

tar -C /usr/local -xzf /var/tmp/${Go_Version}.linux-amd64.tar.gz

rm -f /var/tmp/${Go_Version}.linux-amd64.tar.gz

export PATH=$PATH:/usr/local/go/bin

go version

echo '正在编译linux版xray核心. . .'

rm -rf /root/Xray-core

git clone https://github.com/XTLS/Xray-core.git

cd Xray-core && go mod download

env GOOS=linux GOARCH=amd64 GOAMD64=v3 CGO_ENABLED=0 go build -o xray_v3 -trimpath -ldflags "-s -w -buildid=" ./main

echo '正在关闭/卸载xray核心. . .'

systemctl stop xray

systemctl disable xray

mv -f xray_v3 /usr/local/bin/xray

chmod +x /usr/local/bin/xray

systemctl enable xray

systemctl restart xray

echo -------Xray版本号-------

xray --version

echo 

echo ------------------------

exit 0

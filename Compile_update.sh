#!/bin/sh

echo '正在进行数据库更新. . .'

wget -O /usr/local/share/xray/geoip.dat https://github.com/v2fly/geoip/releases/latest/download/geoip.dat

wget -O /usr/local/share/xray/geosite.dat https://github.com/v2fly/domain-list-community/releases/latest/download/dlc.dat

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

echo '正在关闭/卸载xray核心. . .'

systemctl stop xray

systemctl disable xray

mv -f xray /usr/local/bin/xray

chmod +x /usr/local/bin/xray

systemctl enable xray

systemctl restart xray

echo -------Xray版本号-------

xray --version | grep Xray

echo 

echo ------------------------

exit 0

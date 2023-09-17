#!/bin/sh

echo '正在关闭/卸载xray核心. . .'

systemctl stop xray

systemctl disable xray

echo '正在安装/升级必需插件. . .'

apt update

apt install -y curl wget tar gawk sed

apt install -y git build-essential

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

git clone https://github.com/XTLS/Xray-core.git

cd Xray-core && go mod download

env GOOS=linux GOARCH=amd64 GOAMD64=v3 CGO_ENABLED=0 go build -o xray_v3 -trimpath -ldflags "-s -w -buildid=" ./main

env GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o xray -trimpath -ldflags "-s -w -buildid=" ./main

echo '正在编译Windows版xray核心. . .'

env GOOS=windows GOARCH=amd64 GOAMD64=v3 CGO_ENABLED=0 go build -o xray_v3.exe -trimpath -ldflags "-s -w -buildid=" ./main

env GOOS=windows GOARCH=amd64 CGO_ENABLED=0 go build -o xray.exe -trimpath -ldflags "-s -w -buildid=" ./main

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

wget -O /usr/local/share/xray/geoip.dat https://raw.githubusercontent.com/Loyalsoldier/geoip/release/geoip.dat

wget -O /usr/local/share/xray/geosite.dat https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat

echo '{}' > /usr/local/etc/xray/config.json

systemctl daemon-reload

systemctl enable xray

systemctl start sing-box

echo -------Xray版本号-------

xray --version | grep Xray

echo 

echo ------------------------

exit 0

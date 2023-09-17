#!/bin/sh

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

git clone https://github.com/XTLS/Xray-core.git

cd Xray-core && go mod download

echo '正在编译Windows版xray核心. . .'

env GOOS=windows GOARCH=amd64 GOAMD64=v3 CGO_ENABLED=0 go build -o xray_v3.exe -trimpath -ldflags "-s -w -buildid=" ./main

env GOOS=windows GOARCH=amd64 CGO_ENABLED=0 go build -o xray.exe -trimpath -ldflags "-s -w -buildid=" ./main

echo '正在编译Windows版wxray核心. . .'

env GOOS=windows GOARCH=amd64 GOAMD64=v3 CGO_ENABLED=0 go build -v -o wxray_v3.exe -trimpath -ldflags "-s -w -H windowsgui -buildid=" ./main

env GOOS=windows GOARCH=amd64 CGO_ENABLED=0 go build -v -o wxray.exe -trimpath -ldflags "-s -w -H windowsgui -buildid=" ./main

exit 0

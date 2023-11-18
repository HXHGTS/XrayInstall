#!/bin/sh

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

echo '正在编译Windows版xray核心. . .'

env GOOS=windows GOARCH=amd64 GOAMD64=v3 CGO_ENABLED=0 go build -o xray.exe -trimpath -ldflags "-s -w -buildid=" ./main

#env GOOS=windows GOARCH=amd64 CGO_ENABLED=0 go build -o xray.exe -trimpath -ldflags "-s -w -buildid=" ./main

echo '正在编译Windows版wxray核心. . .'

env GOOS=windows GOARCH=amd64 GOAMD64=v3 CGO_ENABLED=0 go build -v -o wxray.exe -trimpath -ldflags "-s -w -H windowsgui -buildid=" ./main

#env GOOS=windows GOARCH=amd64 CGO_ENABLED=0 go build -v -o wxray.exe -trimpath -ldflags "-s -w -H windowsgui -buildid=" ./main

exit 0

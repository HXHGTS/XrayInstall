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

apt install wget unzip sed grep -y

echo 正在下载最新版Xray X64. . .

curl https://restless-wave-4c58.qq0mjpmkt9z.workers.dev/repos/XTLS/Xray-core/releases | grep "Xray-linux-64.zip" | grep "browser_download_url" | grep -v "dgst" > /var/tmp/GetXrayURL.txt

sed -i '2,$d' /var/tmp/GetXrayURL.txt

sed -i "s/        \"browser_download_url\": \"//" /var/tmp/GetXrayURL.txt

sed -i "s/\"//" /var/tmp/GetXrayURL.txt

sed -i "s/github.com/summer-poetry-7fa8.qq0mjpmkt9z.workers.dev/" /var/tmp/GetXrayURL.txt

wget -i /var/tmp/GetXrayURL.txt -O /var/tmp/Xray-linux-64.zip

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

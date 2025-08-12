#!/bin/sh

echo 正在关闭已安装xray. . .

systemctl disable xray

systemctl stop xray

echo 正在进行更新前准备. . .

mkdir -p /var/tmp/xray

apt install wget unzip sed grep -y

echo 正在下载最新测试版Xray X64. . .

curl https://api.github.com/repos/XTLS/Xray-core/releases | grep "Xray-linux-64.zip" | grep "browser_download_url" | grep -v "dgst" > /var/tmp/GetXrayURL.txt

sed -i '2,$d' /var/tmp/GetXrayURL.txt

sed -i "s/        \"browser_download_url\": \"//" /var/tmp/GetXrayURL.txt

sed -i "s/\"//" /var/tmp/GetXrayURL.txt

wget -i /var/tmp/GetXrayURL.txt -O /var/tmp/Xray-linux-64.zip

echo 正在解压并安装. . .

unzip -o -d /var/tmp/xray /var/tmp/Xray-linux-64.zip

rm -f /var/tmp/xray/geoip.dat

rm -f /var/tmp/xray/geosite.dat

mv -f /var/tmp/xray/xray /usr/local/bin/xray

chmod +x /usr/local/bin/xray

wget -O /usr/local/share/xray/geoip.dat https://github.com/v2fly/geoip/releases/latest/download/geoip.dat

wget -O /usr/local/share/xray/geosite.dat https://github.com/v2fly/domain-list-community/releases/latest/download/dlc.dat

systemctl enable xray

systemctl start xray

echo 正在清理残余文件. . .

rm -rf /var/tmp/xray

rm -f /var/tmp/GetXrayURL.txt

rm -f /var/tmp/Xray-linux-64.zip

echo Xray 安装成功!

echo -------Xray版本号-------

xray --version | grep Xray

echo 

echo ------------------------

exit 0

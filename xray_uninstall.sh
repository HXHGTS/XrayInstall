#!/bin/sh

echo 正在清理已安装xray. . .

systemctl disable xray

systemctl stop xray

rm -rf /usr/local/etc/xray

rm -rf /usr/local/share/xray

rm -f /usr/local/bin/xray

rm -f /usr/local/bin/xray

rm -rf /var/tmp/xray

rm -f /var/tmp/Xray-linux-64.zip

rm -f /var/tmp/GetXrayURL.txt

rm -rf /root/Xray-core

echo 正在删除服务. . .

rm -f /etc/systemd/system/xray.service

rm -f /etc/systemd/system/xray@.service

rm -rf /etc/systemd/system/xray.service.d

rm -rf /etc/systemd/system/xray@.service.d

rm -f /etc/systemd/system/xray.service.d/10-donot_touch_single_conf.conf

rm -f /etc/systemd/system/xray@.service.d/10-donot_touch_single_conf.conf

systemctl daemon-reload

echo Xray 卸载成功!

exit 0

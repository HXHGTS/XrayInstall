#!/bin/sh

echo 正在清理已安装xray. . .
if systemctl is-active --quiet xray; then
    echo Xray正在运行，正在停止Xray. . .
    systemctl disable xray --now
else
    echo Xray未运行.
fi

[ -d /usr/local/etc/xray ] && rm -rf /usr/local/etc/xray
[ -d /usr/local/share/xray ] && rm -rf /usr/local/share/xray
[ -f /usr/local/bin/xray ] && rm -f /usr/local/bin/xray
[ -d /var/tmp/xray ] && rm -rf /var/tmp/xray
[ -d /var/log/xray ] && rm -rf /var/log/xray
[ -f /var/tmp/Xray-linux-64.zip ] && rm -f /var/tmp/Xray-linux-64.zip
[ -f /var/tmp/GetXrayURL.txt ] && rm -f /var/tmp/GetXrayURL.txt
[ -d /root/Xray-core ] && rm -rf /root/Xray-core

echo 正在删除服务. . .
find /etc/systemd/system -name "*xray*" -exec rm -rf {} \;

systemctl daemon-reload

echo Xray 卸载成功!

exit 0

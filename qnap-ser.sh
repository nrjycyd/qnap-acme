#!/bin/bash

# 获取脚本所在目录的绝对路径
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

# 读取配置文件
CONFIG_FILE="$SCRIPT_DIR/config"
if [ -f "$CONFIG_FILE" ]; then
    . "$CONFIG_FILE"
else
    echo "qnap-ser.sh检测到配置文件不存在: $CONFIG_FILE"
    exit 1
fi

# 确保 DOMAIN 被正确读取
if [ -z "$DOMAIN" ]; then
    echo "配置文件中缺少 DOMAIN 变量"
    exit 1
fi

# 定义证书路径
CERT_DIR="$SCRIPT_DIR/acme.sh/$DOMAIN"
KEY_PATH="$CERT_DIR/$DOMAIN.key"
CER_PATH="$CERT_DIR/$DOMAIN.cer"
CA_PATH="$CERT_DIR/ca.cer"

# 检查证书文件是否存在
if [ ! -f "$KEY_PATH" ] || [ ! -f "$CER_PATH" ] || [ ! -f "$CA_PATH" ]; then
    echo "一个或多个证书文件不存在:"
    [ ! -f "$KEY_PATH" ] && echo "缺少: $KEY_PATH"
    [ ! -f "$CER_PATH" ] && echo "缺少: $CER_PATH"
    [ ! -f "$CA_PATH" ] && echo "缺少: $CA_PATH"
    exit 1
fi

# 连接证书文件
cat "$KEY_PATH" "$CER_PATH" "$CA_PATH" > "/etc/stunnel/stunnel_temp.pem"
if [ $? -ne 0 ]; then
    echo "合并证书文件失败"
    exit 1
fi

# 移动临时文件到目标位置
mv "/etc/stunnel/stunnel_temp.pem" "/etc/stunnel/stunnel.pem"
if [ $? -ne 0 ]; then
    echo "移动证书文件失败"
    exit 1
fi

# 复制证书文件到指定位置
cp "$CA_PATH" "/etc/stunnel/uca.pem"
cp "$CER_PATH" "/etc/stunnel/backup.cert"
cp "$KEY_PATH" "/etc/stunnel/backup.key"

# 设置文件权限
chmod 600 "/etc/stunnel/stunnel.pem"
chmod 600 "/etc/stunnel/uca.pem"
chmod 600 "/etc/stunnel/backup.cert"
chmod 600 "/etc/stunnel/backup.key"

# 重启相关服务
for service in Qthttpd thttpd stunnel quftp; do
    if [ -f "/etc/init.d/${service}.sh" ]; then
        /etc/init.d/${service}.sh restart
        if [ $? -ne 0 ]; then
            echo "重启服务 ${service} 失败"
        else
            echo "服务 ${service} 已重启"
        fi
    else
        echo "服务脚本 /etc/init.d/${service}.sh 不存在"
    fi
done

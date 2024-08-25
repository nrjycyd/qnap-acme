#!/bin/sh

# 获取脚本所在目录
SCRIPT_DIR=$(dirname "$0")

# 读取配置文件
CONFIG_FILE="$SCRIPT_DIR/config"
if [ -f "$CONFIG_FILE" ]; then
    . "$CONFIG_FILE"
else
    echo "配置文件不存在: $CONFIG_FILE"
    exit 1
fi

# 检查配置文件中的必需变量
if [ -z "$EMAIL" ]; then
    echo "配置文件中缺少 EMAIL 变量"
    exit 1
fi
if [ -z "$DOMAIN" ]; then
    echo "配置文件中缺少 DOMAIN 变量"
    exit 1
fi
if [ -z "$CA" ]; then
    echo "配置文件中缺少 CA 变量"
    exit 1
fi
if [ -z "$DNS" ]; then
    echo "配置文件中缺少 DNS 变量"
    exit 1
fi

# 创建 acme.sh 文件夹
ACME_DIR="$SCRIPT_DIR/acme.sh"
mkdir -p "$ACME_DIR"

# 设置 acme 安装变量
export LE_WORKING_DIR="$ACME_DIR"

# 下载和安装 acme.sh
curl "https://get.acme.sh" | sh -s email="$EMAIL"

# 配置 DNS 环境变量
case "$DNS" in
    "dns_ali")
        if [ -z "$Ali_Key" ] || [ -z "$Ali_Secret" ]; then
            echo "配置文件中缺少 Aliyun 的必要变量"
            exit 1
        fi
        export Ali_Key="$Ali_Key"
        export Ali_Secret="$Ali_Secret"
        ;;
    "dns_cf")
        if [ -z "$CF_Key" ] || [ -z "$CF_Email" ]; then
            echo "配置文件中缺少 Cloudflare 的必要变量"
            exit 1
        fi
        export CF_Key="$CF_Key"
        export CF_Email="$CF_Email"
        ;;
    "dns_dp")
        if [ -z "$DP_Id" ] || [ -z "$DP_Key" ]; then
            echo "配置文件中缺少 DNSPod 的必要变量"
            exit 1
        fi
        export DP_Id="$DP_Id"
        export DP_Key="$DP_Key"
        ;;
    *)
        echo "未知的 DNS 选项: $DNS"
        exit 1
        ;;
esac

# 申请证书
"$ACME_DIR/acme.sh" --issue --server "$CA" --dns "$DNS" -d "$DOMAIN" -d "*.$DOMAIN" --force -k 4096

# 检查证书是否成功申请
if [ $? -eq 0 ]; then
    # 运行续签后的脚本
    "$SCRIPT_DIR/qnap-ser.sh" "$DOMAIN"
else
    echo "证书申请失败"
fi

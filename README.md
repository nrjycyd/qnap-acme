# qnap-acme
威联通 HTTPS 泛域名证书自动化脚本

### 实现效果

自动申请泛域名证书，证书申请成功后替换 QNAP 服务器默认证书；

### 文件说明

- `config` : 配置文件，设置域名、DNS服务商、CA证书环境等；
- `qnap-ser.sh` : 证书替换脚本，不需要手动配置或执行；
- `qnap-acme.sh` : 证书申请脚本，需要手动执行或添加 `cron` 作业；

### 具体操作

1. 将`config`、`qnap-acme.sh`、`qnap-ser.sh`下载到安装目录；
2. 配置`config` 文件；
3. 执行`qnap-acme.sh` 脚本；

### 注意事项

`qnap-ser.sh`脚本主要功能是将成功申请的证书替换到服务器中，需要`admin`权限，所以在执行`qnap-acme.sh`脚本时，建议直接在`admin`环境中执行，否则可能会出现证书申请成功但替换失败的情况；

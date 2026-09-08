# qnap-acme

威联通（QNAP）HTTPS + SSL 泛域名证书自动申请与部署脚本。

## 实现效果

自动申请 Let's Encrypt（或 ZeroSSL、Buypass）泛域名证书，并替换 QNAP 服务器默认证书，实现 NAS 的 HTTPS 访问。

## 文件说明

- `config`：配置文件，设置域名、DNS 服务商、CA 机构、代理等；
- `qnap-acme.sh`：证书申请脚本，需要手动使用 `sudo` 执行或添加到 cron 定时任务；
- `qnap-ser.sh`：证书替换脚本，**由 `qnap-acme.sh` 自动调用，无需手动执行**。

## 具体操作

1. 将 `config`、`qnap-acme.sh`、`qnap-ser.sh` 下载到您希望存放脚本的目录，例如 `/share/Other/acme-ssl/`；

2. 配置 `config` 文件，至少填写以下内容：

   - `EMAIL`：acme 注册邮箱；
   - `DOMAIN`：要申请证书的域名（自动生成该域名及 `*.域名` 的泛域名证书）；
   - `CA`：证书机构，可选 `letsencrypt`、`buypass`、`zerossl`；
   - `DNS`：DNS 服务商，可选 `dns_ali`、`dns_cf`、`dns_dp`，并填写对应的 `Ali_Key`/`Ali_Secret`、`CF_Token`/`CF_Key`/`CF_Email` 或 `DP_Id`/`DP_Key`；
   - `PROXY`（可选）：如需代理下载 acme.sh，填写代理地址，如 `http://127.0.0.1:2222`；留空则直连。

3. 添加脚本执行权限：

   ```bash
   sudo chmod +x /share/Other/acme-ssl/qnap-acme.sh
   sudo chmod +x /share/Other/acme-ssl/qnap-ser.sh
   ```

4. 执行 `qnap-acme.sh` 脚本：

   ```bash
   sudo /share/Other/acme-ssl/qnap-acme.sh
   ```

## 定时自动续签

威联通 cron 服务配置文件：`/etc/config/crontab`

加入定时任务（示例为每月 1 日凌晨 2 点执行）：

```bash
0 2 1 * * /share/Other/acme-ssl/qnap-acme.sh
```

## 注意事项

- 请确认下载到本地的文件具有执行权限（`chmod +x` 或 `sudo chmod +x`），否则会报 `Permission denied`；
- `qnap-ser.sh` 用于将成功申请的证书替换到服务器中，**此过程需要管理员权限**。因此执行 `qnap-acme.sh` 时请务必使用 `sudo` 或在管理员账户下运行；
- 网络环境访问 GitHub 如果较慢或失败，可在 `config` 中配置 `PROXY` 走代理下载 acme.sh；
- 证书续签依赖 ARI（ACME Renewal Info），脚本会自动处理。

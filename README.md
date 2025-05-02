# qnap-acme

威联通 HTTPS+SSL 泛域名证书部署脚本

### 实现效果

自动申请泛域名证书并替换 QNAP 服务器默认证书。

### 文件说明

- `config`: 配置文件，设置域名、DNS 服务商、CA 证书环境等；

- `qnap-ser.sh`: 证书替换脚本，**由 `qnap-acme.sh` 自动调用，无需用户手动配置或执行**；

- `qnap-acme.sh`: 证书申请脚本，需要手动使用 `sudo` 命令执行或添加到 cron 作业；

  > [!NOTE]
  >
  > 威联通 cron 服务配置文件：`/etc/config/crontab`
  >
  > 配置示范：`0 2 1 * * /share/Other/acme-ssl/qnap-acme.sh`

  > [!NOTE]  
  > Highlights information that users should take into account, even when skimming.

### 具体操作

1.  将 `config`、`qnap-acme.sh`、`qnap-ser.sh` 下载到您希望存放脚本的目录，例如 `/share/Other/acme-ssl/`；

2.  配置 `config` 文件；

3.  添加脚本执行权限：

    ```bash
    sudo chmod +x /share/Other/acme-ssl/qnap-acme.sh
    ```

4.  执行 `qnap-acme.sh` 脚本：

    ```bash
    sudo /share/Other/acme-ssl/qnap-acme.sh
    ```

### 注意事项

-   请确认下载到本地的文件具有执行权限 (`chmod +x` 或 `sudo chmod +x`)；
-   `qnap-ser.sh` 脚本用于将成功申请的证书替换到服务器中，**此过程需要管理员权限。因此，执行 `qnap-acme.sh` 脚本时，请务必使用 `sudo` 命令或在管理员账户下运行，以确保证书申请和替换都能成功完成。**

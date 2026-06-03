# 2026-06-03 Fix MySQL Connection URL

## 问题

登录时报错：

```text
com.mysql.cj.jdbc.exceptions.CommunicationsException: Communications link failure
The driver has not received any packets from the server.
```

排查结果：

- `127.0.0.1:3306` 端口可以连通。
- Windows 服务 `MySQL` 显示为 `Running`。
- `mysql.exe -h 127.0.0.1 -P 3306 -uroot -p1234 se` 也在读取初始握手包时断开。
- MySQL 错误日志 `C:\mysql\mysql-8.0.34-winx64\data\lucky.err` 中有：

```text
2026-06-03T01:26:56.426200Z 0 [ERROR] [MY-010283] [Server] Error in accept: 提供了一个无效的参数。
```

说明这次不是 Java SQL 写错，而是 MySQL 服务监听 socket 进入异常状态。

## 本次改动

- 更新 `src/main/java/org/se/util/DBUtil.java` 的 JDBC URL：

```text
jdbc:mysql://127.0.0.1:3306/se?useSSL=false&serverTimezone=Asia/Shanghai&useUnicode=true&characterEncoding=UTF-8&allowPublicKeyRetrieval=true
```

改动点：

- 使用 `127.0.0.1` 避免 `localhost` 解析异常。
- 增加 `allowPublicKeyRetrieval=true`。
- 明确 UTF-8 编码。
- 时区改为 `Asia/Shanghai`。

## 还需要手动处理

当前 Codex 会话没有权限停止或重启 Windows 服务，管理员权限命令失败。

请用“以管理员身份运行”的 PowerShell 执行：

```powershell
Restart-Service MySQL
```

如果仍然无法停止服务，再执行：

```powershell
taskkill /PID 8140 /F
Start-Service MySQL
```

注意：`8140` 是本次排查时监听 3306 的 `mysqld` 进程 ID，如果进程重启过，需要用下面命令重新查：

```powershell
netstat -ano | findstr :3306
```

## 验证

- 已执行 `mvn -q package`，构建通过。
- 已同步新的 `DBUtil.class` 到 exploded artifact。

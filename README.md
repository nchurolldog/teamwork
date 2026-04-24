# Teamwork - SE Information System

## 项目简介
这是一个基于 Java Web 的信息管理系统项目，使用 Servlet + JSP + JDBC 技术栈实现。

## 技术栈及版本

### 开发环境
- **JDK**: 17
- **Maven**: 3.9.10 (apache-maven-3.9.10)
- **Tomcat**: 10.1.52 (apache-tomcat-10.1.52)

### 主要依赖
- **Jakarta Servlet API**: 6.0.0
- **MySQL Connector/J**: 8.0.33
- **Lombok**: 1.18.30

### 数据库
- **MySQL**: 8.x

## 项目结构
```
teamwork/
├── src/
│   ├── main/
│   │   ├── java/org/
│   │   │   ├── example/
│   │   │   │   └── ServletDemo.java          # Servlet 控制器示例
│   │   │   └── se/
│   │   │       ├── controller/                # 控制器层（待扩展）
│   │   │       ├── dao/                       # 数据访问层
│   │   │       │   └── TestDao.java          # 测试数据访问对象
│   │   │       └── model/
│   │   │           ├── entity/                # 实体类
│   │   │           │   └── Test.java         # 测试实体类
│   │   │           └── util/                  # 工具类
│   │   │               └── DbUtil.java       # 数据库连接工具类
│   │   ├── resources/                         # 资源文件目录
│   │   └── webapp/
│   │       ├── WEB-INF/
│   │       │   └── web.xml                   # Web 应用配置文件
│   │       └── index.jsp                     # 首页 JSP
│   └── test/java/                             # 测试代码目录
├── target/                                    # Maven 构建输出目录
├── pom.xml                                    # Maven 项目配置文件
└── README.md                                  # 项目说明文档
```

## 项目模块说明

### 1. 数据访问层 (DAO)
- **TestDao**: 提供数据库查询操作的示例实现
- 使用 JDBC 进行数据库操作
- 通过 PreparedStatement 执行 SQL 查询

### 2. 实体层 (Entity)
- **Test**: 测试实体类，使用 Lombok 简化代码
- 对应数据库中的 test 表

### 3. 工具类 (Util)
- **DbUtil**: 数据库连接管理工具类
- 提供获取和关闭数据库连接的方法
- 配置 MySQL 8.x 驱动和连接参数

### 4. 控制器层 (Controller/Servlet)
- **ServletDemo**: Servlet 示例，处理 HTTP 请求
- 调用 DAO 层获取数据并返回响应

### 5. 视图层 (JSP)
- **index.jsp**: 前端展示页面
- 接收并展示从 Servlet 传递的数据

## 快速开始

### 前置要求
1. 安装 JDK 17
2. 安装 Maven 3.9.10
3. 安装 Tomcat 10.1.52
4. 安装 MySQL 8.x

### 配置步骤
1. **配置数据库**
   - 创建数据库：`testforse`
   - 创建测试表：`test`（包含 id 和 name 字段）
   - 修改 `DbUtil.java` 中的数据库用户名和密码（当前为 root/1234）

2. **构建项目**
   ```bash
   mvn clean package
   ```

3. **部署到 Tomcat**
   - 将生成的 WAR 包部署到 Tomcat 的 webapps 目录
   - 或使用 IDE 配置 Tomcat 服务器运行项目

4. **访问应用**
   - 浏览器访问：`http://localhost:8080/seinformation/`

## 视频教程
本项目参考以下视频教程学习开发：
[Bilibili 视频教程](https://www.bilibili.com/video/BV1RC411x7Uj/?spm_id_from=333.337.search-card.all.click&vd_source=5ed4673c14cfd4e56c06f452e2031f6c)

## 注意事项
- 确保 MySQL 驱动版本与代码中使用的驱动类匹配（使用 `com.mysql.cj.jdbc.Driver`）
- Tomcat 10.x 使用 Jakarta EE 规范，Servlet API 包名为 `jakarta.servlet`
- 数据库连接配置在 `DbUtil.java` 中，请根据实际情况修改
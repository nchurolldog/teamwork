# 2026-06-01 登录入口和角色页面说明

## 本次处理

- 将登录入口从静态 `login.html` 调整为 JSP 入口 `index.jsp`。
- 将原来的管理员仪表盘从 `index.jsp` 移到 `admin.jsp`，因为现在 `index.jsp` 负责登录、学生注册和按角色跳转。
- 保留 `static/html/login.html`，但改成自动跳转到 `../../index.jsp`，避免旧入口绕开 JSP/Servlet 登录逻辑。
- 将 `WEB-INF/web.xml` 升级为 Jakarta Servlet 6.0 命名空间，匹配 Tomcat 10 和 `jakarta.servlet-api 6.0.0`。
- 将数据库连接配置改为：
  - 数据库名：`se`
  - 账号：`root`
  - 密码：`1234`
- 同步修改了项目中两个数据库工具类：
  - `org.se.util.DBUtil`
  - `org.se.model.util.DbUtil`

## 登录和账号规则

- `UserType = 0`：管理员，登录后进入 `admin.jsp`。
- `UserType = 1`：老师，登录后进入 `teacher.jsp`。
- `UserType = 2`：辅导员，登录后进入 `counselor.jsp`。
- `UserType = 3`：学生，登录后进入 `student.jsp`。
- 学生可以在登录页自助创建账号。
- 管理员、老师、辅导员账号不能在登录页注册，只能由管理员在 `admin.jsp` 创建。

## 新增 Servlet

- `LoginServlet`
  - 路径：`/login`
  - 使用 `UsersDAO.login(account, password)` 验证账号密码。
  - 登录成功后把 `currentUser` 放进 session，并按角色跳转。

- `StudentRegisterServlet`
  - 路径：`/studentRegister`
  - 只创建 `UserType = 3` 的学生账号。
  - 如果账号重复或密码确认失败，会返回登录页错误提示。

- `AdminCreateUserServlet`
  - 路径：`/adminCreateUser`
  - 只有 session 中的管理员可以访问。
  - 允许创建管理员、老师、辅导员账号，不允许创建学生账号。

- `LogoutServlet`
  - 路径：`/logout`
  - 清除 session 并返回登录页。

## 新增页面

- `admin.jsp`
  - 管理员页面。
  - 包含原学生统计仪表盘。
  - 新增管理员创建账号区域。

- `student.jsp`
  - 学生页面。
  - 展示个人信息、班级信息、成绩、入党申请状态、奖学金状态、要参加的班会。

- `teacher.jsp`
  - 老师页面。
  - 展示老师个人信息、课程班级、自己的学生、成绩概览。

- `counselor.jsp`
  - 辅导员页面。
  - 展示辅导员个人信息、管理班级、自己的学生、入党申请、奖学金审核和班会。

## 当前限制

- 角色页面目前先完成结构和静态展示数据。
- 后续需要继续把学生、老师、辅导员页面接入对应 DAO 查询，按当前登录账号动态显示真实数据。
- 账号密码仍是明文校验，后续正式使用前建议加密码加密。

## 同步部署

- 已同步 JSP、旧登录跳转页和编译后的 class 到 `out/artifacts/seinformation_war_exploded/`，方便当前 Tomcat 服务直接刷新查看。

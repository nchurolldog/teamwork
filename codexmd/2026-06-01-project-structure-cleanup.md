# 2026-06-01 Project Structure Cleanup

## 本次完成

- 将原本全部堆在 `org.se.controller` 下的 Servlet 按职责拆分为子包：
  - `org.se.controller.auth`
  - `org.se.controller.admin`
  - `org.se.controller.profile`
  - `org.se.controller.scholarship`
  - `org.se.controller.student`

- 保持页面和路由不变：
  - `@WebServlet` 注解路径没有改。
  - JSP 中的表单 `action` 不需要跟着改。

- 新增 `src/main/java/org/se/controller/README.md`，说明 controller 目录职责划分，方便后续继续开发。

## 验证

- 已执行 `mvn -q clean package`，构建通过。
- 已清理 exploded artifact 中旧的 `org/se/controller/*.class`，并同步新的 controller 子包 class。

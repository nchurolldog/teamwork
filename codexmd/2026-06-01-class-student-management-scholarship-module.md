# 班级学生管理与奖学金申请模块

## 本次完成

- 新增老师/辅导员班级学生管理能力。
- 老师和辅导员在 `My Students` 视图中可以：
  - 添加已有学生到自己负责的班级。
  - 从自己负责的班级中删除学生。
  - 修改学生职务：`学生`、`班长`、`学习委员`。
- 后端新增 `ManageClassStudentServlet`：
  - 只允许老师和辅导员访问。
  - 操作前会校验当前用户是否拥有该班级。
  - 防止老师/辅导员改到不属于自己的班级。
- 学生奖学金模块改为三块展示：
  - `Available Scholarships`：可以申请的奖学金。
  - `Applied Scholarships`：已经申请的奖学金。
  - `Published Scholarships`：已公示/已通过的奖学金。
- 学生可以在可申请奖学金中填写申请理由并提交。
- 点击已申请奖学金的 `View Status` 可以查看该申请的当前状态、类型、说明和申请理由。
- 后端新增 `ApplyScholarshipServlet`：
  - 只允许学生提交。
  - 防止同一学生重复申请同一奖学金类型。
  - 新申请默认状态为 `pending`。
- 扩展 `DashboardDao`：
  - 辅导员学生列表补充 `position`。
  - 新增可申请奖学金查询。
  - 新增学生已申请奖学金查询。
  - 新增公示奖学金查询。

## 涉及文件

- `src/main/java/org/se/controller/ManageClassStudentServlet.java`
- `src/main/java/org/se/controller/ApplyScholarshipServlet.java`
- `src/main/java/org/se/model/dao/DashboardDao.java`
- `src/main/webapp/teacher.jsp`
- `src/main/webapp/counselor.jsp`
- `src/main/webapp/student.jsp`

## 验证

- 已执行 `mvn -q package`，编译通过。
- 已同步 JSP 和 class 到 `out/artifacts/seinformation_war_exploded`。
- 已用 MySQL 查询验证：
  - `S001` 仍可申请 `NATIONAL`。
  - `S001` 已申请 `MERIT`，状态为 `approved`。
  - `approved` 奖学金会进入公示列表。

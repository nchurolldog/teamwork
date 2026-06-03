# 2026-06-03 Remove Scholarship Democratic Review And Admin Stats

## 本次完成

- 删除学生奖学金模块中的“民主评议”环节：
  - `student/scholarship.jsp` 不再显示 `Democratic Review Tasks`。
  - 学生奖学金申请页不再展示奖学金民主评议投票提示。
  - `student.jsp` 不再加载 `scholarshipVoteRows`。

- 修改奖学金申请后端流程：
  - `ApplyScholarshipServlet` 新申请状态从 `democratic_review` 改为 `counselor_review`。
  - 提交申请后直接创建 `scholarship_counselor_review` 待审核任务。
  - 不再创建 `scholarship_democratic_review` 和 `scholarship_review_vote` 数据。

- 开发管理员端统计管理数据看板：
  - 新增 `DashboardDao` 管理端统计查询：
    - 用户角色统计
    - 申请状态统计
    - 班级/老师/辅导员/学生数量统计
    - 课程成绩统计
    - 近期奖学金申请
    - 近期入党申请
  - 新增 admin JSP fragment：
    - `admin/management-summary.jsp`
    - `admin/class-summary.jsp`
    - `admin/recent-applications.jsp`
  - 将原静态 `Academic Performance` 替换为真实课程成绩统计。

## 数据处理

- 已将测试数据 `CODX_SA001` 从 `democratic_review` 迁移到 `counselor_review`。
- 已删除对应测试奖学金民主评议投票数据。
- 已将数据库中旧的奖学金 `democratic_review` 状态统一迁移为 `counselor_review`，并为缺少辅导员审核任务的申请补充 `scholarship_counselor_review` 记录。

## 验证

- 已执行 `mvn -q package`，构建通过。
- 已执行 SQL 校验，奖学金申请状态中不再存在 `democratic_review`。
- 已同步 `target/classes/org`、`student.jsp`、`student/`、`admin.jsp`、`admin/` 到 exploded artifact。

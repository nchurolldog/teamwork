# 管理员职位样式与角色页面单一职责调整

## 本次完成

- 管理员 `admin.jsp` 学生表：
  - 将表头 `Status` 改为 `Position`。
  - 学生职位仍显示 `学生`、`学习委员`、`班长`。
  - 三种职位使用不同背景色：
    - `学生`：浅蓝
    - `学习委员`：绿色
    - `班长`：粉色
- 学生 `student.jsp`：
  - 侧边栏切换改成真正的 `view` 页面职责。
  - `Personal` 只显示个人信息。
  - `Class` 只显示班级信息和同班学生。
  - `Grades` 只显示成绩。
  - `Scholarship / Party Application` 只显示申请状态。
  - `Meetings` 只显示班会。
- 老师 `teacher.jsp`：
  - `Personal Info` 视图只显示老师个人信息。
  - `My Students` 视图只显示学生搜索、班级筛选、分页列表。
  - `My Classes` 视图只显示班级列表。
  - `Grades` 视图只显示 Grade Work。
  - `Overview` 保留汇总概览。
- 辅导员 `counselor.jsp`：
  - `Personal Info` 视图只显示辅导员个人信息。
  - `My Students` 视图只显示学生搜索、班级筛选、分页列表。
  - `Classes` 视图只显示管理班级。
  - `Class Meetings` 视图只显示班会。
  - `Party Review / Scholarship` 视图只显示审核队列。
  - `Overview` 保留汇总概览。

## 涉及文件

- `src/main/webapp/admin.jsp`
- `src/main/webapp/student.jsp`
- `src/main/webapp/teacher.jsp`
- `src/main/webapp/counselor.jsp`

## 验证

- 已执行 `mvn -q package`，编译通过。
- 已同步 JSP 到 `out/artifacts/seinformation_war_exploded`。

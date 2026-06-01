# 2026-06-01 老师辅导员侧边栏模板统一说明

## 本次处理

- 将 `teacher.jsp` 改成和学生页一致的侧边栏仪表盘布局。
- 将 `counselor.jsp` 改成和学生页一致的侧边栏仪表盘布局。
- 补回老师和辅导员页面左侧导航栏，不再使用之前的单页卡片布局。
- 新增通用角色页面模板：
  - `src/main/webapp/static/html/role_dashboard_template.html`
- 同步修改到 Tomcat exploded 部署目录，方便当前运行环境刷新查看。

## 老师页面导航

- Overview
- Personal Info
- My Students
- My Classes
- Grades
- Attendance

## 辅导员页面导航

- Overview
- Personal Info
- My Students
- Classes
- Party Review
- Scholarship
- Class Meetings

## 模板用途

`role_dashboard_template.html` 是角色工作台通用 HTML 模板，结构包括：

- 左侧 sidebar
- 顶部标题和账号信息
- 指标卡片
- 个人信息卡片
- 主表格区域

后续新增角色页时，可以复制这个模板，再替换导航项和主内容。

## 验证

- 已运行 `mvn -q package`
- JSP 编译通过

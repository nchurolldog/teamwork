# 2026-06-01 三类角色页面模板说明

## 本次处理

- 新增学生、老师、辅导员三份独立 dashboard 模板。
- 已按实际 `student.jsp`、`teacher.jsp`、`counselor.jsp` 的页面骨架重新提取模板，保持一致的 `.shell`、`.sidebar`、`.content`、`.top`、`.grid`、`.card` 结构。
- 模板只包含：
  - 左侧侧边栏
  - 顶部信息栏
  - 中间 `.main` 占位区域
  - 底部版权栏
- 中间内容没有实现具体业务，只保留 `.card.placeholder` 占位，留给后续开发人员继续填写。

## 新增文件

- `src/main/webapp/static/html/student_dashboard_template.html`
- `src/main/webapp/static/html/teacher_dashboard_template.html`
- `src/main/webapp/static/html/counselor_dashboard_template.html`

## 角色导航差异

### 学生模板

- Personal Info
- Class Info
- Grades
- Party Application
- Scholarship
- Class Meetings
- Attendance

### 老师模板

- Overview
- Personal Info
- My Students
- My Classes
- Grades
- Party Review
- Scholarship Review
- Attendance

### 辅导员模板

- Overview
- Personal Info
- My Students
- Managed Classes
- Party Review
- Scholarship Review
- Class Meetings
- Attendance

## 部署同步

- 已同步三份模板到 `out/artifacts/seinformation_war_exploded/static/html/`。
- 这三份模板不再使用旧的 `.navbarleft/.right/.headinfor` 骨架，避免和实际 JSP 视觉不一致。

## 验证

- 已运行 `mvn -q package`
- 构建通过

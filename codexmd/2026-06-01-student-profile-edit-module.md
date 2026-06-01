# 2026-06-01 学生个人信息编辑模块说明

## 本次处理

- 将 `student.jsp` 的 Personal Info 模块改成动态数据展示。
- 页面通过当前 session 中的 `currentUser.account` 查询：
  - `StudentDAO.findByAccount(...)`
  - `PersonalInfoDao.findById(...)`
- 在 Personal Info 卡片右上角新增 Edit 图标和文字。
- 点击 Edit 后，整个页面出现遮罩层，并显示个人信息编辑表单。
- 表单提交到 `/updateStudentProfile`。
- 保存成功后返回 `student.jsp?profile=saved`。
- 保存失败后返回 `student.jsp?profile=failed`。

## 新增 Servlet

- `UpdateStudentProfileServlet`
  - 路径：`/updateStudentProfile`
  - 只允许 `UserType = 3` 的学生账号访问。
  - 如果当前账号还没有 `student` 记录，会创建一条。
  - 如果已有 `student` 记录，会更新姓名、性别、职务。
  - 会同步创建或更新 `personal_info` 记录。

## 可编辑字段

- Student ID
- Name
- Gender
- Position
- Origin Place
- Political Status

## 涉及文件

- `src/main/webapp/student.jsp`
- `src/main/java/org/se/controller/UpdateStudentProfileServlet.java`
- `codexmd/2026-06-01-student-profile-edit-module.md`

## 验证

- 已运行 `mvn -q package`
- 构建通过
- 已同步到 `out/artifacts/seinformation_war_exploded/`

# 角色个人信息编辑、家庭信息与头像索引

## 本次完成

- 学生个人信息编辑表单新增 `FamilyInfo` 字段：
  - `homeAddress`
  - `familySize`
  - `familyPhone`
- 页面主卡片仍不展示家庭信息，只在编辑弹窗里维护，符合“页面可以不显示”的要求。
- 老师页面和辅导员页面同步新增右上角头像、个人信息卡片 `Edit` 按钮、遮罩编辑弹窗。
- 老师和辅导员编辑表单支持修改工号、姓名、性别，并支持上传头像。
- 学生、老师、辅导员头像统一显示在右上角。
- 没有上传头像时，默认使用 `static/img/maomao.jpg`。
- 头像文件保存到本地 Web 目录：`static/upload/avatars/`。
- 新增头像索引实体与 DAO：
  - `ProfileImage`
  - `ProfileImageDao`
- 新增头像索引表建表语句到 `se.md`：`profile_image`。
- 静态模板同步加入右上角头像和个人信息编辑入口，避免模板和实际 JSP 视觉结构继续偏离。

## 涉及文件

- `src/main/java/org/se/model/entity/ProfileImage.java`
- `src/main/java/org/se/model/dao/ProfileImageDao.java`
- `src/main/java/org/se/controller/ProfileImageSupport.java`
- `src/main/java/org/se/controller/UpdateStudentProfileServlet.java`
- `src/main/java/org/se/controller/UpdateTeacherProfileServlet.java`
- `src/main/java/org/se/controller/UpdateCounselorProfileServlet.java`
- `src/main/java/org/se/model/dao/FamilyInfoDao.java`
- `src/main/webapp/student.jsp`
- `src/main/webapp/teacher.jsp`
- `src/main/webapp/counselor.jsp`
- `src/main/webapp/static/html/student_dashboard_template.html`
- `src/main/webapp/static/html/teacher_dashboard_template.html`
- `src/main/webapp/static/html/counselor_dashboard_template.html`
- `se.md`

## 数据库说明

本次没有直接修改 MySQL 数据库，只在 `se.md` 里补了 `profile_image` 建表语句。需要使用头像上传功能前，需要把该建表语句执行到 `se` 数据库。

## 验证

- 已执行 `mvn -q package`，项目编译通过。
- 已同步 JSP、模板和编译后的 class 到 `out/artifacts/seinformation_war_exploded`。

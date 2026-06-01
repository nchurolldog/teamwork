# 管理员动态面板、学生班级页、老师辅导员学生列表

## 本次完成

- 管理员 `admin.jsp` 动态化：
  - 顶部管理员名称使用当前登录账号。
  - 学生数、老师数、辅导员数、班级数从数据库统计。
  - 学生表从数据库读取学生、班级、平均成绩、头像、职位。
  - Special Programs 增加奖学金与入党申请动态总数提示。
- 学生 `student.jsp` 增加 `Class` 入口：
  - 点击侧边栏 `Class` 会进入 `student.jsp?view=class`。
  - 显示班级名、班主任、辅导员。
  - 显示同班学生列表，包括学号、姓名、职位、性别、班级。
- 老师 `teacher.jsp` 增加视图切换：
  - `Personal Info` 可从侧边栏打开。
  - `My Students` 可从侧边栏打开。
  - 学生列表支持搜索学生姓名/学号。
  - 学生列表支持按班级筛选。
  - 学生列表每页 30 条并带上一页/下一页。
- 辅导员 `counselor.jsp` 增加视图切换：
  - `Personal Info` 可从侧边栏打开。
  - `My Students` 可从侧边栏打开。
  - 学生列表支持搜索学生姓名/学号。
  - 学生列表支持按班级筛选。
  - 学生列表每页 30 条并带上一页/下一页。
- 扩展 `DashboardDao`：
  - 新增学生同班同学查询。
  - 新增老师/辅导员学生分页、搜索、班级筛选查询。
  - 新增管理员统计和首页学生列表查询。

## 涉及文件

- `src/main/java/org/se/model/dao/DashboardDao.java`
- `src/main/webapp/admin.jsp`
- `src/main/webapp/student.jsp`
- `src/main/webapp/teacher.jsp`
- `src/main/webapp/counselor.jsp`

## 验证

- 已执行 `mvn -q package`，编译通过。
- 已在 MySQL 中执行老师学生分页查询，返回 `S001`、`S002`、`S003`。
- 已同步 JSP 和 class 到 `out/artifacts/seinformation_war_exploded`。

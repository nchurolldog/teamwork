# 学生、老师、辅导员动态页面与演示数据

## 本次完成

- 新增 `DashboardDao`，用于 JSP 页面读取跨表动态数据。
- `student.jsp` 改为动态展示：
  - 班级、老师、辅导员信息来自 `student_class`、`class_entity`、`teacher`、`counselor`。
  - 成绩列表来自 `grade` 和 `course`。
  - 入党申请状态来自 `party_application`。
  - 奖学金状态来自 `scholarship_application`。
  - 班会来自 `class_meeting_association` 和 `class_meeting`。
- `teacher.jsp` 改为动态展示：
  - 课程数、学生数、班级数、成绩记录数来自数据库统计。
  - 我的学生表来自老师负责班级下的学生和平均成绩。
  - 我的班级表来自 `class_entity` 和 `student_class`。
- `counselor.jsp` 改为动态展示：
  - 管理班级数、学生数、入党申请数、奖学金评审数来自数据库统计。
  - 我的学生表来自辅导员负责班级下的学生、入党申请和奖学金申请。
  - 班会表来自辅导员负责班级下的班会。

## 插入的演示数据

- 老师账号：`teacher001` / `123456`
- 辅导员账号：`counselor001` / `123456`
- 学生账号：
  - `stu001` / `123456`
  - `stu002` / `123456`
  - `stu003` / `123456`
- 演示班级：
  - `SE-2301`
  - `SE-2302`
- 演示课程：
  - `Data Structures`
  - `Database Systems`
  - `Software Engineering`
- 演示数据包含学生班级关系、选课、成绩、班会、入党申请、奖学金申请、个人信息和家庭信息。

## 涉及文件

- `src/main/java/org/se/model/dao/DashboardDao.java`
- `src/main/webapp/student.jsp`
- `src/main/webapp/teacher.jsp`
- `src/main/webapp/counselor.jsp`

## 验证

- 已执行 `mvn -q package`，项目编译通过。
- 已将 JSP 和编译后的 class 同步到 `out/artifacts/seinformation_war_exploded`。
- 已执行 MySQL 插入脚本，返回 `sample_data_ready`。
- 插入后数据库检查结果：
  - `users`: 9
  - `student`: 4
  - `class_entity`: 2
  - `grade`: 7
  - `class_meeting`: 3

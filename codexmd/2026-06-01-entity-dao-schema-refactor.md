# 2026-06-01 Entity、DAO 和 se.md 重构说明

## 本次处理

- 重构了 `src/main/java/org/se/model/entity` 下部分不合理的 Java 类型。
- 同步修改 DAO 中的 `PreparedStatement` 写入和 `ResultSet` 读取逻辑，保证类型变化后仍能编译。
- 将 DAO 字符串中的表名和字段名统一为小写下划线风格，匹配用户现有数据库命名习惯。
- 新增根目录 `se.md`，整理完整 `se` 数据库建表语句。
- 没有直接执行 SQL，也没有改动真实 MySQL 数据库。

## 主要类型调整

- `student.gender`、`teacher.gender`、`counselor.gender`
  - 从 `String` 改为 `Integer`
  - 对应数据库 `TINYINT`
  - 约定：`0=未知, 1=男, 2=女`

- `attendance_record.attendance_date`
  - Java 从 `java.sql.Date` 改为 `LocalDate`
  - DAO 中用 `java.sql.Date.valueOf(...)` 写入，用 `toLocalDate()` 读取

- `attendance_record.is_absent`
  - Java 从 `int` 改为 `Boolean`
  - DAO 中用 `setBoolean/getBoolean`

- `counselor_approval.result`
  - Java 从 `String` 改为 `Boolean`

- `democratic_review_participant.access`
  - Java 从 `Integer` 改为 `Boolean`

- `class_id`、`record_id`、`family_size`
  - Java 从 primitive `int` 改为 wrapper `Integer`
  - 避免数据库可空字段映射成默认 `0`

- `scholarship_application`
  - 新增 `status` 字段
  - 用于展示学生奖学金申请状态

## DAO 调整

- DAO SQL 表名统一为小写：
  - `Users` -> `users`
  - `Student` -> `student`
  - `ClassEntity` -> `class_entity`
  - `PartyApplication` -> `party_application`
  - 其他同理

- DAO SQL 字段统一为小写下划线：
  - `StudentID` -> `student_id`
  - `EmployeeID` -> `employee_id`
  - `UserType` -> `user_type`
  - `ApplicationID` -> `application_id`
  - 其他同理

## 验证

- 已运行 `mvn -q package`
- 编译通过

## 后续建议

- 后续可以继续把状态字段从 `String` 改成枚举或常量类，避免页面和 DAO 中散落状态字符串。
- 如果数据库已经有旧表，需要按 `se.md` 对照现有结构，决定是迁移数据还是调整建表脚本。

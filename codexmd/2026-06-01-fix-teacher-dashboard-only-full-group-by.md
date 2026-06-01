# 修复老师动态页面 ONLY_FULL_GROUP_BY 报错

## 问题

使用 `teacher001` 打开 `teacher.jsp` 时，MySQL 在 `ONLY_FULL_GROUP_BY` 模式下报错：

- `ORDER BY ce.class_id` 不在 `GROUP BY` 中
- 触发位置：`DashboardDao.findTeacherStudents`

## 本次完成

- 调整 `DashboardDao.findTeacherStudents` 查询字段。
- 将 `ce.class_id` 加入 `SELECT` 和 `GROUP BY`。
- 保留原来的排序：按班级编号和学生编号排序。

## 涉及文件

- `src/main/java/org/se/model/dao/DashboardDao.java`

## 验证

- 已执行 `mvn -q package`，编译通过。
- 已同步 class 到 `out/artifacts/seinformation_war_exploded`。
- 已在 MySQL 中直接执行修复后的查询，返回了 `S001`、`S002`、`S003` 三条老师学生数据。

# 奖学金申请扩展实体、DAO 与 SQL

## 本次完成

- 新增奖学金申请扩展实体：
  - `ScholarshipApplicationDetail`
- 新增奖学金申请扩展 DAO：
  - `ScholarshipApplicationDetailDao`
- 新增数据库表：
  - `scholarship_application_detail`
- 扩展字段包括：
  - `requested_amount`
  - `family_situation`
  - `academic_score`
  - `conduct_evaluation`
  - `honors`
  - `application_reason`
  - `supporting_materials`
  - `promise`
- `ApplyScholarshipServlet` 已改为：
  - `scholarship_application` 保存基础申请数据和状态。
  - `scholarship_application_detail` 保存完整申请材料。
- `DashboardDao` 已改为联查扩展表。
- 学生奖学金详情页显示结构化申请材料。
- 辅导员奖学金审核页显示家庭情况、成绩、操行评价、荣誉和材料说明。

## 涉及文件

- `src/main/java/org/se/model/entity/ScholarshipApplicationDetail.java`
- `src/main/java/org/se/model/dao/ScholarshipApplicationDetailDao.java`
- `src/main/java/org/se/controller/ApplyScholarshipServlet.java`
- `src/main/java/org/se/model/dao/DashboardDao.java`
- `src/main/webapp/student.jsp`
- `src/main/webapp/counselor.jsp`
- `se.md`

## 数据库

- 已将 `scholarship_application_detail` 建表 SQL 写入 `se.md`。
- 已在本地 `se` 数据库执行建表语句，确认表已存在。

## 验证

- 已执行 `mvn -q package`，编译通过。
- 已同步 JSP 和 class 到 `out/artifacts/seinformation_war_exploded`。

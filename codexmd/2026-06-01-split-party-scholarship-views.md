# 拆分入党与奖学金视图

## 本次完成

- 学生页面拆分：
  - `Scholarship` 改为 `student.jsp?view=scholarship`。
  - `Party Application` 改为 `student.jsp?view=party`。
  - 奖学金页面只展示奖学金申请、已申请、公示和状态详情。
  - 入党页面只展示入党申请状态与入党申请记录。
- 辅导员页面拆分：
  - `Party Review` 改为 `counselor.jsp?view=partyReview`。
  - `Scholarship` 改为 `counselor.jsp?view=scholarshipReview`。
  - 入党审核页面只展示入党申请审核列表。
  - 奖学金页面只展示奖学金申请列表。
- `ApplyScholarshipServlet` 的提交后跳转同步改到 `view=scholarship`。
- `DashboardDao` 新增辅导员入党申请列表和奖学金申请列表查询。

## 涉及文件

- `src/main/webapp/student.jsp`
- `src/main/webapp/counselor.jsp`
- `src/main/java/org/se/controller/ApplyScholarshipServlet.java`
- `src/main/java/org/se/model/dao/DashboardDao.java`

## 验证

- 已执行 `mvn -q package`，编译通过。
- 已同步 JSP 和 class 到 `out/artifacts/seinformation_war_exploded`。

# 升级奖学金申请表单

## 本次完成

- 将学生端奖学金申请从简单按钮升级为正式申请表单。
- 新表单包含：
  - 申请人姓名
  - 学号
  - 申请金额
  - 家庭情况
  - GPA / 平均成绩
  - 操行评价
  - 荣誉 / 获奖 / 志愿服务 / 班级贡献
  - 申请理由
  - 支撑材料说明
  - 信息真实性与接受评审公示承诺
- 后端 `ApplyScholarshipServlet` 增加基础校验：
  - 必须选择奖学金类型。
  - 必须填写申请理由、家庭情况、成绩、操行评价。
  - 必须勾选真实性承诺。
  - 仍然防止同一学生重复申请同一奖学金类型。
- 因为当前数据库还没有扩展字段，本次先将扩展申请信息合并写入 `scholarship_application.reason`。
- `amount` 字段已经使用现有 `scholarship_application.amount` 保存申请金额。

## 涉及文件

- `src/main/webapp/student.jsp`
- `src/main/java/org/se/controller/ApplyScholarshipServlet.java`

## 验证

- 已执行 `mvn -q package`，编译通过。
- 已同步 JSP 和 class 到 `out/artifacts/seinformation_war_exploded`。

# 奖学金观察者流程

## 本次完成

- 按观察者模式思想重构奖学金申请流程：
  - 学生提交申请后，不指定处理人。
  - 系统根据班级和角色规则生成后续观察者待办。
- 新增民主评议流程：
  - 申请提交后创建 `scholarship_democratic_review`。
  - 系统自动找同班 `班长`、`学习委员`、`党员` 作为评议观察者。
  - 申请人本人即使符合条件也不会参与自己的评议。
  - 评议人会在自己的学生奖学金页面看到待办。
  - 评议人可以投票并填写意见。
  - 所有人投票后，同意票多则通过，否则拒绝。
- 新增辅导员审核流程：
  - 民主评议通过后自动创建辅导员审核待办。
  - 辅导员在奖学金页面接收待办。
  - 辅导员可以填写意见并同意/拒绝。
- 新增班主任审核流程：
  - 辅导员同意后自动创建班主任审核待办。
  - 老师在 `Scholarship Review` 页面接收待办。
  - 老师可以填写意见并同意/拒绝。
  - 老师同意后申请状态变为 `approved`。

## 新增实体

- `ScholarshipDemocraticReview`
- `ScholarshipReviewVote`
- `ScholarshipCounselorReview`
- `ScholarshipTeacherReview`

## 新增 DAO

- `ScholarshipWorkflowDao`

## 新增 Servlet

- `ScholarshipVoteServlet`
- `ScholarshipCounselorReviewServlet`
- `ScholarshipTeacherReviewServlet`

## 新增数据库表

- `scholarship_democratic_review`
- `scholarship_review_vote`
- `scholarship_counselor_review`
- `scholarship_teacher_review`

## 涉及文件

- `src/main/java/org/se/controller/ApplyScholarshipServlet.java`
- `src/main/java/org/se/controller/ScholarshipVoteServlet.java`
- `src/main/java/org/se/controller/ScholarshipCounselorReviewServlet.java`
- `src/main/java/org/se/controller/ScholarshipTeacherReviewServlet.java`
- `src/main/java/org/se/model/dao/ScholarshipWorkflowDao.java`
- `src/main/webapp/student.jsp`
- `src/main/webapp/counselor.jsp`
- `src/main/webapp/teacher.jsp`
- `se.md`

## 数据库

- 已将建表语句写入 `se.md`。
- 已在本地 `se` 数据库执行建表语句并确认表存在。

## 验证

- 已执行 `mvn -q package`，编译通过。
- 已同步 JSP 和 class 到 `out/artifacts/seinformation_war_exploded`。

# 2026-06-01 Scholarship Selection And Detail Modal

## 本次完成

- 调整 `student.jsp` 的 `Available Scholarships` 区块：
  - 默认只显示一张申请表。
  - 新增奖学金类型选择框，由学生选择要申请的奖学金。
  - 选择不同奖学金时，同步更新当前奖学金说明。

- 给奖学金评议流程补充 `View Detail`：
  - 学生端民主评议任务增加详情按钮。
  - 学生端已申请奖学金增加详情按钮。
  - 辅导员端奖学金评审任务和历史申请增加详情按钮。
  - 老师端奖学金评审任务增加详情按钮。
  - 点击按钮后会出现遮罩弹窗，展示申请编号、申请人、班级、奖学金类型、申请金额、家庭情况、成绩、操行评价、荣誉、申请理由、支撑材料、状态等信息。

- 同步更新 `ScholarshipWorkflowDao`：
  - 民主评议、辅导员评审、老师评审查询都补充读取 `scholarship_application_detail` 中的完整申请表字段。

## 验证

- 已执行 `mvn -q package`，构建通过。
- 已同步 `student.jsp`、`counselor.jsp`、`teacher.jsp` 和编译后的 `WEB-INF/classes` 到 exploded artifact。

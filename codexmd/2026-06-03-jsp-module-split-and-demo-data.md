# 2026-06-03 JSP Module Split And Demo Data

## 本次完成

- 保持原有入口 URL 不变：
  - `admin.jsp`
  - `student.jsp`
  - `teacher.jsp`
  - `counselor.jsp`

- 将大 JSP 按角色和功能拆分为子目录 fragment：
  - `src/main/webapp/student/`
    - `personalinfo.jsp`
    - `classinfo.jsp`
    - `party.jsp`
    - `scholarship.jsp`
    - `grades.jsp`
    - `meetings.jsp`
  - `src/main/webapp/teacher/`
    - `overview.jsp`
    - `personalinfo.jsp`
    - `students.jsp`
    - `classes.jsp`
    - `grades.jsp`
    - `scholarship-review.jsp`
    - `party-review.jsp`
  - `src/main/webapp/counselor/`
    - `overview.jsp`
    - `personalinfo.jsp`
    - `students.jsp`
    - `classes.jsp`
    - `meetings.jsp`
    - `review-queue.jsp`
    - `party-review.jsp`
    - `scholarship-review.jsp`
  - `src/main/webapp/admin/`
    - `metrics.jsp`
    - `create-account.jsp`
    - `performance.jsp`
    - `students.jsp`
    - `class-meetings.jsp`
    - `enrollment-trends.jsp`
    - `attendance-overview.jsp`
    - `special-programs.jsp`

- 入口 JSP 现在主要负责：
  - 鉴权
  - DAO 数据加载
  - 顶部/侧边栏/整体布局
  - 通过静态 include 组合功能 fragment

## 测试数据

已插入一组 `CODX_` / `codex_` 前缀的测试数据，覆盖：

- 老师、辅导员、学生账号
- 班级和班级成员
- 个人信息、家庭信息
- 课程和成绩
- 班会
- 奖学金类型、申请、详情、民主评议、辅导员评审、老师评审
- 入党申请、民主评议、参与投票任务

测试账号：

```text
codex_teacher / 123456
codex_counselor / 123456
codex_student / 123456
codex_monitor / 123456
codex_study / 123456
```

## 验证

- 已执行测试 SQL 插入，结果：
  - `users`: 5
  - `students`: 3
  - `meetings`: 2
  - `scholarships`: 3
  - `party`: 2
- 已执行 `mvn -q package`，构建通过。
- 已同步拆分后的 JSP 文件夹到 exploded artifact。

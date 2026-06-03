# 2026-06-03 Merge Origin Main

## 本次完成

- 在当前分支 `yimu_Branch` 拉取远端更新。
- 将 `origin/main` 合并到当前分支。
- 本次合并是 fast-forward，没有源码冲突。

## main 新增/更新内容概览

- 新增推优入党相关 controller：
  - `org.se.controller.party.ApplyPartyServlet`
  - `org.se.controller.party.StudentPartyVoteServlet`
  - `org.se.controller.party.CounselorPartyReviewServlet`
  - `org.se.controller.party.CounselorDevelopmentInspectionServlet`
  - `org.se.controller.party.CounselorPartyApprovalServlet`
  - `org.se.controller.party.TeacherPartyReviewServlet`

- 新增班会管理相关内容：
  - `org.se.controller.student.ManageClassMeetingServlet`
  - `org.se.model.dao.ClassMeetingDAO`

- 更新页面和 DAO：
  - `admin.jsp`
  - `student.jsp`
  - `teacher.jsp`
  - `counselor.jsp`
  - `DashboardDao`
  - `TeacherDAO`

## 处理说明

- 合并前有一些未跟踪的 exploded artifact 编译产物会阻塞 merge。
- 已将这些生成文件移动到 `.codex-merge-backup/2026-06-03-artifact-classes`，避免覆盖或丢失。
- 合并后已重新执行构建并同步 classes 到 exploded artifact。

## 验证

- 已执行 `git fetch origin`。
- 已执行 `git merge origin/main`，合并成功。
- 已执行 `mvn -q package`，构建通过。
- 已同步 `target/classes/org` 到 `out/artifacts/seinformation_war_exploded/WEB-INF/classes`。

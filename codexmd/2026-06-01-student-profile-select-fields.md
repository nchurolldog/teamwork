# 学生个人信息编辑下拉字段调整

## 本次完成

- 将 `student.jsp` 个人信息编辑弹窗里的 `Position` 从文本输入框改为下拉选择。
- 下拉选项为：`学生`、`班长`、`学习委员`。
- 将 `Political Status` 从文本输入框改为下拉选择。
- 下拉选项为：`团员`、`党员`、`群众`。
- 保留原有动态回显逻辑，已有值会自动选中对应选项。

## 涉及文件

- `src/main/webapp/student.jsp`
- `out/artifacts/seinformation_war_exploded/student.jsp`

## 验证

- 已执行 `mvn -q package`，项目编译通过。
- 已同步 JSP 到 Tomcat exploded artifact，刷新当前页面即可看到新表单控件。

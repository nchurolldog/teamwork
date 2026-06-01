# 2026-06-01 首页布局修复记录

## 本次处理

- 修复 `index.jsp` 顶部栏和底部版权栏被浏览器视口遮挡的问题。
- 问题原因是基础样式 `templatetest.css` 给 `html` 设置了 flex 居中，首页整体高度又超过视口后会被居中裁切。
- 在 `src/main/webapp/index.jsp` 中覆盖 `html` 的布局方式，改为普通块级根布局，并限制页面为视口高度。
- 将左侧导航、右侧主体、顶部栏、内容区、底部栏调整为后台应用常见的满屏布局：顶部和底部固定在应用框架内，中间内容区滚动。
- 同步修改了 Tomcat 当前使用的部署副本 `out/artifacts/seinformation_war_exploded/index.jsp`，方便刷新浏览器立即看到效果。

## 涉及文件

- `src/main/webapp/index.jsp`
- `out/artifacts/seinformation_war_exploded/index.jsp`
- `codexmd/2026-06-01-index-login-layout-fix.md`

## 验证建议

- 刷新 `http://localhost:8080/seinformation/`。
- 检查左上角 Logo、顶部标题栏、底部 Copyright 是否完整可见。
- 如果 Tomcat 没有热更新部署副本，可以重新部署或重启 Tomcat 后再刷新。

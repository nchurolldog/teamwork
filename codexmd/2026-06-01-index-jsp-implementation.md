# 2026-06-01 index.jsp 首页实现说明

## 本次实现内容

- 将原来的占位 `index.jsp` 改成学生信息管理首页。
- 页面整体参考用户提供的后台仪表盘截图，使用左侧导航、顶部信息栏、中间数据区域、右侧统计区域、底部版权栏的结构。
- 复用了项目已有的基础 CSS：
  - `static/css/templatetest.css`
  - `static/css/mycss.css`
- 在 `index.jsp` 内补充页面专用样式，用于实现首页布局、卡片、图表、表格和响应式适配。

## 页面结构

- 左侧导航栏：
  - Logo
  - Dashboard、Inbox、Calendar、Teachers、Students、Attendance、Scholarship、Community 等入口
  - Students 当前高亮
  - 底部工具提示卡片和 Logout

- 顶部信息栏：
  - 当前页面标题 `Students`
  - 面包屑 `Dashboard / Students`
  - 搜索框
  - 设置和通知按钮
  - 用户头像和管理员身份

- 主内容区域：
  - 四个学生统计卡片：
    - Total Students
    - Grade 7 Students
    - Grade 8 Students
    - Grade 9 Students
  - Academic Performance 柱状图区域
  - Students 学生列表表格

- 右侧区域：
  - Enrollment Trends 折线趋势图
  - Attendance Overview 出勤概览
  - Special Programs 项目列表

- 底部区域：
  - Copyright
  - Privacy Policy
  - Terms of Service
  - 社交图标

## 交互逻辑

- 左侧菜单点击后会切换当前高亮状态。
- Logout 点击后跳转到 `static/html/login.html`。
- 当前页面的数据是静态展示数据，后续可以再接入 DAO、Servlet 或 JSP 动态数据。

## 使用资源

- 图标使用 Font Awesome。
- 图片资源来自项目已有目录 `src/main/webapp/static/img/`。
- 当前使用到的主要图片包括：
  - `favicon.ico`
  - `money.png`
  - `maomao.jpg`
  - `left-ilu.png`
  - `right-ilu.webp`

## 注意事项

- 这个页面目前主要完成前端静态展示，还没有和后端登录态、学生 DAO、Servlet 查询接口绑定。
- 因为项目基础 CSS 中 `html` 原本设置了 flex 居中，后续已在首页样式里覆盖为普通块布局，避免顶部和底部被视口裁切。
- 如果通过 Tomcat 访问页面，需要确认部署目录中的 `index.jsp` 已同步更新。

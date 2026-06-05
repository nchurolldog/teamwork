<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.se.model.entity.Users" %>
<%
  Users currentUser = (Users) session.getAttribute("currentUser");
  if (currentUser != null && currentUser.getUserType() != null) {
    int type = currentUser.getUserType();
    if (type == 0) {
      response.sendRedirect("admin.jsp");
      return;
    } else if (type == 1) {
      response.sendRedirect("teacher.jsp");
      return;
    } else if (type == 2) {
      response.sendRedirect("counselor.jsp");
      return;
    } else {
      response.sendRedirect("student.jsp");
      return;
    }
  }
  String error = request.getParameter("error");
  String success = request.getParameter("success");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>SEInformation - 登录</title>
  <script src="https://kit.fontawesome.com/b81ce93c93.js" crossorigin="anonymous"></script>
  <link rel="shortcut icon" href="static/img/favicon.ico" type="image/x-icon">
  <style>
    :root {
      --ink: #12345a;
      --muted: #718195;
      --line: #eaf0f4;
      --cyan: #ceebf1;
      --pink: #ffcafe;
      --navy: #0d4a78;
      --surface: #ffffff;
      --page: #eef4f7;
    }

    * {
      box-sizing: border-box;
    }

    body {
      margin: 0;
      min-height: 100vh;
      display: grid;
      place-items: center;
      padding: 28px;
      font-family: "Microsoft YaHei", "PingFang SC", "Helvetica Neue", Arial, sans-serif;
      color: var(--ink);
      background:
        radial-gradient(circle at 18% 18%, rgba(206, 235, 241, .95), transparent 28%),
        radial-gradient(circle at 78% 14%, rgba(255, 202, 254, .75), transparent 23%),
        linear-gradient(135deg, #f8fbfc, var(--page));
    }

    .login-shell {
      width: min(1120px, 100%);
      min-height: 720px;
      display: grid;
      grid-template-columns: minmax(380px, .88fr) minmax(440px, 1.12fr);
      background: rgba(255, 255, 255, .86);
      border-radius: 22px;
      overflow: hidden;
      box-shadow: 0 28px 90px rgba(24, 45, 74, .18);
      position: relative;
    }

    .form-pane {
      padding: 58px;
      background: var(--surface);
      display: flex;
      flex-direction: column;
      justify-content: center;
      transition: opacity .45s ease, transform .45s ease;
      z-index: 2;
    }

    .brand {
      display: flex;
      align-items: center;
      gap: 10px;
      margin-bottom: 46px;
      font-weight: 800;
    }

    .brand img {
      width: 34px;
      height: 34px;
      border-radius: 10px;
    }

    h1 {
      margin: 0;
      font-size: clamp(34px, 4vw, 50px);
      line-height: 1.05;
    }

    .tips {
      margin: 18px 0 28px;
      color: var(--muted);
      font-size: 15px;
      line-height: 1.7;
    }

    .field {
      display: flex;
      align-items: center;
      gap: 12px;
      height: 52px;
      padding: 0 16px;
      border: 1px solid var(--line);
      border-radius: 8px;
      margin-bottom: 14px;
      background: #fbfcfd;
      color: #8a98a6;
    }

    .field input {
      width: 100%;
      border: 0;
      outline: 0;
      background: transparent;
      color: var(--ink);
      font: inherit;
    }

    .message {
      padding: 11px 14px;
      border-radius: 8px;
      margin: 0 0 16px;
      font-size: 13px;
      line-height: 1.5;
    }

    .message.error {
      background: #ffe7ee;
      color: #9b2849;
    }

    .message.success {
      background: #e6f8f0;
      color: #177a59;
    }

    .form-row {
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 12px;
      margin-top: 6px;
      color: var(--muted);
      font-size: 14px;
    }

    .remember {
      display: inline-flex;
      align-items: center;
      gap: 8px;
    }

    .remember input {
      accent-color: var(--navy);
      width: 16px;
      height: 16px;
    }

    a {
      color: var(--navy);
      text-decoration: none;
      font-weight: 700;
    }

    .primary-button {
      width: 100%;
      height: 52px;
      margin-top: 30px;
      border: 0;
      border-radius: 8px;
      background: var(--pink);
      color: var(--ink);
      font-weight: 800;
      font-size: 15px;
      cursor: pointer;
      transition: transform .2s ease, background .2s ease;
    }

    .primary-button:hover {
      background: #f7b8f4;
      transform: translateY(-1px);
    }

    .switch-copy {
      margin: 28px 0 0;
      color: var(--muted);
      text-align: center;
      font-size: 14px;
    }

    .visual-pane {
      position: relative;
      padding: 28px;
      background: linear-gradient(145deg, var(--cyan), #f7fbfd 48%, var(--pink));
      display: grid;
      place-items: center;
      overflow: hidden;
    }

    .preview-card {
      width: min(520px, 100%);
      border-radius: 18px;
      background: rgba(255, 255, 255, .82);
      padding: 20px;
      box-shadow: 0 24px 70px rgba(13, 74, 120, .18);
      position: relative;
      z-index: 1;
    }

    .preview-card img {
      width: 100%;
      aspect-ratio: 16 / 11;
      object-fit: cover;
      border-radius: 12px;
      display: block;
    }

    .mini-stats {
      display: grid;
      grid-template-columns: repeat(3, 1fr);
      gap: 12px;
      margin-top: 14px;
    }

    .mini-stat {
      min-height: 74px;
      border-radius: 8px;
      padding: 12px;
      background: var(--surface);
      border: 1px solid var(--line);
    }

    .mini-stat:first-child {
      background: var(--cyan);
    }

    .mini-stat strong {
      display: block;
      font-size: 24px;
      margin-bottom: 6px;
    }

    .mini-stat span {
      color: var(--muted);
      font-size: 12px;
    }

    .signup-pane {
      position: absolute;
      inset: 0;
      display: grid;
      grid-template-columns: minmax(440px, 1.12fr) minmax(380px, .88fr);
      opacity: 0;
      transform: translateX(28px);
      pointer-events: none;
      transition: opacity .45s ease, transform .45s ease;
      z-index: 4;
    }

    .signup-pane.show {
      opacity: 1;
      transform: translateX(0);
      pointer-events: auto;
    }

    .login-shell.signup-mode > .form-pane,
    .login-shell.signup-mode > .visual-pane {
      opacity: 0;
      transform: translateX(-22px);
      pointer-events: none;
    }

    .role-note {
      margin-top: 12px;
      color: var(--muted);
      font-size: 12px;
      line-height: 1.6;
    }

    @media (max-width: 920px) {
      body {
        padding: 0;
      }

      .login-shell,
      .signup-pane {
        width: 100%;
        min-height: 100vh;
        border-radius: 0;
        grid-template-columns: 1fr;
      }

      .visual-pane {
        display: none;
      }

      .form-pane {
        padding: 34px 22px;
      }
    }
  </style>
</head>
<body>
  <main class="login-shell" id="loginShell">
    <section class="form-pane">
      <div class="brand">
        <img src="static/img/favicon.ico" alt="SEInformation logo">
        <span>SEInformation</span>
      </div>

      <h1>你好,<br>欢迎回来</h1>
      <p class="tips">请登录以进入您的工作空间.</p>

      <% if ("invalid".equals(error)) { %>
        <div class="message error">账号或密码错误，请重新输入。</div>
      <% } else if ("duplicate".equals(error)) { %>
        <div class="message error">账号已存在，请换一个学生账号。</div>
      <% } else if ("registerFailed".equals(error)) { %>
        <div class="message error">学生账号创建失败，请确认数据库 Users 表可用。</div>
      <% } else if ("studentRegistered".equals(success)) { %>
        <div class="message success">学生账号创建成功，请登录。</div>
      <% } %>

      <form action="login" method="post">
        <label class="field">
          <i class="fas fa-user"></i>
          <input type="text" name="account" placeholder="Account" required>
        </label>
        <label class="field">
          <i class="fas fa-lock"></i>
          <input type="password" name="password" placeholder="Password" required>
        </label>
        <div class="form-row">
          <label class="remember">
            <input type="checkbox" name="remember">
            <span>记住我</span>
          </label>
          <a href="#">忘记密码?</a>
        </div>
        <button class="primary-button" type="submit">登录</button>
      </form>

      <p class="switch-copy">没有学生账号? <a href="#" id="showSignup">创建学生账号</a></p>
      <p class="role-note">教师、辅导员和管理员账号只能由管理员创建。</p>
    </section>

    <section class="visual-pane">
      <div class="preview-card">
        <img src="static/img/template_small.jpg" alt="Student dashboard preview">
        <div class="mini-stats">
          <div class="mini-stat"><strong>1,245</strong><span>学生总数</span></div>
          <div class="mini-stat"><strong>410</strong><span>大一</span></div>
          <div class="mini-stat"><strong>97%</strong><span>出勤率</span></div>
        </div>
      </div>
    </section>

    <section class="signup-pane" id="signupPane">
      <div class="visual-pane">
        <div class="preview-card">
          <img src="static/img/left-ilu.png" alt="Create account illustration">
          <div class="mini-stats">
            <div class="mini-stat"><strong>3</strong><span>Personal Info</span></div>
            <div class="mini-stat"><strong>5</strong><span>Applications</span></div>
            <div class="mini-stat"><strong>24h</strong><span>Campus Data</span></div>
          </div>
        </div>
      </div>

      <section class="form-pane">
        <div class="brand">
          <img src="static/img/favicon.ico" alt="SEInformation logo">
          <span>SEInformation</span>
        </div>

        <h1>创建<br>学生账号</h1>
        <p class="tips">只有学生可以在此注册。其他角色由管理员创建。</p>

        <form action="studentRegister" method="post">
          <label class="field">
            <i class="fas fa-user"></i>
            <input type="text" name="account" placeholder="学生账号" required>
          </label>
          <label class="field">
            <i class="fas fa-lock"></i>
            <input type="password" name="password" placeholder="密码" required>
          </label>
          <label class="field">
            <i class="fas fa-shield-alt"></i>
            <input type="password" name="confirmPassword" placeholder="确认密码" required>
          </label>
          <button class="primary-button" type="submit">创建学生账号</button>
        </form>

        <p class="switch-copy">已有账号? <a href="#" id="showLogin">登录</a></p>
      </section>
    </section>
  </main>

  <script>
    var shell = document.getElementById('loginShell');
    var signupPane = document.getElementById('signupPane');
    var showSignup = document.getElementById('showSignup');
    var showLogin = document.getElementById('showLogin');

    showSignup.addEventListener('click', function(event) {
      event.preventDefault();
      shell.classList.add('signup-mode');
      signupPane.classList.add('show');
    });

    showLogin.addEventListener('click', function(event) {
      event.preventDefault();
      signupPane.classList.remove('show');
      shell.classList.remove('signup-mode');
    });
  </script>
</body>
</html>

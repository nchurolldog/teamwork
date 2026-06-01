<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.se.model.entity.Users" %>
<%
  Users currentUser = (Users) session.getAttribute("currentUser");
  if (currentUser == null) {
    response.sendRedirect("index.jsp");
    return;
  }
  if (currentUser.getUserType() == null || currentUser.getUserType() != 0) {
    response.sendRedirect("student.jsp");
    return;
  }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>SEInformation - Admin</title>
  <script src="https://kit.fontawesome.com/b81ce93c93.js" crossorigin="anonymous"></script>
  <link rel="shortcut icon" href="static/img/favicon.ico" type="image/x-icon">
  <link rel="stylesheet" href="static/css/templatetest.css">
  <link rel="stylesheet" href="static/css/mycss.css">
  <style>
    :root {
      --ink: #12345a;
      --muted: #7b8795;
      --line: #edf1f5;
      --cyan: #ceebf1;
      --pink: #ffcafe;
      --navy: #0d4a78;
      --surface: #ffffff;
      --page: #f5f7f8;
    }

    html {
      background:
        radial-gradient(circle at 16% 10%, rgba(206, 235, 241, .9), transparent 28%),
        radial-gradient(circle at 86% 0%, rgba(255, 202, 254, .62), transparent 22%),
        #eef4f7;
      display: block;
      height: 100%;
      overflow: hidden;
    }

    body {
      width: min(1440px, calc(100vw - 32px));
      min-height: 0;
      height: calc(100vh - 32px);
      margin: 16px auto;
      overflow: hidden;
      color: var(--ink);
      border-radius: 22px;
      box-shadow: 0 24px 80px rgba(24, 45, 74, .16);
      background: var(--surface);
    }

    .navbarleft {
      width: 230px;
      height: 100%;
      min-height: 0;
      box-shadow: none;
      border-right: 1px solid var(--line);
      flex-shrink: 0;
    }

    .logo-header {
      border-bottom: 0;
      color: var(--ink);
    }

    .logo-header img {
      border-radius: 9px;
    }

    .selectionlink {
      border-radius: 8px;
      color: #536271;
    }

    .selectionlink.active {
      background: var(--pink);
      color: var(--ink);
    }

    .right {
      background: var(--page);
      height: 100%;
      min-height: 0;
      overflow: hidden;
    }

    .headinfor {
      height: 78px;
      background: var(--surface);
      border-bottom: 1px solid var(--line);
      flex-shrink: 0;
    }

    .page-title {
      font-size: 24px;
      font-weight: 800;
      letter-spacing: 0;
    }

    .page-breadcrumb {
      color: #8ba0ad;
    }

    .main {
      padding: 20px;
      display: grid;
      grid-template-columns: minmax(0, 1.45fr) minmax(320px, .75fr);
      gap: 20px;
      min-height: 0;
    }

    .dashboard-left,
    .dashboard-right {
      display: flex;
      flex-direction: column;
      gap: 18px;
      min-width: 0;
    }

    .metrics {
      display: grid;
      grid-template-columns: repeat(4, minmax(130px, 1fr));
      gap: 16px;
    }

    .metric-card,
    .panel,
    .student-table,
    .program-card {
      background: var(--surface);
      border-radius: 8px;
      box-shadow: 0 10px 28px rgba(20, 48, 78, .06);
      border: 1px solid rgba(237, 241, 245, .9);
    }

    .metric-card {
      min-height: 110px;
      padding: 18px;
      display: flex;
      flex-direction: column;
      justify-content: space-between;
      position: relative;
    }

    .metric-card.featured {
      background: var(--cyan);
    }

    .metric-card strong {
      font-size: 28px;
      line-height: 1;
    }

    .metric-card span {
      color: #657486;
      font-size: 13px;
    }

    .metric-icon {
      width: 34px;
      height: 34px;
      display: grid;
      place-items: center;
      border-radius: 50%;
      background: var(--pink);
      color: var(--ink);
      position: absolute;
      right: 16px;
      top: 16px;
    }

    .metric-card:nth-child(3) .metric-icon {
      background: var(--navy);
      color: white;
    }

    .panel {
      padding: 18px;
    }

    .panel-head,
    .table-head,
    .program-head {
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 12px;
      margin-bottom: 14px;
    }

    .panel-title,
    .table-title,
    .program-title {
      font-size: 16px;
      font-weight: 800;
      color: var(--ink);
    }

    .panel select,
    .table-head select {
      border: 0;
      padding: 8px 10px;
      border-radius: 6px;
      font-size: 12px;
    }

    .chart-grid {
      height: 205px;
      display: grid;
      grid-template-columns: repeat(6, 1fr);
      align-items: end;
      gap: 18px;
      padding: 24px 6px 4px;
      background: repeating-linear-gradient(to top, transparent 0, transparent 39px, #eef2f5 40px);
    }

    .bar-group {
      height: 100%;
      display: flex;
      align-items: end;
      justify-content: center;
      gap: 6px;
      position: relative;
    }

    .bar-group::after {
      content: attr(data-month);
      position: absolute;
      bottom: -22px;
      color: #8b98a6;
      font-size: 11px;
    }

    .bar {
      width: 14px;
      border-radius: 8px 8px 0 0;
      background: var(--cyan);
      min-height: 34px;
    }

    .bar.alt {
      background: var(--pink);
    }

    .trend {
      height: 210px;
      position: relative;
      overflow: hidden;
      border-radius: 8px;
      background:
        linear-gradient(to bottom, transparent 0, transparent 74%, rgba(255, 202, 254, .36) 100%),
        repeating-linear-gradient(to top, transparent 0, transparent 41px, #eef2f5 42px);
    }

    .trend svg {
      width: 100%;
      height: 100%;
    }

    .attendance-bars {
      height: 185px;
      display: grid;
      grid-template-columns: repeat(5, 1fr);
      gap: 13px;
      align-items: end;
      background: repeating-linear-gradient(to top, transparent 0, transparent 35px, #eef2f5 36px);
      padding-top: 18px;
    }

    .attendance-item {
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 8px;
      color: #8b98a6;
      font-size: 11px;
    }

    .attendance-bar {
      width: 100%;
      max-width: 42px;
      height: var(--h);
      background: linear-gradient(to top, rgba(255, 202, 254, .65), rgba(206, 235, 241, .95));
      border-top: 3px solid var(--navy);
      border-radius: 7px 7px 0 0;
      position: relative;
    }

    .attendance-bar::before {
      content: attr(data-value);
      position: absolute;
      top: -20px;
      left: 50%;
      transform: translateX(-50%);
      color: var(--ink);
      font-weight: 700;
      font-size: 11px;
      white-space: nowrap;
    }

    .student-table {
      overflow: hidden;
    }

    .table-head {
      padding: 18px 18px 0;
    }

    .table-tools {
      display: flex;
      gap: 8px;
      align-items: center;
    }

    .table-tools input {
      border: 1px solid var(--line);
      padding: 8px 12px;
      border-radius: 6px;
      min-width: 210px;
      color: #536271;
    }

    .add-student {
      border: 0;
      padding: 8px 12px;
      border-radius: 6px;
      font-weight: 700;
      cursor: pointer;
    }

    table {
      width: 100%;
      border-collapse: collapse;
      font-size: 13px;
    }

    th,
    td {
      padding: 13px 18px;
      text-align: left;
      border-bottom: 1px solid var(--line);
    }

    th {
      color: #8391a1;
      font-size: 11px;
      font-weight: 700;
    }

    .student-name {
      display: flex;
      align-items: center;
      gap: 10px;
      font-weight: 700;
      color: var(--ink);
    }

    .avatar {
      width: 30px;
      height: 30px;
      border-radius: 50%;
      object-fit: cover;
      background: var(--pink);
    }

    .pill {
      display: inline-flex;
      align-items: center;
      padding: 5px 9px;
      border-radius: 999px;
      font-size: 11px;
      font-weight: 700;
      background: rgba(206, 235, 241, .8);
      color: var(--navy);
    }

    .pill.active {
      background: #65d7af;
      color: white;
    }

    .pill.leave {
      background: var(--navy);
      color: white;
    }

    .program-list {
      display: flex;
      flex-direction: column;
      gap: 10px;
    }

    .program-card {
      padding: 14px;
      display: grid;
      grid-template-columns: 40px 1fr auto;
      align-items: center;
      gap: 12px;
    }

    .program-card img {
      width: 40px;
      height: 40px;
      border-radius: 50%;
      object-fit: cover;
    }

    .program-card strong {
      display: block;
      font-size: 13px;
    }

    .program-card span {
      display: block;
      color: #708092;
      font-size: 11px;
      margin-top: 3px;
    }

    .program-tag {
      color: #0797ad;
      font-weight: 800;
      font-size: 12px;
      white-space: nowrap;
    }

    .copyright {
      min-height: 50px;
      height: auto;
      flex-shrink: 0;
    }

    @media (max-width: 1180px) {
      body {
        width: 100vw;
        min-height: 100vh;
        margin: 0;
        border-radius: 0;
      }

      .navbarleft {
        display: none;
      }

      .right {
        min-height: 100vh;
      }

      .main {
        grid-template-columns: 1fr;
      }
    }

    @media (max-width: 760px) {
      .headinfor {
        height: auto;
        padding: 16px 0;
        align-items: flex-start;
      }

      .userprofile {
        display: none;
      }

      .metrics {
        grid-template-columns: repeat(2, minmax(0, 1fr));
      }

      .table-tools input,
      .table-tools select,
      .add-student {
        display: none;
      }

      .student-table {
        overflow-x: auto;
      }

      table {
        min-width: 760px;
      }

      .copyright {
        display: none;
      }
    }
  </style>
</head>
<body>
  <div class="navbarleft">
    <div class="logo-header">
      <img src="static/img/favicon.ico" alt="Logo"><span>SEInformation</span>
    </div>
    <div class="maincontent">
      <div class="links">
        <div class="selectionlink"><i class="fas fa-home"></i><span>Dashboard</span></div>
        <div class="selectionlink"><i class="fas fa-inbox"></i><span>Inbox</span></div>
        <div class="selectionlink"><i class="fas fa-calendar"></i><span>Calendar</span></div>
        <div class="selectionlink"><i class="fas fa-chalkboard-teacher"></i><span>Teachers</span></div>
        <div class="selectionlink active"><i class="fas fa-user-graduate"></i><span>Students</span></div>
        <div class="selectionlink"><i class="fas fa-calendar-check"></i><span>Attendance</span></div>
        <div class="selectionlink"><i class="fas fa-coins"></i><span>Scholarship</span></div>
        <div class="selectionlink"><i class="fas fa-users"></i><span>Community</span></div>
      </div>
    </div>
    <div class="cardandlogout">
      <div class="card">
        <div class="cardicon"><img src="static/img/money.png" alt="Card Icon"></div>
        <div class="cardtext">
          <h1>New Tools Available</h1>
          <p>Smarter updates for easier school management</p>
          <button type="button">See Updates</button>
        </div>
      </div>
      <div class="logout">
        <i class="fas fa-sign-out-alt"></i><span>Logout</span>
      </div>
    </div>
  </div>

  <div class="right">
    <div class="headinfor">
      <div class="currentpage">
        <div class="page-title">Students</div>
        <div class="page-breadcrumb">Dashboard / Students</div>
      </div>
      <div class="userprofile">
        <div class="searchbar">
          <label for="search"><i class="fas fa-search"></i></label>
          <input type="text" id="search" placeholder="Search anything">
        </div>
        <button class="normalbutton" type="button" aria-label="Settings"><i class="fas fa-cog"></i></button>
        <button class="normalbutton" type="button" aria-label="Notifications"><i class="fas fa-bell"></i></button>
        <div class="photoandname">
          <div class="photo"><img src="static/img/maomao.jpg" alt="Profile Photo"></div>
          <div class="nameandposition">
            <div class="name">Yimu Yang</div>
            <div class="position">Administrator</div>
          </div>
        </div>
      </div>
    </div>

    <main class="main">
      <section class="dashboard-left">
        <div class="metrics">
          <article class="metric-card featured">
            <div class="metric-icon"><i class="fas fa-users"></i></div>
            <strong>1,245</strong>
            <span>Total Students</span>
          </article>
          <article class="metric-card">
            <div class="metric-icon"><i class="fas fa-compass"></i></div>
            <strong>410</strong>
            <span>Grade 7 Students</span>
          </article>
          <article class="metric-card">
            <div class="metric-icon"><i class="fas fa-award"></i></div>
            <strong>415</strong>
            <span>Grade 8 Students</span>
          </article>
          <article class="metric-card">
            <div class="metric-icon"><i class="fas fa-lightbulb"></i></div>
            <strong>420</strong>
            <span>Grade 9 Students</span>
          </article>
        </div>

        <section class="panel">
          <div class="panel-head">
            <div class="panel-title">Create Staff Account</div>
            <span class="pill">Admin Only</span>
          </div>
          <form action="adminCreateUser" method="post" class="table-tools" style="flex-wrap: wrap;">
            <input type="text" name="account" placeholder="Account" required>
            <input type="password" name="password" placeholder="Password" required>
            <select name="userType" aria-label="User role" required>
              <option value="1">Teacher</option>
              <option value="2">Counselor</option>
              <option value="0">Administrator</option>
            </select>
            <button class="add-student" type="submit">+ Create Account</button>
          </form>
          <p style="margin: 12px 0 0; color: #708092; font-size: 12px;">Students create their own accounts from the login page. Teacher, counselor, and administrator accounts can only be created here.</p>
        </section>

        <section class="panel">
          <div class="panel-head">
            <div class="panel-title">Academic Performance</div>
            <select aria-label="Performance period">
              <option>Last Semester</option>
            </select>
          </div>
          <div class="chart-grid" aria-label="Academic performance chart">
            <div class="bar-group" data-month="Jul"><span class="bar" style="height: 88%"></span><span class="bar alt" style="height: 76%"></span></div>
            <div class="bar-group" data-month="Aug"><span class="bar" style="height: 84%"></span><span class="bar alt" style="height: 72%"></span></div>
            <div class="bar-group" data-month="Sep"><span class="bar" style="height: 79%"></span><span class="bar alt" style="height: 68%"></span></div>
            <div class="bar-group" data-month="Oct"><span class="bar" style="height: 83%"></span><span class="bar alt" style="height: 77%"></span></div>
            <div class="bar-group" data-month="Nov"><span class="bar" style="height: 90%"></span><span class="bar alt" style="height: 82%"></span></div>
            <div class="bar-group" data-month="Dec"><span class="bar" style="height: 95%"></span><span class="bar alt" style="height: 88%"></span></div>
          </div>
        </section>

        <section class="student-table">
          <div class="table-head">
            <div class="table-title">Students</div>
            <div class="table-tools">
              <input type="search" placeholder="Search for a student">
              <select aria-label="Student status">
                <option>All Status</option>
              </select>
              <button class="add-student" type="button">+ Add Student</button>
            </div>
          </div>
          <table>
            <thead>
              <tr>
                <th>Student</th>
                <th>Class</th>
                <th>GPA</th>
                <th>Performance</th>
                <th>Attendance</th>
                <th>Status</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td><div class="student-name"><img class="avatar" src="static/img/maomao.jpg" alt="">Michael Chen</div></td>
                <td>7A</td>
                <td>3.8</td>
                <td><span class="pill">Good</span></td>
                <td>95%</td>
                <td><span class="pill active">Active</span></td>
              </tr>
              <tr>
                <td><div class="student-name"><img class="avatar" src="static/img/left-ilu.png" alt="">Emma Williams</div></td>
                <td>7B</td>
                <td>2.9</td>
                <td><span class="pill">Needs Support</span></td>
                <td>87%</td>
                <td><span class="pill active">Active</span></td>
              </tr>
              <tr>
                <td><div class="student-name"><img class="avatar" src="static/img/right-ilu.webp" alt="">Rajesh Kumar</div></td>
                <td>7C</td>
                <td>2.4</td>
                <td><span class="pill">At Risk</span></td>
                <td>72%</td>
                <td><span class="pill leave">On Leave</span></td>
              </tr>
              <tr>
                <td><div class="student-name"><img class="avatar" src="static/img/maomao.jpg" alt="">Isabella Rossi</div></td>
                <td>8C</td>
                <td>3.9</td>
                <td><span class="pill">Good</span></td>
                <td>97%</td>
                <td><span class="pill active">Active</span></td>
              </tr>
            </tbody>
          </table>
        </section>
      </section>

      <aside class="dashboard-right">
        <section class="panel">
          <div class="panel-head">
            <div class="panel-title">Enrollment Trends</div>
            <select aria-label="Trend period">
              <option>Last 5 Years</option>
            </select>
          </div>
          <div class="trend">
            <svg viewBox="0 0 420 210" role="img" aria-label="Enrollment trend line">
              <path d="M15 150 C70 152 92 118 126 126 C172 142 174 178 212 176 C250 170 238 48 290 50 C330 52 332 126 368 126 C386 126 398 112 410 108" fill="none" stroke="#0d4a78" stroke-width="5" stroke-linecap="round"/>
              <circle cx="126" cy="126" r="6" fill="#0d4a78"/>
              <text x="105" y="104" fill="#12345a" font-size="15" font-weight="700">8,015</text>
            </svg>
          </div>
        </section>

        <section class="panel">
          <div class="panel-head">
            <div class="panel-title">Attendance Overview</div>
            <select aria-label="Attendance period">
              <option>This Week</option>
            </select>
          </div>
          <div class="attendance-bars">
            <div class="attendance-item"><div class="attendance-bar" data-value="1,180" style="--h: 82%"></div><span>Mon</span></div>
            <div class="attendance-item"><div class="attendance-bar" data-value="1,085" style="--h: 70%"></div><span>Tue</span></div>
            <div class="attendance-item"><div class="attendance-bar" data-value="1,230" style="--h: 88%"></div><span>Wed</span></div>
            <div class="attendance-item"><div class="attendance-bar" data-value="1,102" style="--h: 74%"></div><span>Thu</span></div>
            <div class="attendance-item"><div class="attendance-bar" data-value="1,200" style="--h: 84%"></div><span>Fri</span></div>
          </div>
        </section>

        <section class="program-list">
          <div class="program-head">
            <div class="program-title">Special Programs</div>
            <i class="fas fa-ellipsis-h"></i>
          </div>
          <article class="program-card">
            <img src="static/img/maomao.jpg" alt="">
            <div><strong>Fatima Noor</strong><span>S-2003 · 7C</span><span>Community Leadership Fellowship</span></div>
            <div class="program-tag">Enrichment</div>
          </article>
          <article class="program-card">
            <img src="static/img/left-ilu.png" alt="">
            <div><strong>Alicia Gomez</strong><span>S-2001 · 9B</span><span>National Science Scholarship</span></div>
            <div class="program-tag">Academic Support</div>
          </article>
          <article class="program-card">
            <img src="static/img/right-ilu.webp" alt="">
            <div><strong>Daniel Park</strong><span>S-2002 · 8A</span><span>Student Athlete Sponsorship</span></div>
            <div class="program-tag">Finance + Enrichment</div>
          </article>
        </section>
      </aside>
    </main>

    <div class="copyright">
      <div class="copyrightleft">
        <span>Copyright © 2026 SEInformation. All rights reserved.</span>
        <a href="#">Privacy Policy</a>
        <a href="#">Terms of Service</a>
      </div>
      <div class="contactwithus">
        <i class="fab fa-facebook"></i>
        <i class="fab fa-x-twitter"></i>
        <i class="fab fa-instagram"></i>
        <i class="fab fa-youtube"></i>
      </div>
    </div>
  </div>

  <script>
    document.querySelectorAll('.selectionlink').forEach(function(link) {
      link.addEventListener('click', function() {
        document.querySelectorAll('.selectionlink').forEach(function(item) {
          item.classList.remove('active');
        });
        link.classList.add('active');
      });
    });

    var logout = document.querySelector('.logout');
    if (logout) {
      logout.addEventListener('click', function() {
        window.location.href = 'logout';
      });
    }
  </script>
</body>
</html>

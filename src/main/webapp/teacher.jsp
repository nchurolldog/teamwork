<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.se.model.entity.Users" %>
<%
  Users currentUser = (Users) session.getAttribute("currentUser");
  if (currentUser == null) {
    response.sendRedirect("index.jsp");
    return;
  }
  if (currentUser.getUserType() == null || currentUser.getUserType() != 1) {
    response.sendRedirect("index.jsp");
    return;
  }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>SEInformation - Teacher</title>
  <script src="https://kit.fontawesome.com/b81ce93c93.js" crossorigin="anonymous"></script>
  <link rel="shortcut icon" href="static/img/favicon.ico" type="image/x-icon">
  <style>
    :root { --ink:#12345a; --muted:#718195; --line:#eaf0f4; --cyan:#ceebf1; --pink:#ffcafe; --navy:#0d4a78; --page:#f4f7f9; }
    * { box-sizing: border-box; }
    body { margin: 0; min-height: 100vh; font-family: "Microsoft YaHei", "PingFang SC", Arial, sans-serif; color: var(--ink); background: var(--page); }
    .shell { min-height: 100vh; display: grid; grid-template-columns: 240px 1fr; }
    .sidebar { background: white; border-right: 1px solid var(--line); padding: 22px; display: flex; flex-direction: column; gap: 24px; }
    .brand { display: flex; align-items: center; gap: 10px; font-weight: 800; }
    .brand img { width: 34px; height: 34px; border-radius: 10px; }
    .nav { display: grid; gap: 8px; }
    .nav a { color: #536271; text-decoration: none; padding: 12px 14px; border-radius: 8px; display: flex; gap: 10px; align-items: center; }
    .nav a.active { background: var(--pink); color: var(--ink); font-weight: 700; }
    .logout { margin-top: auto; color: #536271; text-decoration: none; }
    .content { padding: 26px; overflow: auto; }
    .top { display: flex; justify-content: space-between; align-items: center; margin-bottom: 22px; }
    h1 { margin: 0; font-size: 28px; }
    .account { color: var(--muted); margin-top: 6px; }
    .grid { display: grid; grid-template-columns: repeat(12, 1fr); gap: 18px; }
    .card { background: white; border: 1px solid var(--line); border-radius: 8px; padding: 20px; box-shadow: 0 10px 26px rgba(20,48,78,.05); }
    .span-3 { grid-column: span 3; }
    .span-4 { grid-column: span 4; }
    .span-6 { grid-column: span 6; }
    .span-8 { grid-column: span 8; }
    .span-12 { grid-column: span 12; }
    .card h2 { margin: 0 0 16px; font-size: 18px; }
    .metric strong { display: block; font-size: 30px; line-height: 1; margin-bottom: 12px; }
    .metric span { color: var(--muted); font-size: 13px; }
    .metric.featured { background: var(--cyan); }
    .metric.warning { background: var(--pink); }
    .info-list { display: grid; gap: 12px; }
    .info-row { display: flex; justify-content: space-between; gap: 18px; border-bottom: 1px solid var(--line); padding-bottom: 10px; color: var(--muted); }
    .info-row strong { color: var(--ink); }
    .pill { display: inline-flex; padding: 5px 10px; border-radius: 999px; background: var(--cyan); color: var(--navy); font-size: 12px; font-weight: 800; }
    .pill.warning { background: var(--pink); }
    table { width: 100%; border-collapse: collapse; font-size: 14px; }
    th, td { text-align: left; padding: 12px; border-bottom: 1px solid var(--line); }
    th { color: var(--muted); font-size: 12px; }
    @media (max-width: 960px) { .shell { grid-template-columns: 1fr; } .sidebar { display: none; } .span-3, .span-4, .span-6, .span-8 { grid-column: span 12; } }
  </style>
</head>
<body>
  <div class="shell">
    <aside class="sidebar">
      <div class="brand"><img src="static/img/favicon.ico" alt="Logo"><span>SEInformation</span></div>
      <nav class="nav">
        <a class="active" href="#"><i class="fas fa-chalkboard-teacher"></i>Overview</a>
        <a href="#"><i class="fas fa-id-card"></i>Personal Info</a>
        <a href="#"><i class="fas fa-users"></i>My Students</a>
        <a href="#"><i class="fas fa-school"></i>My Classes</a>
        <a href="#"><i class="fas fa-chart-line"></i>Grades</a>
        <a href="#"><i class="fas fa-calendar-check"></i>Attendance</a>
      </nav>
      <a class="logout" href="logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </aside>

    <main class="content">
      <div class="top">
        <div>
          <h1>Teacher Workspace</h1>
          <div class="account">Account: <%= currentUser.getAccount() %></div>
        </div>
        <span class="pill">Teacher</span>
      </div>

      <section class="grid">
        <article class="card metric featured span-3"><strong>3</strong><span>Courses</span></article>
        <article class="card metric span-3"><strong>128</strong><span>My Students</span></article>
        <article class="card metric warning span-3"><strong>4</strong><span>Classes</span></article>
        <article class="card metric span-3"><strong>12</strong><span>Grade Items</span></article>

        <article class="card span-4">
          <h2>Personal Info</h2>
          <div class="info-list">
            <div class="info-row"><span>Employee ID</span><strong><%= currentUser.getAccount() %></strong></div>
            <div class="info-row"><span>Name</span><strong>Waiting for teacher profile</strong></div>
            <div class="info-row"><span>Gender</span><strong>-</strong></div>
            <div class="info-row"><span>Role</span><span class="pill">Teacher</span></div>
          </div>
        </article>

        <article class="card span-8">
          <h2>My Students</h2>
          <table>
            <thead><tr><th>Student</th><th>Class</th><th>Latest Grade</th><th>Attendance</th><th>Status</th></tr></thead>
            <tbody>
              <tr><td>Michael Chen</td><td>SE-2301</td><td>89</td><td>95%</td><td><span class="pill">Good</span></td></tr>
              <tr><td>Emma Williams</td><td>SE-2302</td><td>84</td><td>87%</td><td><span class="pill warning">Needs Support</span></td></tr>
              <tr><td>Isabella Rossi</td><td>SE-2401</td><td>94</td><td>97%</td><td><span class="pill">Excellent</span></td></tr>
            </tbody>
          </table>
        </article>

        <article class="card span-6">
          <h2>My Classes</h2>
          <table>
            <thead><tr><th>Class</th><th>Course</th><th>Students</th></tr></thead>
            <tbody>
              <tr><td>SE-2301</td><td>Database Systems</td><td>42</td></tr>
              <tr><td>SE-2302</td><td>Software Engineering</td><td>39</td></tr>
              <tr><td>SE-2401</td><td>Data Structures</td><td>47</td></tr>
            </tbody>
          </table>
        </article>

        <article class="card span-6">
          <h2>Grade Work</h2>
          <div class="info-list">
            <div class="info-row"><span>Pending grade entries</span><strong>8</strong></div>
            <div class="info-row"><span>Courses with updates</span><strong>2</strong></div>
            <div class="info-row"><span>Students needing attention</span><strong>5</strong></div>
          </div>
        </article>
      </section>
    </main>
  </div>
</body>
</html>

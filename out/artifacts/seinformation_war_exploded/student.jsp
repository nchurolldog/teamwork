<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.se.model.entity.Users" %>
<%
  Users currentUser = (Users) session.getAttribute("currentUser");
  if (currentUser == null) {
    response.sendRedirect("index.jsp");
    return;
  }
  if (currentUser.getUserType() == null || currentUser.getUserType() != 3) {
    response.sendRedirect("index.jsp");
    return;
  }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>SEInformation - Student</title>
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
    .span-4 { grid-column: span 4; }
    .span-6 { grid-column: span 6; }
    .span-8 { grid-column: span 8; }
    .span-12 { grid-column: span 12; }
    .card h2 { margin: 0 0 16px; font-size: 18px; }
    .info-list { display: grid; gap: 12px; }
    .info-row { display: flex; justify-content: space-between; gap: 18px; border-bottom: 1px solid var(--line); padding-bottom: 10px; color: var(--muted); }
    .info-row strong { color: var(--ink); }
    .pill { display: inline-flex; padding: 5px 10px; border-radius: 999px; background: var(--cyan); color: var(--navy); font-size: 12px; font-weight: 800; }
    .pill.warning { background: var(--pink); }
    table { width: 100%; border-collapse: collapse; font-size: 14px; }
    th, td { text-align: left; padding: 12px; border-bottom: 1px solid var(--line); }
    th { color: var(--muted); font-size: 12px; }
    @media (max-width: 900px) { .shell { grid-template-columns: 1fr; } .sidebar { display: none; } .span-4, .span-6, .span-8 { grid-column: span 12; } }
  </style>
</head>
<body>
  <div class="shell">
    <aside class="sidebar">
      <div class="brand"><img src="static/img/favicon.ico" alt="Logo"><span>SEInformation</span></div>
      <nav class="nav">
        <a class="active" href="#"><i class="fas fa-id-card"></i>Personal</a>
        <a href="#"><i class="fas fa-users"></i>Class</a>
        <a href="#"><i class="fas fa-chart-line"></i>Grades</a>
        <a href="#"><i class="fas fa-award"></i>Scholarship</a>
        <a href="#"><i class="fas fa-flag"></i>Party Application</a>
        <a href="#"><i class="fas fa-calendar-check"></i>Meetings</a>
      </nav>
      <a class="logout" href="logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </aside>

    <main class="content">
      <div class="top">
        <div>
          <h1>Student Workspace</h1>
          <div class="account">Account: <%= currentUser.getAccount() %></div>
        </div>
        <span class="pill">Student</span>
      </div>

      <section class="grid">
        <article class="card span-4">
          <h2>Personal Info</h2>
          <div class="info-list">
            <div class="info-row"><span>Name</span><strong>Waiting for profile data</strong></div>
            <div class="info-row"><span>Student ID</span><strong><%= currentUser.getAccount() %></strong></div>
            <div class="info-row"><span>Gender</span><strong>-</strong></div>
            <div class="info-row"><span>Political Status</span><strong>-</strong></div>
          </div>
        </article>

        <article class="card span-4">
          <h2>Class Info</h2>
          <div class="info-list">
            <div class="info-row"><span>Class</span><strong>Not assigned</strong></div>
            <div class="info-row"><span>Teacher</span><strong>-</strong></div>
            <div class="info-row"><span>Counselor</span><strong>-</strong></div>
          </div>
        </article>

        <article class="card span-4">
          <h2>Application Status</h2>
          <div class="info-list">
            <div class="info-row"><span>Party Application</span><span class="pill warning">Not Submitted</span></div>
            <div class="info-row"><span>Scholarship</span><span class="pill">No Active Application</span></div>
          </div>
        </article>

        <article class="card span-8">
          <h2>Grades</h2>
          <table>
            <thead><tr><th>Course</th><th>Regular</th><th>Final</th><th>Total</th></tr></thead>
            <tbody>
              <tr><td>Data Structures</td><td>90</td><td>88</td><td>89</td></tr>
              <tr><td>Database Systems</td><td>92</td><td>91</td><td>91.5</td></tr>
              <tr><td>Software Engineering</td><td>95</td><td>93</td><td>94</td></tr>
            </tbody>
          </table>
        </article>

        <article class="card span-4">
          <h2>Class Meetings</h2>
          <div class="info-list">
            <div class="info-row"><span>Theme</span><strong>Safety Education</strong></div>
            <div class="info-row"><span>Classroom</span><strong>A-201</strong></div>
            <div class="info-row"><span>Status</span><span class="pill">To Attend</span></div>
          </div>
        </article>
      </section>
    </main>
  </div>
</body>
</html>

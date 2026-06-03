<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.se.model.entity.Users" %>
<%@ page import="org.se.model.dao.DashboardDao" %>
<%@ page import="org.se.model.dao.ClassMeetingDAO" %>
<%@ page import="org.se.model.entity.ClassMeeting" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%!
  private String valueText(Object value) {
    if (value == null) return "-";
    String text = String.valueOf(value);
    return text.trim().isEmpty() ? "-" : text;
  }

  private String activeNav(String currentView, String expectedView) {
    return expectedView.equals(currentView) ? "active" : "";
  }
%>
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
  DashboardDao dashboardDao = new DashboardDao();
  ClassMeetingDAO classMeetingDAO = new ClassMeetingDAO();

  String editMeetingID = request.getParameter("edit");
  ClassMeeting editMeeting = editMeetingID != null ? classMeetingDAO.findById(editMeetingID) : null;

  int studentCount = dashboardDao.countRows("student");
  int teacherCount = dashboardDao.countAdminTeachers();
  int counselorCount = dashboardDao.countAdminCounselors();
  int classCount = dashboardDao.countAdminClasses();
  int partyCount = dashboardDao.countRows("party_application");
  int scholarshipCount = dashboardDao.countRows("scholarship_application");
  int meetingCount = dashboardDao.countRows("class_meeting");
  List<Map<String, Object>> adminStudents = dashboardDao.findAdminStudents(8);
  List<Map<String, Object>> allMeetings = dashboardDao.findAllClassMeetings();
  List<Map<String, Object>> roleSummaryRows = dashboardDao.findAdminRoleSummary();
  List<Map<String, Object>> applicationSummaryRows = dashboardDao.findAdminApplicationSummary();
  List<Map<String, Object>> classSummaryRows = dashboardDao.findAdminClassSummary();
  List<Map<String, Object>> gradeSummaryRows = dashboardDao.findAdminGradeSummary();
  List<Map<String, Object>> recentScholarshipRows = dashboardDao.findAdminRecentScholarshipApplications(6);
  List<Map<String, Object>> recentPartyRows = dashboardDao.findAdminRecentPartyApplications(6);

  String meetingStatus = request.getParameter("meetingStatus");
  String view = request.getParameter("view") == null ? "dashboard" : request.getParameter("view");
  String pageTitle = "dashboard".equals(view) ? "Admin Dashboard"
      : "accounts".equals(view) ? "Account Management"
      : "students".equals(view) ? "Student Management"
      : "classes".equals(view) ? "Class Management"
      : "applications".equals(view) ? "Application Statistics"
      : "meetings".equals(view) ? "Class Meetings"
      : "Admin Dashboard";
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
      text-decoration: none;
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

    .main.single {
      grid-template-columns: 1fr;
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

    .pill.position-student {
      background: rgba(206, 235, 241, .95);
      color: var(--navy);
    }

    .pill.position-monitor {
      background: var(--pink);
      color: var(--ink);
    }

    .pill.position-study {
      background: #65d7af;
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

    .cardtext a {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      min-height: 32px;
      padding: 0 12px;
      border-radius: 7px;
      background: var(--pink);
      color: var(--ink);
      font-size: 12px;
      font-weight: 800;
      text-decoration: none;
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
        <a class="selectionlink <%= activeNav(view, "dashboard") %>" href="admin.jsp"><i class="fas fa-home"></i><span>Dashboard</span></a>
        <a class="selectionlink <%= activeNav(view, "accounts") %>" href="admin.jsp?view=accounts"><i class="fas fa-user-shield"></i><span>Accounts</span></a>
        <a class="selectionlink <%= activeNav(view, "students") %>" href="admin.jsp?view=students"><i class="fas fa-user-graduate"></i><span>Students</span></a>
        <a class="selectionlink <%= activeNav(view, "classes") %>" href="admin.jsp?view=classes"><i class="fas fa-school"></i><span>Classes</span></a>
        <a class="selectionlink <%= activeNav(view, "applications") %>" href="admin.jsp?view=applications"><i class="fas fa-clipboard-check"></i><span>Applications</span></a>
        <a class="selectionlink <%= activeNav(view, "meetings") %>" href="admin.jsp?view=meetings"><i class="fas fa-calendar-alt"></i><span>Class Meetings</span></a>
      </div>
    </div>
    <div class="cardandlogout">
      <div class="card">
        <div class="cardicon"><img src="static/img/money.png" alt="Card Icon"></div>
        <div class="cardtext">
          <h1>System Snapshot</h1>
          <p><%= studentCount %> students, <%= classCount %> classes</p>
          <a href="admin.jsp?view=applications">Review Data</a>
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
        <div class="page-title"><%= pageTitle %></div>
        <div class="page-breadcrumb">Admin / <%= pageTitle %></div>
      </div>
      <div class="userprofile">
        <div class="photoandname">
          <div class="photo"><img src="static/img/maomao.jpg" alt="Profile Photo"></div>
          <div class="nameandposition">
            <div class="name"><%= currentUser.getAccount() %></div>
            <div class="position">Administrator</div>
          </div>
        </div>
      </div>
    </div>

    <main class="main <%= "meetings".equals(view) ? "single" : "" %>">
      <section class="dashboard-left">
        <% if ("dashboard".equals(view)) { %>
          <%@ include file="admin/metrics.jsp" %>
          <%@ include file="admin/management-summary.jsp" %>
          <%@ include file="admin/recent-applications.jsp" %>
          <%@ include file="admin/class-summary.jsp" %>
        <% } else if ("accounts".equals(view)) { %>
          <%@ include file="admin/create-account.jsp" %>
          <%@ include file="admin/management-summary.jsp" %>
        <% } else if ("students".equals(view)) { %>
          <%@ include file="admin/students.jsp" %>
          <%@ include file="admin/performance.jsp" %>
        <% } else if ("classes".equals(view)) { %>
          <%@ include file="admin/class-summary.jsp" %>
        <% } else if ("applications".equals(view)) { %>
          <%@ include file="admin/management-summary.jsp" %>
          <%@ include file="admin/recent-applications.jsp" %>
        <% } else if ("meetings".equals(view)) { %>
          <%@ include file="admin/class-meetings.jsp" %>
        <% } %>
      </section>

      <% if (!"meetings".equals(view)) { %>
      <aside class="dashboard-right">
        <%@ include file="admin/performance.jsp" %>
      </aside>
      <% } %>
    </main>

    <div class="copyright">
      <div class="copyrightleft">
        <span>Copyright &copy; 2026 SEInformation. All rights reserved.</span>
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
    var logout = document.querySelector('.logout');
    if (logout) {
      logout.addEventListener('click', function() {
        window.location.href = 'logout';
      });
    }

    function showCreateForm() {
      var form = document.getElementById('createForm');
      if (form) {
        form.style.display = 'block';
      }
    }

    function hideCreateForm() {
      var form = document.getElementById('createForm');
      if (form) {
        form.style.display = 'none';
      }
    }
  </script>
</body>
</html>

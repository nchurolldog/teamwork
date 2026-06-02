<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.se.model.entity.Users" %>
<%@ page import="org.se.model.entity.Counselor" %>
<%@ page import="org.se.model.entity.ProfileImage" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="org.se.model.dao.*" %>
<%@ page import="org.se.model.entity.ClassMeeting" %>
<%!
  private String textOrDash(String value) {
    return value == null || value.trim().isEmpty() ? "-" : value;
  }

  private String fieldValue(String value) {
    return value == null ? "" : value;
  }

  private String genderText(Integer gender) {
    if (gender == null) return "-";
    if (gender == 1) return "Male";
    if (gender == 2) return "Female";
    return "Unknown";
  }

  private String valueText(Object value) {
    if (value == null) return "-";
    String text = String.valueOf(value);
    return text.trim().isEmpty() ? "-" : text;
  }

  private String attrValue(Object value) {
    return valueText(value)
        .replace("&", "&amp;")
        .replace("\"", "&quot;")
        .replace("<", "&lt;")
        .replace(">", "&gt;");
  }

  private Integer parseIntegerParam(String value) {
    try {
      return value == null || value.trim().isEmpty() ? null : Integer.parseInt(value);
    } catch (NumberFormatException e) {
      return null;
    }
  }

  private int positiveInt(String value, int fallback) {
    try {
      int parsed = value == null ? fallback : Integer.parseInt(value);
      return parsed < 1 ? fallback : parsed;
    } catch (NumberFormatException e) {
      return fallback;
    }
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
  if (currentUser.getUserType() == null || currentUser.getUserType() != 2) {
    response.sendRedirect("index.jsp");
    return;
  }
  CounselorDAO counselorDAO = new CounselorDAO();
  Counselor counselor = counselorDAO.findByAccount(currentUser.getAccount());
  String employeeID = counselor == null ? currentUser.getAccount() : counselor.getEmployeeID();
  ProfileImageDao profileImageDao = new ProfileImageDao();
  DashboardDao dashboardDao = new DashboardDao();
  ProfileImage profileImage = profileImageDao.findByOwner(currentUser.getUserType(), currentUser.getAccount());
  String avatarPath = profileImage == null || profileImage.getImagePath() == null ? "static/img/maomao.jpg" : profileImage.getImagePath();
  ClassMeetingDAO classMeetingDAO = new ClassMeetingDAO();
  ScholarshipWorkflowDao scholarshipWorkflowDao = new ScholarshipWorkflowDao();
  DevelopmentInspectionDao developmentInspectionDao = new DevelopmentInspectionDao();
  PartyApprovalDao partyApprovalDao = new PartyApprovalDao();
  String editMeetingID = request.getParameter("edit");
  ClassMeeting editMeeting = editMeetingID != null ? classMeetingDAO.findById(editMeetingID) : null;

  String view = request.getParameter("view") == null ? "overview" : request.getParameter("view");
  String search = request.getParameter("q") == null ? "" : request.getParameter("q").trim();
  Integer filterClassID = parseIntegerParam(request.getParameter("classId"));
  int currentPage = positiveInt(request.getParameter("page"), 1);
  int pageSize = 30;
  List<Map<String, Object>> counselorClassRows = dashboardDao.findCounselorClasses(employeeID);
  List<Map<String, Object>> counselorStudentRows = dashboardDao.findCounselorStudents(employeeID);
  List<Map<String, Object>> developmentInspectionRows = dashboardDao.findCounselorDevelopmentInspections(employeeID);
  List<Map<String, Object>> partyApprovalRows = dashboardDao.findCounselorPartyApprovals(employeeID);
  int totalFilteredStudents = dashboardDao.countCounselorStudentsFiltered(employeeID, search, filterClassID);
  int totalPages = Math.max(1, (int) Math.ceil(totalFilteredStudents / (double) pageSize));
  if (currentPage > totalPages) currentPage = totalPages;
  int offset = (currentPage - 1) * pageSize;
  List<Map<String, Object>> counselorStudentPageRows = dashboardDao.findCounselorStudentsPaged(employeeID, search, filterClassID, offset, pageSize);
  List<Map<String, Object>> counselorMeetingRows = dashboardDao.findCounselorMeetings(employeeID);

  List<Map<String, Object>> allMeetings = dashboardDao.findAllClassMeetings();
  List<Map<String, Object>> counselorPartyRows = dashboardDao.findCounselorPartyApplications(employeeID);
  List<Map<String, Object>> counselorScholarshipRows = dashboardDao.findCounselorScholarshipApplications(employeeID);
  List<Map<String, Object>> counselorScholarshipReviewRows = scholarshipWorkflowDao.findCounselorReviewTasks(employeeID);
  int partyApplicationCount = dashboardDao.countCounselorPartyApplications(employeeID);
  int scholarshipApplicationCount = dashboardDao.countCounselorScholarshipApplications(employeeID);
  String profileStatus = request.getParameter("profile");
  String manageStatus = request.getParameter("manage");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>SEInformation - Counselor</title>
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
    .top-actions { display: flex; align-items: center; gap: 14px; }
    .avatar { width: 52px; height: 52px; border-radius: 50%; object-fit: cover; border: 3px solid white; box-shadow: 0 8px 20px rgba(18,52,90,.16); background: var(--cyan); }
    h1 { margin: 0; font-size: 28px; }
    .account { color: var(--muted); margin-top: 6px; }
    .grid { display: grid; grid-template-columns: repeat(12, 1fr); gap: 18px; }
    .card { background: white; border: 1px solid var(--line); border-radius: 8px; padding: 20px; box-shadow: 0 10px 26px rgba(20,48,78,.05); }
    .card-head { display: flex; align-items: center; justify-content: space-between; gap: 12px; margin-bottom: 16px; }
    .card-head h2 { margin: 0; }
    .edit-profile { border: 0; background: transparent; color: var(--navy); display: inline-flex; align-items: center; gap: 6px; font-weight: 800; cursor: pointer; padding: 6px 0; }
    .edit-profile:hover { color: #0a6d9a; }
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
    .notice { grid-column: span 12; padding: 12px 14px; border-radius: 8px; font-size: 13px; background: #e6f8f0; color: #177a59; }
    .notice.error { background: #ffe7ee; color: #9b2849; }
    .modal-mask { position: fixed; inset: 0; background: rgba(18, 52, 90, .36); display: none; align-items: center; justify-content: center; padding: 22px; z-index: 10; }
    .modal-mask.show { display: flex; }
    .profile-modal { width: min(560px, 100%); max-height: calc(100vh - 44px); overflow-y: auto; background: white; border-radius: 10px; border: 1px solid var(--line); box-shadow: 0 30px 90px rgba(18, 52, 90, .28); padding: 22px; }
    .modal-head { display: flex; justify-content: space-between; align-items: center; gap: 12px; margin-bottom: 18px; }
    .modal-head h2 { margin: 0; font-size: 20px; }
    .close-modal { width: 34px; height: 34px; border: 0; border-radius: 8px; background: var(--page); color: var(--ink); cursor: pointer; }
    .form-grid { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 14px; }
    .form-field { display: grid; gap: 7px; color: var(--muted); font-size: 13px; font-weight: 700; }
    .form-field.full { grid-column: 1 / -1; }
    .form-field input, .form-field select { width: 100%; height: 42px; border: 1px solid var(--line); border-radius: 8px; padding: 0 12px; font: inherit; color: var(--ink); background: white; }
    .form-field input[type="file"] { padding: 9px 12px; }
    .form-actions { display: flex; justify-content: flex-end; gap: 10px; margin-top: 18px; }
    .secondary-btn, .primary-btn { border: 0; border-radius: 8px; height: 40px; padding: 0 16px; font-weight: 800; cursor: pointer; }
    .secondary-btn { background: var(--page); color: var(--ink); }
    .primary-btn { background: var(--pink); color: var(--ink); }
    .list-tools { display: flex; align-items: center; gap: 10px; margin-bottom: 12px; flex-wrap: wrap; }
    .list-tools input, .list-tools select { height: 38px; border: 1px solid var(--line); border-radius: 8px; padding: 0 10px; color: var(--ink); background: white; }
    .list-tools button, .page-link { height: 38px; border: 0; border-radius: 8px; padding: 0 14px; background: var(--cyan); color: var(--ink); font-weight: 800; text-decoration: none; display: inline-flex; align-items: center; }
    .pagination { display: flex; gap: 10px; align-items: center; justify-content: flex-end; margin-top: 12px; color: var(--muted); font-size: 13px; }
    .inline-form { display: inline-flex; gap: 8px; align-items: center; flex-wrap: wrap; }
    .inline-form select, .inline-form input { height: 34px; border: 1px solid var(--line); border-radius: 8px; padding: 0 8px; color: var(--ink); background: white; }
    .small-btn { height: 34px; border: 0; border-radius: 8px; padding: 0 10px; background: var(--cyan); color: var(--ink); font-weight: 800; cursor: pointer; }
    .small-btn.danger { background: var(--pink); }
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
        <a class="<%= activeNav(view, "overview") %>" href="counselor.jsp"><i class="fas fa-user-friends"></i>Overview</a>
        <a class="<%= activeNav(view, "personal") %>" href="counselor.jsp?view=personal"><i class="fas fa-id-card"></i>Personal Info</a>
        <a class="<%= activeNav(view, "students") %>" href="counselor.jsp?view=students"><i class="fas fa-users"></i>My Students</a>
        <a class="<%= activeNav(view, "classes") %>" href="counselor.jsp?view=classes"><i class="fas fa-school"></i>Classes</a>
        <a class="<%= activeNav(view, "partyReview") %>" href="counselor.jsp?view=partyReview"><i class="fas fa-flag"></i>Party Review</a>
        <a class="<%= activeNav(view, "developmentInspection") %>" href="counselor.jsp?view=developmentInspection"><i class="fas fa-clipboard-check"></i>Development Inspection</a>
        <a class="<%= activeNav(view, "partyApproval") %>" href="counselor.jsp?view=partyApproval"><i class="fas fa-stamp"></i>Party Approval</a>
        <a class="<%= activeNav(view, "scholarshipReview") %>" href="counselor.jsp?view=scholarshipReview"><i class="fas fa-award"></i>Scholarship</a>
        <a class="<%= activeNav(view, "meetings") %>" href="counselor.jsp?view=meetings"><i class="fas fa-calendar-check"></i>Class Meetings</a>
      </nav>
      <a class="logout" href="logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </aside>

    <main class="content">
      <div class="top">
        <div>
          <h1>Counselor Workspace</h1>
          <div class="account">Account: <%= currentUser.getAccount() %></div>
        </div>
        <div class="top-actions">
          <img class="avatar" src="<%= avatarPath %>" alt="Avatar">
          <span class="pill">Counselor</span>
        </div>
      </div>

      <section class="grid">
        <% if ("saved".equals(profileStatus)) { %>
          <div class="notice">Personal information updated.</div>
        <% } else if ("failed".equals(profileStatus)) { %>
          <div class="notice error">Personal information update failed. Please check required fields.</div>
        <% } %>
        <% if ("saved".equals(manageStatus)) { %>
          <div class="notice">Student management updated.</div>
        <% } else if ("failed".equals(manageStatus)) { %>
          <div class="notice error">Student management failed. Check student ID and class ownership.</div>
        <% } %>
        <% if ("overview".equals(view)) { %>
          <article class="card metric featured span-3"><strong><%= counselorClassRows.size() %></strong><span>Managed Classes</span></article>
          <article class="card metric span-3"><strong><%= counselorStudentRows.size() %></strong><span>My Students</span></article>
          <article class="card metric warning span-3"><strong><%= partyApplicationCount %></strong><span>Party Applications</span></article>
          <article class="card metric span-3"><strong><%= scholarshipApplicationCount %></strong><span>Scholarship Reviews</span></article>
        <% } %>

        <% if ("overview".equals(view) || "personal".equals(view)) { %>
        <article class="card <%= "personal".equals(view) ? "span-12" : "span-4" %>">
          <div class="card-head">
            <h2>Personal Info</h2>
            <button class="edit-profile" type="button" id="openProfileEditor"><i class="fas fa-pen-to-square"></i><span>Edit</span></button>
          </div>
          <div class="info-list">
            <div class="info-row"><span>Employee ID</span><strong><%= textOrDash(employeeID) %></strong></div>
            <div class="info-row"><span>Name</span><strong><%= counselor == null ? "Waiting for counselor profile" : textOrDash(counselor.getName()) %></strong></div>
            <div class="info-row"><span>Gender</span><strong><%= counselor == null ? "-" : genderText(counselor.getGender()) %></strong></div>
            <div class="info-row"><span>Role</span><span class="pill">Counselor</span></div>
          </div>
        </article>
        <% } %>

        <% if ("overview".equals(view) || "students".equals(view)) { %>
        <article class="card <%= "students".equals(view) ? "span-12" : "span-8" %>">
          <h2>My Students</h2>
          <% if ("students".equals(view)) { %>
            <form class="list-tools" action="manageClassStudent" method="post">
              <input type="hidden" name="action" value="add">
              <input type="text" name="studentID" placeholder="Student ID" required>
              <select name="classId" required>
                <option value="">Class</option>
                <% for (Map<String, Object> row : counselorClassRows) { %>
                  <option value="<%= valueText(row.get("class_id")) %>"><%= valueText(row.get("class_name")) %></option>
                <% } %>
              </select>
              <select name="position">
                <option value="学生">学生</option>
                <option value="班长">班长</option>
                <option value="学习委员">学习委员</option>
              </select>
              <button type="submit">Add Student</button>
            </form>
          <% } %>
          <form class="list-tools" action="counselor.jsp" method="get">
            <input type="hidden" name="view" value="students">
            <input type="search" name="q" value="<%= fieldValue(search) %>" placeholder="Search student">
            <select name="classId" aria-label="Class filter">
              <option value="">All Classes</option>
              <% for (Map<String, Object> row : counselorClassRows) {
                String classIdText = valueText(row.get("class_id"));
              %>
                <option value="<%= classIdText %>" <%= filterClassID != null && classIdText.equals(String.valueOf(filterClassID)) ? "selected" : "" %>><%= valueText(row.get("class_name")) %></option>
              <% } %>
            </select>
            <button type="submit">Search</button>
          </form>
          <table>
            <thead><tr><th>Student</th><th>Class</th><th>Position</th><th>Party Application</th><th>Scholarship</th><th>Attention</th><% if ("students".equals(view)) { %><th>Manage</th><% } %></tr></thead>
            <tbody>
              <% if (counselorStudentPageRows.isEmpty()) { %>
                <tr><td colspan="<%= "students".equals(view) ? 7 : 6 %>">No students assigned.</td></tr>
              <% } else {
                for (Map<String, Object> row : counselorStudentPageRows) {
                  boolean pending = "pending".equalsIgnoreCase(valueText(row.get("party_status")))
                          || "pending".equalsIgnoreCase(valueText(row.get("scholarship_status")));
              %>
                <tr>
                  <td><%= valueText(row.get("name")) %></td>
                  <td><%= valueText(row.get("class_name")) %></td>
                  <td><%= valueText(row.get("position")) %></td>
                  <td><span class="pill <%= pending ? "warning" : "" %>"><%= valueText(row.get("party_status")) %></span></td>
                  <td><span class="pill"><%= valueText(row.get("scholarship_status")) %></span></td>
                  <td><%= pending ? "Needs review" : "Normal" %></td>
                  <% if ("students".equals(view)) { %>
                    <td>
                      <form class="inline-form" action="manageClassStudent" method="post">
                        <input type="hidden" name="studentID" value="<%= valueText(row.get("student_id")) %>">
                        <input type="hidden" name="classId" value="<%= valueText(row.get("class_id")) %>">
                        <select name="position">
                          <option value="学生" <%= "学生".equals(valueText(row.get("position"))) ? "selected" : "" %>>学生</option>
                          <option value="班长" <%= "班长".equals(valueText(row.get("position"))) ? "selected" : "" %>>班长</option>
                          <option value="学习委员" <%= "学习委员".equals(valueText(row.get("position"))) ? "selected" : "" %>>学习委员</option>
                        </select>
                        <button class="small-btn" type="submit" name="action" value="position">Save</button>
                        <button class="small-btn danger" type="submit" name="action" value="delete">Delete</button>
                      </form>
                    </td>
                  <% } %>
                </tr>
              <% }} %>
            </tbody>
          </table>
          <div class="pagination">
            <% if (currentPage > 1) { %>
              <a class="page-link" href="counselor.jsp?view=students&q=<%= fieldValue(search) %>&classId=<%= filterClassID == null ? "" : filterClassID %>&page=<%= currentPage - 1 %>">Prev</a>
            <% } %>
            <span>Page <%= currentPage %> / <%= totalPages %>, Total <%= totalFilteredStudents %></span>
            <% if (currentPage < totalPages) { %>
              <a class="page-link" href="counselor.jsp?view=students&q=<%= fieldValue(search) %>&classId=<%= filterClassID == null ? "" : filterClassID %>&page=<%= currentPage + 1 %>">Next</a>
            <% } %>
          </div>
        </article>
        <% } %>

        <% if ("classes".equals(view)) { %>
        <article class="card span-12" id="classes">
          <h2>Managed Classes</h2>
          <table>
            <thead><tr><th>Class</th><th>Students</th></tr></thead>
            <tbody>
              <% if (counselorClassRows.isEmpty()) { %>
                <tr><td colspan="2">No classes assigned.</td></tr>
              <% } else {
                for (Map<String, Object> row : counselorClassRows) {
              %>
                <tr><td><%= valueText(row.get("class_name")) %></td><td><%= valueText(row.get("student_count")) %></td></tr>
              <% }} %>
            </tbody>
          </table>
        </article>
        <% } %>

        <% if ("overview".equals(view) || "meetings".equals(view)) { %>
<article class="card <%= "meetings".equals(view) ? "span-12" : "span-6" %>">
  <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
    <h2 style="margin: 0;">Class Meetings</h2>
    <div>
      <a href="counselor.jsp?view=meetings" class="pill" style="text-decoration: none; margin-right: 8px;">View All</a>
      <button class="primary-btn" type="button" onclick="showCreateForm()" style="font-size: 12px; padding: 5px 10px; height: auto;">+ Create Meeting</button>
    </div>
  </div>

  <% if ("created".equals(request.getParameter("meetingStatus"))) { %>
    <div class="notice">Meeting created successfully!</div>
  <% } else if ("updated".equals(request.getParameter("meetingStatus"))) { %>
    <div class="notice">Meeting updated successfully!</div>
  <% } else if ("deleted".equals(request.getParameter("meetingStatus"))) { %>
    <div class="notice">Meeting deleted successfully!</div>
  <% } else if ("error".equals(request.getParameter("meetingStatus"))) { %>
    <div class="notice error">Operation failed. Please try again.</div>
  <% } %>

  <div class="application-card" id="createForm" style="display: none; margin-bottom: 18px;">
    <h3 style="margin: 0 0 14px 0;">Create New Meeting</h3>
    <form action="manageClassMeeting" method="post" class="application-form">
      <input type="hidden" name="action" value="create">
      <label>
        Meeting ID
        <input type="text" name="meetingID" placeholder="e.g., CM004" required style="width: 100%; height: 36px; border: 1px solid var(--line); border-radius: 6px; padding: 0 10px;">
      </label>
      <label>
        Class ID
        <input type="number" name="classID" placeholder="e.g., 1" required style="width: 100%; height: 36px; border: 1px solid var(--line); border-radius: 6px; padding: 0 10px;">
      </label>
      <label class="full">
        Theme
        <input type="text" name="meetingTheme" placeholder="Meeting theme" required style="width: 100%; height: 36px; border: 1px solid var(--line); border-radius: 6px; padding: 0 10px;">
      </label>
      <label class="full">
        Classroom
        <input type="text" name="classroom" placeholder="e.g., A101" required style="width: 100%; height: 36px; border: 1px solid var(--line); border-radius: 6px; padding: 0 10px;">
      </label>
      <div class="apply-actions" style="display: flex; gap: 8px; justify-content: flex-end;">
        <button class="secondary-btn" type="button" onclick="hideCreateForm()" style="font-size: 12px; padding: 5px 10px; height: auto;">Cancel</button>
        <button class="primary-btn" type="submit" style="font-size: 12px; padding: 5px 10px; height: auto;">Create</button>
      </div>
    </form>
  </div>

  <table>
    <thead><tr><th>Meeting ID</th><th>Theme</th><th>Class</th><th>Classroom</th><th>Organizer</th><th>Actions</th></tr></thead>
    <tbody>
      <%
        List<Map<String, Object>> displayMeetings = "meetings".equals(view) ? allMeetings : counselorMeetingRows;
        if (displayMeetings.isEmpty()) {
      %>
        <tr><td colspan="6">No class meetings.</td></tr>
      <% } else {
        for (Map<String, Object> row : displayMeetings) {
          String organizerName = valueText(row.get("organizer_name"));
          String organizerId = valueText(row.get("organizer_id"));
          // 如果组织者信息为空或无效，显示为 "-"
          String displayOrganizer = "-";
          if (!"-".equals(organizerName) && !organizerName.trim().isEmpty()) {
            displayOrganizer = organizerName + " (" + organizerId + ")";
          }
      %>
        <tr>
          <td><%= valueText(row.get("meeting_id")) %></td>
          <td><%= valueText(row.get("meeting_theme")) %></td>
          <td><%= valueText(row.get("class_name")) %></td>
          <td><%= valueText(row.get("classroom")) %></td>
          <td><%= displayOrganizer %></td>
          <td>
            <a href="counselor.jsp?view=meetings&edit=<%= valueText(row.get("meeting_id")) %>" style="color: var(--navy); font-weight: 700; text-decoration: none; margin-right: 8px; font-size: 12px;">Edit</a>
            <a href="manageClassMeeting?action=delete&meetingID=<%= valueText(row.get("meeting_id")) %>"
               onclick="return confirm('Are you sure you want to delete this meeting?')"
               style="color: #c9302c; font-weight: 700; text-decoration: none; font-size: 12px;">Delete</a>
          </td>
        </tr>
      <% }} %>
    </tbody>
  </table>
</article>

<% if (editMeeting != null) { %>
<article class="card span-12" style="margin-top: 18px;">
  <h2>Edit Meeting</h2>
  <form action="manageClassMeeting" method="post" class="application-form" style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 12px;">
    <input type="hidden" name="action" value="update">
    <input type="hidden" name="meetingID" value="<%= editMeeting.getMeetingID() %>">
    <label style="display: grid; gap: 6px;">
      Meeting ID
      <input type="text" name="meetingID_display" value="<%= editMeeting.getMeetingID() %>" readonly style="width: 100%; height: 36px; border: 1px solid var(--line); border-radius: 6px; padding: 0 10px; background: #f5f5f5;">
    </label>
    <label style="display: grid; gap: 6px;">
      Class ID
      <input type="number" name="classID" value="<%= editMeeting.getClassID() %>" required style="width: 100%; height: 36px; border: 1px solid var(--line); border-radius: 6px; padding: 0 10px;">
    </label>
    <label class="full" style="grid-column: 1 / -1; display: grid; gap: 6px;">
      Theme
      <input type="text" name="meetingTheme" value="<%= editMeeting.getMeetingTheme() %>" required style="width: 100%; height: 36px; border: 1px solid var(--line); border-radius: 6px; padding: 0 10px;">
    </label>
    <label class="full" style="grid-column: 1 / -1; display: grid; gap: 6px;">
      Classroom
      <input type="text" name="classroom" value="<%= editMeeting.getClassroom() %>" required style="width: 100%; height: 36px; border: 1px solid var(--line); border-radius: 6px; padding: 0 10px;">
    </label>
    <div class="apply-actions" style="grid-column: 1 / -1; display: flex; gap: 8px; justify-content: flex-end;">
      <a href="counselor.jsp?view=meetings" class="secondary-btn" style="font-size: 12px; padding: 5px 10px; height: auto; text-decoration: none; display: inline-flex; align-items: center;">Cancel</a>
      <button class="primary-btn" type="submit" style="font-size: 12px; padding: 5px 10px; height: auto;">Update</button>
    </div>
  </form>
</article>
<% } %>

<script>
function showCreateForm() {
  document.getElementById('createForm').style.display = 'block';
}
function hideCreateForm() {
  document.getElementById('createForm').style.display = 'none';
}
</script>
<% } %>

        <% if ("overview".equals(view)) { %>
        <article class="card span-6">
          <h2>Review Queue</h2>
          <div class="info-list">
            <div class="info-row"><span>Scholarship waiting</span><strong><%= scholarshipApplicationCount %></strong></div>
            <div class="info-row"><span>Party applications waiting</span><strong><%= partyApplicationCount %></strong></div>
            <div class="info-row"><span>Students needing attention</span><strong>
              <%
                int attentionCount = 0;
                for (Map<String, Object> row : counselorStudentRows) {
                  if ("pending".equalsIgnoreCase(valueText(row.get("party_status")))
                          || "pending".equalsIgnoreCase(valueText(row.get("scholarship_status")))) {
                    attentionCount++;
                  }
                }
              %><%= attentionCount %>
            </strong></div>
          </div>
        </article>
        <% } %>

        <% if ("partyReview".equals(view)) { %>
        <article class="card span-12">
          <h2>Party Application Review</h2>
          <table>
            <thead><tr><th>Application</th><th>Student</th><th>Class</th><th>Reason</th><th>Status</th><th>Action</th></tr></thead>
            <tbody>
            <% if (counselorPartyRows.isEmpty()) { %>
            <tr><td colspan="6">No party applications.</td></tr>
            <% } else {
              for (Map<String, Object> row : counselorPartyRows) {
                String status = valueText(row.get("status"));
            %>
            <tr>
              <td><%= valueText(row.get("application_id")) %></td>
              <td><%= valueText(row.get("name")) %> (<%= valueText(row.get("student_id")) %>)</td>
              <td><%= valueText(row.get("class_name")) %></td>
              <td><%= valueText(row.get("reason")) %></td>
              <td><span class="pill <%= "pending".equals(status) ? "warning" : "" %>"><%= status %></span></td>
              <td>
                <% if ("pending".equals(status)) { %>
                <form action="counselorPartyReview" method="post" style="display: inline-flex; gap: 8px;">
                  <input type="hidden" name="applicationID" value="<%= valueText(row.get("application_id")) %>">
                  <button class="small-btn" type="submit" name="action" value="approve">Approve</button>
                  <button class="small-btn danger" type="submit" name="action" value="reject">Reject</button>
                </form>
                <% } else { %>
                <span style="color: var(--muted); font-size: 13px;">Reviewed</span>
                <% } %>
              </td>
            </tr>
            <% }} %>
            </tbody>
          </table>
        </article>
        <% } %>

        <% if ("developmentInspection".equals(view)) { %>
        <article class="card span-12">
          <h2>Development Inspection</h2>
          <table>
            <thead><tr><th>Inspection ID</th><th>Application</th><th>Student</th><th>Class</th><th>Reason</th><th>Status</th><th>Action</th></tr></thead>
            <tbody>
            <% if (developmentInspectionRows.isEmpty()) { %>
            <tr><td colspan="7">No development inspection tasks.</td></tr>
            <% } else {
              for (Map<String, Object> row : developmentInspectionRows) {
                String status = valueText(row.get("status"));
            %>
            <tr>
              <td><%= valueText(row.get("inspection_id")) %></td>
              <td><%= valueText(row.get("application_id")) %></td>
              <td><%= valueText(row.get("name")) %> (<%= valueText(row.get("student_id")) %>)</td>
              <td><%= valueText(row.get("class_name")) %></td>
              <td><%= valueText(row.get("reason")) %></td>
              <td><span class="pill <%= "pending".equals(status) ? "warning" : "" %>"><%= status %></span></td>
              <td>
                <% if ("pending".equals(status)) { %>
                <form action="counselorDevelopmentInspection" method="post" style="display: inline-flex; gap: 8px;">
                  <input type="hidden" name="inspectionID" value="<%= valueText(row.get("inspection_id")) %>">
                  <button class="small-btn" type="submit" name="action" value="approve">Approve</button>
                  <button class="small-btn danger" type="submit" name="action" value="reject">Reject</button>
                </form>
                <% } else { %>
                <span class="pill"><%= status %></span>
                <% } %>
              </td>
            </tr>
            <% }} %>
            </tbody>
          </table>
        </article>
        <% } %>

        <% if ("partyApproval".equals(view)) { %>
        <article class="card span-12">
          <h2>Party Membership Approval</h2>
          <table>
            <thead><tr><th>Approval ID</th><th>Application</th><th>Student</th><th>Class</th><th>Reason</th><th>Status</th><th>Action</th></tr></thead>
            <tbody>
            <% if (partyApprovalRows.isEmpty()) { %>
            <tr><td colspan="7">No party approval tasks.</td></tr>
            <% } else {
              for (Map<String, Object> row : partyApprovalRows) {
                String status = valueText(row.get("status"));
            %>
            <tr>
              <td><%= valueText(row.get("approval_id")) %></td>
              <td><%= valueText(row.get("application_id")) %></td>
              <td><%= valueText(row.get("name")) %> (<%= valueText(row.get("student_id")) %>)</td>
              <td><%= valueText(row.get("class_name")) %></td>
              <td><%= valueText(row.get("reason")) %></td>
              <td><span class="pill <%= "pending".equals(status) ? "warning" : "" %>"><%= status %></span></td>
              <td>
                <% if ("pending".equals(status)) { %>
                <form action="counselorPartyApproval" method="post" style="display: inline-flex; gap: 8px;">
                  <input type="hidden" name="approvalID" value="<%= valueText(row.get("approval_id")) %>">
                  <button class="small-btn" type="submit" name="action" value="approve">Approve</button>
                  <button class="small-btn danger" type="submit" name="action" value="reject">Reject</button>
                </form>
                <% } else if ("approved".equals(status)) { %>
                <span class="pill" style="background: #d4edda; color: #155724;">Approved - Student is now a Party Member</span>
                <% } else { %>
                <span class="pill"><%= status %></span>
                <% } %>
              </td>
            </tr>
            <% }} %>
            </tbody>
          </table>
        </article>
        <% } %>

        <% if ("scholarshipReview".equals(view)) { %>
        <article class="card span-12">
          <h2>Scholarship Review</h2>
          <table>
            <thead><tr><th>Application</th><th>Student</th><th>Class</th><th>Type</th><th>Detail</th><th>Status</th><th>Review</th></tr></thead>
            <tbody>
              <% for (Map<String, Object> row : counselorScholarshipReviewRows) { %>
                <tr>
                  <td><%= valueText(row.get("app_id")) %></td>
                  <td><%= valueText(row.get("name")) %> (<%= valueText(row.get("student_id")) %>)</td>
                  <td><%= valueText(row.get("class_name")) %></td>
                  <td><%= valueText(row.get("type_code")) %></td>
                  <td>
                    <button class="small-btn js-detail" type="button"
                      data-title="Counselor Review Detail"
                      data-application="<%= attrValue(row.get("app_id")) %>"
                      data-applicant="<%= attrValue(row.get("name")) %> (<%= attrValue(row.get("student_id")) %>)"
                      data-class="<%= attrValue(row.get("class_name")) %>"
                      data-scholarship="<%= attrValue(row.get("type_code")) %>"
                      data-status="<%= attrValue(row.get("status")) %>"
                      data-amount="<%= attrValue(row.get("requested_amount")) %>"
                      data-family="<%= attrValue(row.get("family_situation")) %>"
                      data-score="<%= attrValue(row.get("academic_score")) %>"
                      data-conduct="<%= attrValue(row.get("conduct_evaluation")) %>"
                      data-honors="<%= attrValue(row.get("honors")) %>"
                      data-reason="<%= attrValue(row.get("application_reason")) %>"
                      data-materials="<%= attrValue(row.get("supporting_materials")) %>">View Detail</button>
                  </td>
                  <td><span class="pill"><%= valueText(row.get("status")) %></span></td>
                  <td>
                    <% if ("pending".equals(valueText(row.get("status")))) { %>
                      <form class="inline-form" action="scholarshipCounselorReview" method="post">
                        <input type="hidden" name="reviewID" value="<%= valueText(row.get("review_id")) %>">
                        <input type="hidden" name="appID" value="<%= valueText(row.get("app_id")) %>">
                        <input type="text" name="comment" placeholder="Comment">
                        <button class="small-btn" type="submit" name="decision" value="agree">Agree</button>
                        <button class="small-btn danger" type="submit" name="decision" value="disagree">Reject</button>
                      </form>
                    <% } else { %>
                      <span class="pill"><%= valueText(row.get("status")) %></span>
                    <% } %>
                  </td>
                </tr>
              <% } %>
              <% if (counselorScholarshipRows.isEmpty()) { %>
                <tr><td colspan="7">No scholarship applications.</td></tr>
              <% } else {
                for (Map<String, Object> row : counselorScholarshipRows) {
              %>
                <tr>
                  <td><%= valueText(row.get("app_id")) %></td>
                  <td><%= valueText(row.get("name")) %> (<%= valueText(row.get("student_id")) %>)</td>
                  <td><%= valueText(row.get("class_name")) %></td>
                  <td><%= valueText(row.get("type_code")) %></td>
                  <td>
                    <button class="small-btn js-detail" type="button"
                      data-title="Scholarship Application Detail"
                      data-application="<%= attrValue(row.get("app_id")) %>"
                      data-applicant="<%= attrValue(row.get("name")) %> (<%= attrValue(row.get("student_id")) %>)"
                      data-class="<%= attrValue(row.get("class_name")) %>"
                      data-scholarship="<%= attrValue(row.get("type_code")) %>"
                      data-status="<%= attrValue(row.get("status")) %>"
                      data-amount="<%= attrValue(row.get("requested_amount")) %>"
                      data-family="<%= attrValue(row.get("family_situation")) %>"
                      data-score="<%= attrValue(row.get("academic_score")) %>"
                      data-conduct="<%= attrValue(row.get("conduct_evaluation")) %>"
                      data-honors="<%= attrValue(row.get("honors")) %>"
                      data-reason="<%= attrValue(row.get("reason")) %>"
                      data-materials="<%= attrValue(row.get("supporting_materials")) %>">View Detail</button>
                  </td>
                  <td><span class="pill"><%= valueText(row.get("status")) %></span></td>
                  <td><span class="pill">Recorded</span></td>
                </tr>
              <% }} %>
            </tbody>
          </table>
        </article>
        <% } %>
      </section>
    </main>
  </div>
  <div class="modal-mask" id="scholarshipDetailMask" aria-hidden="true">
    <section class="profile-modal" role="dialog" aria-modal="true" aria-labelledby="scholarshipDetailTitle">
      <div class="modal-head">
        <h2 id="scholarshipDetailTitle">Application Detail</h2>
        <button class="close-modal" type="button" id="closeScholarshipDetail" aria-label="Close"><i class="fas fa-xmark"></i></button>
      </div>
      <div class="info-list" id="scholarshipDetailBody"></div>
    </section>
  </div>
  <div class="modal-mask" id="profileEditorMask" aria-hidden="true">
    <section class="profile-modal" role="dialog" aria-modal="true" aria-labelledby="profileEditorTitle">
      <div class="modal-head">
        <h2 id="profileEditorTitle">Edit Personal Info</h2>
        <button class="close-modal" type="button" id="closeProfileEditor" aria-label="Close"><i class="fas fa-xmark"></i></button>
      </div>
      <form action="updateCounselorProfile" method="post" enctype="multipart/form-data">
        <div class="form-grid">
          <label class="form-field full">
            Avatar
            <input type="file" name="avatar" accept="image/*">
          </label>
          <label class="form-field">
            Employee ID
            <input type="text" name="employeeID" value="<%= fieldValue(employeeID) %>" required <%= counselor == null ? "" : "readonly" %>>
          </label>
          <label class="form-field">
            Name
            <input type="text" name="name" value="<%= counselor == null ? "" : fieldValue(counselor.getName()) %>" required>
          </label>
          <label class="form-field">
            Gender
            <select name="gender">
              <option value="0" <%= counselor == null || counselor.getGender() == null || counselor.getGender() == 0 ? "selected" : "" %>>Unknown</option>
              <option value="1" <%= counselor != null && counselor.getGender() != null && counselor.getGender() == 1 ? "selected" : "" %>>Male</option>
              <option value="2" <%= counselor != null && counselor.getGender() != null && counselor.getGender() == 2 ? "selected" : "" %>>Female</option>
            </select>
          </label>
        </div>
        <div class="form-actions">
          <button class="secondary-btn" type="button" id="cancelProfileEditor">Cancel</button>
          <button class="primary-btn" type="submit">Save</button>
        </div>
      </form>
    </section>
  </div>
  <script>
    const scholarshipDetailMask = document.getElementById('scholarshipDetailMask');
    const scholarshipDetailBody = document.getElementById('scholarshipDetailBody');
    const scholarshipDetailTitle = document.getElementById('scholarshipDetailTitle');
    const closeScholarshipDetail = document.getElementById('closeScholarshipDetail');
    const detailLabels = {
      application: 'Application',
      applicant: 'Applicant',
      class: 'Class',
      scholarship: 'Scholarship',
      status: 'Status',
      amount: 'Requested Amount',
      family: 'Family Situation',
      score: 'Academic Score',
      conduct: 'Conduct',
      honors: 'Honors',
      reason: 'Reason',
      materials: 'Materials'
    };

    function openScholarshipDetail(button) {
      scholarshipDetailTitle.textContent = button.dataset.title || 'Application Detail';
      scholarshipDetailBody.innerHTML = Object.keys(detailLabels)
        .filter(function(key) { return button.dataset[key]; })
        .map(function(key) {
          return '<div class="info-row"><span>' + detailLabels[key] + '</span><strong>' + escapeHtml(button.dataset[key]) + '</strong></div>';
        }).join('');
      scholarshipDetailMask.classList.add('show');
      scholarshipDetailMask.setAttribute('aria-hidden', 'false');
    }

    function escapeHtml(value) {
      return String(value).replace(/[&<>"']/g, function(char) {
        return ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[char]);
      });
    }

    function closeScholarshipDetailModal() {
      scholarshipDetailMask.classList.remove('show');
      scholarshipDetailMask.setAttribute('aria-hidden', 'true');
    }

    document.querySelectorAll('.js-detail').forEach(function(button) {
      button.addEventListener('click', function() { openScholarshipDetail(button); });
    });
    closeScholarshipDetail.addEventListener('click', closeScholarshipDetailModal);
    scholarshipDetailMask.addEventListener('click', function(event) {
      if (event.target === scholarshipDetailMask) {
        closeScholarshipDetailModal();
      }
    });

    const profileMask = document.getElementById('profileEditorMask');
    const openProfileEditor = document.getElementById('openProfileEditor');
    const closeProfileEditor = document.getElementById('closeProfileEditor');
    const cancelProfileEditor = document.getElementById('cancelProfileEditor');

    function openEditor() {
      profileMask.classList.add('show');
      profileMask.setAttribute('aria-hidden', 'false');
    }

    function closeEditor() {
      profileMask.classList.remove('show');
      profileMask.setAttribute('aria-hidden', 'true');
    }

    openProfileEditor.addEventListener('click', openEditor);
    closeProfileEditor.addEventListener('click', closeEditor);
    cancelProfileEditor.addEventListener('click', closeEditor);
    profileMask.addEventListener('click', function(event) {
      if (event.target === profileMask) {
        closeEditor();
      }
    });
  </script>
</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.se.model.entity.Users" %>
<%@ page import="org.se.model.entity.Counselor" %>
<%@ page import="org.se.model.entity.ProfileImage" %>
<%@ page import="org.se.model.dao.CounselorDAO" %>
<%@ page import="org.se.model.dao.ProfileImageDao" %>
<%@ page import="org.se.model.dao.DashboardDao" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
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
  ProfileImageDao profileImageDao = new ProfileImageDao();
  DashboardDao dashboardDao = new DashboardDao();
  Counselor counselor = counselorDAO.findByAccount(currentUser.getAccount());
  String employeeID = counselor == null ? currentUser.getAccount() : counselor.getEmployeeID();
  ProfileImage profileImage = profileImageDao.findByOwner(currentUser.getUserType(), currentUser.getAccount());
  String avatarPath = profileImage == null || profileImage.getImagePath() == null ? "static/img/maomao.jpg" : profileImage.getImagePath();
  List<Map<String, Object>> counselorClassRows = dashboardDao.findCounselorClasses(employeeID);
  List<Map<String, Object>> counselorStudentRows = dashboardDao.findCounselorStudents(employeeID);
  List<Map<String, Object>> counselorMeetingRows = dashboardDao.findCounselorMeetings(employeeID);
  int partyApplicationCount = dashboardDao.countCounselorPartyApplications(employeeID);
  int scholarshipApplicationCount = dashboardDao.countCounselorScholarshipApplications(employeeID);
  String profileStatus = request.getParameter("profile");
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
        <a class="active" href="#"><i class="fas fa-user-friends"></i>Overview</a>
        <a href="#"><i class="fas fa-id-card"></i>Personal Info</a>
        <a href="#"><i class="fas fa-users"></i>My Students</a>
        <a href="#"><i class="fas fa-school"></i>Classes</a>
        <a href="#"><i class="fas fa-flag"></i>Party Review</a>
        <a href="#"><i class="fas fa-award"></i>Scholarship</a>
        <a href="#"><i class="fas fa-calendar-check"></i>Class Meetings</a>
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
        <article class="card metric featured span-3"><strong><%= counselorClassRows.size() %></strong><span>Managed Classes</span></article>
        <article class="card metric span-3"><strong><%= counselorStudentRows.size() %></strong><span>My Students</span></article>
        <article class="card metric warning span-3"><strong><%= partyApplicationCount %></strong><span>Party Applications</span></article>
        <article class="card metric span-3"><strong><%= scholarshipApplicationCount %></strong><span>Scholarship Reviews</span></article>

        <article class="card span-4">
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

        <article class="card span-8">
          <h2>My Students</h2>
          <table>
            <thead><tr><th>Student</th><th>Class</th><th>Party Application</th><th>Scholarship</th><th>Attention</th></tr></thead>
            <tbody>
              <% if (counselorStudentRows.isEmpty()) { %>
                <tr><td colspan="5">No students assigned.</td></tr>
              <% } else {
                for (Map<String, Object> row : counselorStudentRows) {
                  boolean pending = "pending".equalsIgnoreCase(valueText(row.get("party_status")))
                          || "pending".equalsIgnoreCase(valueText(row.get("scholarship_status")));
              %>
                <tr>
                  <td><%= valueText(row.get("name")) %></td>
                  <td><%= valueText(row.get("class_name")) %></td>
                  <td><span class="pill <%= pending ? "warning" : "" %>"><%= valueText(row.get("party_status")) %></span></td>
                  <td><span class="pill"><%= valueText(row.get("scholarship_status")) %></span></td>
                  <td><%= pending ? "Needs review" : "Normal" %></td>
                </tr>
              <% }} %>
            </tbody>
          </table>
        </article>

        <article class="card span-6">
          <h2>Class Meetings</h2>
          <table>
            <thead><tr><th>Theme</th><th>Class</th><th>Classroom</th></tr></thead>
            <tbody>
              <% if (counselorMeetingRows.isEmpty()) { %>
                <tr><td colspan="3">No class meetings.</td></tr>
              <% } else {
                for (Map<String, Object> row : counselorMeetingRows) {
              %>
                <tr><td><%= valueText(row.get("meeting_theme")) %></td><td><%= valueText(row.get("class_name")) %></td><td><%= valueText(row.get("classroom")) %></td></tr>
              <% }} %>
            </tbody>
          </table>
        </article>

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
      </section>
    </main>
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

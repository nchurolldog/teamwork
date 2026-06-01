<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.se.model.entity.Users" %>
<%@ page import="org.se.model.entity.Student" %>
<%@ page import="org.se.model.entity.PersonalInfo" %>
<%@ page import="org.se.model.entity.FamilyInfo" %>
<%@ page import="org.se.model.entity.ProfileImage" %>
<%@ page import="org.se.model.dao.StudentDAO" %>
<%@ page import="org.se.model.dao.PersonalInfoDao" %>
<%@ page import="org.se.model.dao.FamilyInfoDao" %>
<%@ page import="org.se.model.dao.ProfileImageDao" %>
<%@ page import="org.se.model.dao.DashboardDao" %>
<%@ page import="org.se.model.dao.PartyApplicationDao" %>
<%@ page import="org.se.model.dao.ScholarshipApplicationDao" %>
<%@ page import="org.se.model.entity.PartyApplication" %>
<%@ page import="org.se.model.entity.ScholarshipApplication" %>
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

  private String firstStatus(List<?> rows, String emptyText) {
    if (rows == null || rows.isEmpty()) return emptyText;
    Object first = rows.get(0);
    if (first instanceof PartyApplication) return textOrDash(((PartyApplication) first).getStatus());
    if (first instanceof ScholarshipApplication) return textOrDash(((ScholarshipApplication) first).getStatus());
    return emptyText;
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
  if (currentUser.getUserType() == null || currentUser.getUserType() != 3) {
    response.sendRedirect("index.jsp");
    return;
  }
  StudentDAO studentDAO = new StudentDAO();
  PersonalInfoDao personalInfoDao = new PersonalInfoDao();
  FamilyInfoDao familyInfoDao = new FamilyInfoDao();
  ProfileImageDao profileImageDao = new ProfileImageDao();
  DashboardDao dashboardDao = new DashboardDao();
  PartyApplicationDao partyApplicationDao = new PartyApplicationDao();
  ScholarshipApplicationDao scholarshipApplicationDao = new ScholarshipApplicationDao();
  Student student = studentDAO.findByAccount(currentUser.getAccount());
  String studentID = student == null ? currentUser.getAccount() : student.getStudentID();
  PersonalInfo personalInfo = studentID == null ? null : personalInfoDao.findById(studentID);
  FamilyInfo familyInfo = studentID == null ? null : familyInfoDao.findById(studentID);
  ProfileImage profileImage = profileImageDao.findByOwner(currentUser.getUserType(), currentUser.getAccount());
  String avatarPath = profileImage == null || profileImage.getImagePath() == null ? "static/img/maomao.jpg" : profileImage.getImagePath();
  List<Map<String, Object>> classRows = dashboardDao.findStudentClasses(studentID);
  List<Map<String, Object>> classmateRows = dashboardDao.findClassmates(studentID);
  List<Map<String, Object>> gradeRows = dashboardDao.findStudentGrades(studentID);
  List<Map<String, Object>> meetingRows = dashboardDao.findStudentMeetings(studentID);
  List<PartyApplication> partyRows = partyApplicationDao.findByStudentId(studentID);
  List<ScholarshipApplication> scholarshipRows = scholarshipApplicationDao.findByStudentID(studentID);
  String profileStatus = request.getParameter("profile");
  String view = request.getParameter("view") == null ? "personal" : request.getParameter("view");
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
    @media (max-width: 900px) { .shell { grid-template-columns: 1fr; } .sidebar { display: none; } .span-4, .span-6, .span-8 { grid-column: span 12; } }
  </style>
</head>
<body>
  <div class="shell">
    <aside class="sidebar">
      <div class="brand"><img src="static/img/favicon.ico" alt="Logo"><span>SEInformation</span></div>
      <nav class="nav">
        <a class="<%= activeNav(view, "personal") %>" href="student.jsp"><i class="fas fa-id-card"></i>Personal</a>
        <a class="<%= activeNav(view, "class") %>" href="student.jsp?view=class"><i class="fas fa-users"></i>Class</a>
        <a class="<%= activeNav(view, "grades") %>" href="student.jsp?view=grades"><i class="fas fa-chart-line"></i>Grades</a>
        <a class="<%= activeNav(view, "applications") %>" href="student.jsp?view=applications"><i class="fas fa-award"></i>Scholarship</a>
        <a class="<%= activeNav(view, "applications") %>" href="student.jsp?view=applications"><i class="fas fa-flag"></i>Party Application</a>
        <a class="<%= activeNav(view, "meetings") %>" href="student.jsp?view=meetings"><i class="fas fa-calendar-check"></i>Meetings</a>
      </nav>
      <a class="logout" href="logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </aside>

    <main class="content">
      <div class="top">
        <div>
          <h1>Student Workspace</h1>
          <div class="account">Account: <%= currentUser.getAccount() %></div>
        </div>
        <div class="top-actions">
          <img class="avatar" src="<%= avatarPath %>" alt="Avatar">
          <span class="pill">Student</span>
        </div>
      </div>

      <section class="grid">
        <% if ("saved".equals(profileStatus)) { %>
          <div class="notice">Personal information updated.</div>
        <% } else if ("failed".equals(profileStatus)) { %>
          <div class="notice error">Personal information update failed. Please check required fields.</div>
        <% } %>
        <% if ("personal".equals(view)) { %>
        <article class="card span-12">
          <div class="card-head">
            <h2>Personal Info</h2>
            <button class="edit-profile" type="button" id="openProfileEditor"><i class="fas fa-pen-to-square"></i><span>Edit</span></button>
          </div>
          <div class="info-list">
            <div class="info-row"><span>Name</span><strong><%= student == null ? "Waiting for profile data" : textOrDash(student.getName()) %></strong></div>
            <div class="info-row"><span>Student ID</span><strong><%= textOrDash(studentID) %></strong></div>
            <div class="info-row"><span>Gender</span><strong><%= student == null ? "-" : genderText(student.getGender()) %></strong></div>
            <div class="info-row"><span>Position</span><strong><%= student == null ? "-" : textOrDash(student.getPosition()) %></strong></div>
            <div class="info-row"><span>Origin Place</span><strong><%= personalInfo == null ? "-" : textOrDash(personalInfo.getOriginPlace()) %></strong></div>
            <div class="info-row"><span>Political Status</span><strong><%= personalInfo == null ? "-" : textOrDash(personalInfo.getPoliticalStatus()) %></strong></div>
          </div>
        </article>
        <% } %>

        <% if ("class".equals(view)) { %>
        <article class="card span-4">
          <h2>Class Info</h2>
          <div class="info-list">
            <% if (classRows.isEmpty()) { %>
              <div class="info-row"><span>Class</span><strong>Not assigned</strong></div>
              <div class="info-row"><span>Teacher</span><strong>-</strong></div>
              <div class="info-row"><span>Counselor</span><strong>-</strong></div>
            <% } else {
              Map<String, Object> classRow = classRows.get(0);
            %>
              <div class="info-row"><span>Class</span><strong><%= valueText(classRow.get("class_name")) %></strong></div>
              <div class="info-row"><span>Teacher</span><strong><%= valueText(classRow.get("teacher_name")) %></strong></div>
              <div class="info-row"><span>Counselor</span><strong><%= valueText(classRow.get("counselor_name")) %></strong></div>
            <% } %>
          </div>
        </article>

          <article class="card span-8">
            <h2>Class Detail</h2>
            <table>
              <thead><tr><th>Student ID</th><th>Name</th><th>Position</th><th>Gender</th><th>Class</th></tr></thead>
              <tbody>
                <% if (classmateRows.isEmpty()) { %>
                  <tr><td colspan="5">No classmates found.</td></tr>
                <% } else {
                  for (Map<String, Object> row : classmateRows) {
                %>
                  <tr>
                    <td><%= valueText(row.get("student_id")) %></td>
                    <td><%= valueText(row.get("name")) %></td>
                    <td><%= valueText(row.get("position")) %></td>
                    <td><%= genderText(row.get("gender") instanceof Number ? ((Number) row.get("gender")).intValue() : null) %></td>
                    <td><%= valueText(row.get("class_name")) %></td>
                  </tr>
                <% }} %>
              </tbody>
            </table>
          </article>
        <% } %>

        <% if ("applications".equals(view)) { %>
        <article class="card span-12" id="applications">
          <h2>Application Status</h2>
          <div class="info-list">
            <div class="info-row"><span>Party Application</span><span class="pill warning"><%= firstStatus(partyRows, "Not Submitted") %></span></div>
            <div class="info-row"><span>Scholarship</span><span class="pill"><%= firstStatus(scholarshipRows, "No Active Application") %></span></div>
          </div>
        </article>
        <% } %>

        <% if ("grades".equals(view)) { %>
        <article class="card span-12" id="grades">
          <h2>Grades</h2>
          <table>
            <thead><tr><th>Course</th><th>Regular</th><th>Final</th><th>Total</th></tr></thead>
            <tbody>
              <% if (gradeRows.isEmpty()) { %>
                <tr><td colspan="4">No grade records.</td></tr>
              <% } else {
                for (Map<String, Object> gradeRow : gradeRows) {
              %>
                <tr>
                  <td><%= valueText(gradeRow.get("course_name")) %></td>
                  <td><%= valueText(gradeRow.get("regular_grade")) %></td>
                  <td><%= valueText(gradeRow.get("final_grade")) %></td>
                  <td><%= valueText(gradeRow.get("total_grade")) %></td>
                </tr>
              <% }} %>
            </tbody>
          </table>
        </article>
        <% } %>

        <% if ("meetings".equals(view)) { %>
        <article class="card span-12" id="meetings">
          <h2>Class Meetings</h2>
          <div class="info-list">
            <% if (meetingRows.isEmpty()) { %>
              <div class="info-row"><span>Theme</span><strong>No meetings</strong></div>
              <div class="info-row"><span>Classroom</span><strong>-</strong></div>
              <div class="info-row"><span>Status</span><span class="pill">None</span></div>
            <% } else {
              for (Map<String, Object> meetingRow : meetingRows) {
            %>
              <div class="info-row"><span><%= valueText(meetingRow.get("meeting_theme")) %></span><strong><%= valueText(meetingRow.get("classroom")) %></strong></div>
            <% }} %>
          </div>
        </article>
        <% } %>
      </section>
    </main>
  </div>

  <div class="modal-mask" id="profileEditorMask" aria-hidden="true">
    <section class="profile-modal" role="dialog" aria-modal="true" aria-labelledby="profileEditorTitle">
      <div class="modal-head">
        <h2 id="profileEditorTitle">Edit Personal Info</h2>
        <button class="close-modal" type="button" id="closeProfileEditor" aria-label="Close"><i class="fas fa-xmark"></i></button>
      </div>
      <form action="updateStudentProfile" method="post" enctype="multipart/form-data">
        <div class="form-grid">
          <label class="form-field full">
            Avatar
            <input type="file" name="avatar" accept="image/*">
          </label>
          <label class="form-field">
            Student ID
            <input type="text" name="studentID" value="<%= fieldValue(studentID) %>" required <%= student == null ? "" : "readonly" %>>
          </label>
          <label class="form-field">
            Name
            <input type="text" name="name" value="<%= student == null ? "" : fieldValue(student.getName()) %>" required>
          </label>
          <label class="form-field">
            Gender
            <select name="gender">
              <option value="0" <%= student == null || student.getGender() == null || student.getGender() == 0 ? "selected" : "" %>>Unknown</option>
              <option value="1" <%= student != null && student.getGender() != null && student.getGender() == 1 ? "selected" : "" %>>Male</option>
              <option value="2" <%= student != null && student.getGender() != null && student.getGender() == 2 ? "selected" : "" %>>Female</option>
            </select>
          </label>
          <label class="form-field">
            Position
            <select name="position">
              <option value="学生" <%= student == null || student.getPosition() == null || "学生".equals(student.getPosition()) ? "selected" : "" %>>学生</option>
              <option value="班长" <%= student != null && "班长".equals(student.getPosition()) ? "selected" : "" %>>班长</option>
              <option value="学习委员" <%= student != null && "学习委员".equals(student.getPosition()) ? "selected" : "" %>>学习委员</option>
            </select>
          </label>
          <label class="form-field full">
            Origin Place
            <input type="text" name="originPlace" value="<%= personalInfo == null ? "" : fieldValue(personalInfo.getOriginPlace()) %>">
          </label>
          <label class="form-field full">
            Political Status
            <select name="politicalStatus">
              <option value="团员" <%= personalInfo == null || personalInfo.getPoliticalStatus() == null || "团员".equals(personalInfo.getPoliticalStatus()) ? "selected" : "" %>>团员</option>
              <option value="党员" <%= personalInfo != null && "党员".equals(personalInfo.getPoliticalStatus()) ? "selected" : "" %>>党员</option>
              <option value="群众" <%= personalInfo != null && "群众".equals(personalInfo.getPoliticalStatus()) ? "selected" : "" %>>群众</option>
            </select>
          </label>
          <label class="form-field full">
            Home Address
            <input type="text" name="homeAddress" value="<%= familyInfo == null ? "" : fieldValue(familyInfo.getHomeAddress()) %>">
          </label>
          <label class="form-field">
            Family Size
            <input type="number" name="familySize" min="0" value="<%= familyInfo == null || familyInfo.getFamilySize() == null ? "" : familyInfo.getFamilySize() %>">
          </label>
          <label class="form-field">
            Family Phone
            <input type="text" name="familyPhone" value="<%= familyInfo == null ? "" : fieldValue(familyInfo.getPhone()) %>">
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

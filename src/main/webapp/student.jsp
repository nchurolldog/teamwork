<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="org.se.model.dao.*" %>
<%@ page import="org.se.model.entity.*" %>
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

  private String firstStatus(List<?> rows, String emptyText) {
    if (rows == null || rows.isEmpty()) return emptyText;
    Object first = rows.get(0);
    if (first instanceof PartyApplication) {
      String status = ((PartyApplication) first).getStatus();
      if (status == null) return emptyText;
      switch (status) {
        case "pending": return "Pending Counselor Review";
        case "counselor_approved": return "Waiting Democratic Review";
        case "review_passed": return "Waiting Development Inspection";
        case "inspection_approved": return "Waiting Final Approval";
        case "approved": return "Approved - Party Member";
        case "rejected": return "Rejected by Counselor";
        case "review_failed": return "Democratic Review Failed";
        case "inspection_rejected": return "Development Inspection Failed";
        case "approval_rejected": return "Final Approval Failed";
        default: return status;
      }
    }
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
  ClassMeetingDAO classMeetingDAO = new ClassMeetingDAO();
  StudentClassDao studentClassDao = new StudentClassDao();
  PartyApplicationDao partyApplicationDao = new PartyApplicationDao();
  DemocraticReviewDao democraticReviewDao = new DemocraticReviewDao();
  ScholarshipApplicationDao scholarshipApplicationDao = new ScholarshipApplicationDao();
  ScholarshipWorkflowDao scholarshipWorkflowDao = new ScholarshipWorkflowDao();
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

  List<Map<String, Object>> studentClasses = dashboardDao.findStudentClasses(studentID);
  Integer currentClassID = null;
  if (!studentClasses.isEmpty()) {
      currentClassID = (Integer) studentClasses.get(0).get("class_id");
  }

  List<Map<String, Object>> classMeetings = currentClassID != null ?
      dashboardDao.findClassMeetingsByClassId(currentClassID) : new java.util.ArrayList<>();

  boolean isMonitor = student != null && "班长".equals(student.getPosition());
  String editMeetingID = request.getParameter("edit");
  ClassMeeting editMeeting = editMeetingID != null ? classMeetingDAO.findById(editMeetingID) : null;

  String createStatus = request.getParameter("status");

  List<Map<String, Object>> appliedScholarshipRows = dashboardDao.findStudentScholarshipApplications(studentID);
  List<Map<String, Object>> availableScholarshipRows = dashboardDao.findAvailableScholarships(studentID);
  List<Map<String, Object>> publishedScholarshipRows = dashboardDao.findPublishedScholarships();
  List<Map<String, Object>> scholarshipVoteRows = scholarshipWorkflowDao.findStudentVoteTasks(studentID);

  DemocraticReviewParticipantDao participantDao = new DemocraticReviewParticipantDao();
  List<DemocraticReviewParticipant> partyVoteTasks = participantDao.findByStudentId(studentID);

  List<PartyApplication> partyRows = partyApplicationDao.findByStudentId(studentID);
  List<ScholarshipApplication> scholarshipRows = scholarshipApplicationDao.findByStudentID(studentID);

  String selectedAppID = request.getParameter("appId");
  Map<String, Object> selectedScholarship = null;
  for (Map<String, Object> row : appliedScholarshipRows) {
    if (selectedAppID != null && selectedAppID.equals(valueText(row.get("app_id")))) {
      selectedScholarship = row;
      break;
    }
  }
  String scholarshipStatus = request.getParameter("scholarship");
  String voteStatus = request.getParameter("vote");
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
    .scholarship-grid { display: grid; grid-template-columns: repeat(12, 1fr); gap: 18px; }
    .scholarship-grid .wide { grid-column: span 8; }
    .scholarship-grid .side { grid-column: span 4; }
    textarea { width: 100%; min-height: 76px; border: 1px solid var(--line); border-radius: 8px; padding: 10px 12px; font: inherit; color: var(--ink); resize: vertical; }
    .application-card { border: 1px solid var(--line); border-radius: 8px; padding: 16px; background: #fbfdfe; display: grid; gap: 14px; }
    .application-title { display: flex; justify-content: space-between; gap: 12px; align-items: center; }
    .application-title strong { font-size: 16px; color: var(--ink); }
    .application-form { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 12px; }
    .application-form label { display: grid; gap: 7px; color: var(--muted); font-size: 13px; font-weight: 700; }
    .application-form label.full { grid-column: 1 / -1; }
    .application-form input, .application-form select { width: 100%; height: 40px; border: 1px solid var(--line); border-radius: 8px; padding: 0 10px; font: inherit; color: var(--ink); background: white; }
    .checkbox-field { display: flex !important; grid-column: 1 / -1; align-items: center; gap: 8px; }
    .checkbox-field input { width: 16px; height: 16px; }
    .apply-actions { grid-column: 1 / -1; display: flex; justify-content: flex-end; }
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
        <a class="<%= activeNav(view, "scholarship") %>" href="student.jsp?view=scholarship"><i class="fas fa-award"></i>Scholarship</a>
        <a class="<%= activeNav(view, "party") %>" href="student.jsp?view=party"><i class="fas fa-flag"></i>Party Application</a>
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

        <% if ("party".equals(view)) { %>
        <article class="card span-12">
          <h2>My Party Application</h2>
          <div class="info-list">
            <div class="info-row"><span>Current Status</span><span class="pill warning"><%= firstStatus(partyRows, "Not Submitted") %></span></div>
            <% if (partyRows == null || partyRows.isEmpty()) { %>
            <div class="info-row"><span>Application</span><strong>No party application record.</strong></div>
            <% } else {
              for (PartyApplication row : partyRows) {
            %>
            <div class="info-row"><span><%= textOrDash(row.getApplicationID()) %></span><strong><%= textOrDash(row.getReason()) %></strong></div>
            <% }} %>
          </div>
        </article>

        <article class="card span-12" style="margin-top: 18px;">
          <h2>Democratic Review Tasks</h2>
          <table>
            <thead><tr><th>Review ID</th><th>Applicant</th><th>Status</th><th>Your Vote</th><th>Action</th></tr></thead>
            <tbody>
            <%
              boolean hasPartyVoteTasks = false;
              if (partyVoteTasks != null && !partyVoteTasks.isEmpty()) {
                for (DemocraticReviewParticipant task : partyVoteTasks) {
                  DemocraticReview review = democraticReviewDao.findById(task.getReviewID());
                  if (review != null) {
                    PartyApplication app = partyApplicationDao.findById(review.getApplicationID());
                    Student applicant = app != null ? studentDAO.findById(app.getApplicantStudentID()) : null;
                    hasPartyVoteTasks = true;
            %>
            <tr>
              <td><%= textOrDash(task.getReviewID()) %></td>
              <td><%= applicant == null ? "-" : textOrDash(applicant.getName()) %> (<%= applicant == null ? "-" : textOrDash(applicant.getStudentID()) %>)</td>
              <td><span class="pill"><%= review != null ? textOrDash(review.getStatus()) : "-" %></span></td>
              <td>
                <% if (task.getAccess() != null && task.getAccess()) { %>
                <span class="pill" style="background: #d4edda; color: #155724;">Agreed</span>
                <% } else if (task.getAccess() != null && !task.getAccess()) { %>
                <span class="pill" style="background: #f8d7da; color: #721c24;">Disagreed</span>
                <% } else { %>
                <span class="pill warning">Not Voted</span>
                <% } %>
              </td>
              <td>
                <% if (review != null && "voting".equals(review.getStatus()) && task.getAccess() == null) { %>
                <form action="studentPartyVote" method="post" style="display: inline-flex; gap: 8px; align-items: center;">
                  <input type="hidden" name="reviewID" value="<%= task.getReviewID() %>">
                  <select name="vote" required style="height: 34px; border: 1px solid var(--line); border-radius: 6px; padding: 0 8px;">
                    <option value="">Select</option>
                    <option value="agree">Agree</option>
                    <option value="disagree">Disagree</option>
                  </select>
                  <button class="primary-btn" type="submit" style="font-size: 12px; padding: 5px 10px; height: auto;">Submit Vote</button>
                </form>
                <% } else if (review != null && "voting".equals(review.getStatus())) { %>
                <span style="color: var(--muted); font-size: 13px;">Voted</span>
                <% } else { %>
                <span style="color: var(--muted); font-size: 13px;">Review <%= review != null ? review.getStatus() : "unknown" %></span>
                <% } %>
              </td>
            </tr>
            <%
                  }
                }
              }
              if (!hasPartyVoteTasks) {
            %>
            <tr><td colspan="5">No democratic review tasks.</td></tr>
            <% } %>
            </tbody>
          </table>
        </article>
        <% } %>

        <% if ("scholarship".equals(view)) { %>
          <% if ("saved".equals(scholarshipStatus)) { %>
            <div class="notice">Scholarship application submitted.</div>
          <% } else if ("duplicate".equals(scholarshipStatus)) { %>
            <div class="notice error">You have already applied for this scholarship.</div>
          <% } else if ("failed".equals(scholarshipStatus)) { %>
            <div class="notice error">Scholarship application failed.</div>
          <% } %>
          <% if ("saved".equals(voteStatus)) { %>
            <div class="notice">Democratic review vote submitted.</div>
          <% } else if ("failed".equals(voteStatus)) { %>
            <div class="notice error">Democratic review vote failed.</div>
          <% } %>
          <article class="card span-12" id="applications">
            <h2>Scholarship Status</h2>
            <div class="info-list">
              <div class="info-row"><span>Scholarship</span><span class="pill"><%= firstStatus(scholarshipRows, "No Active Application") %></span></div>
            </div>
          </article>

          <div class="span-12 scholarship-grid">
            <article class="card wide">
              <h2>Available Scholarships</h2>
              <div class="info-list">
                <% if (availableScholarshipRows.isEmpty()) { %>
                  <div class="info-row"><span>Available</span><strong>No available scholarships.</strong></div>
                <% } else { %>
                  <div class="application-card">
                    <div class="application-title">
                      <strong id="selectedScholarshipDescription"><%= valueText(availableScholarshipRows.get(0).get("description")) %></strong>
                      <span class="pill">Ready to apply</span>
                    </div>
                    <form class="application-form" action="applyScholarship" method="post">
                      <label class="full">
                        Scholarship Type
                        <select id="scholarshipTypeSelect" name="typeCode" required>
                          <% for (Map<String, Object> row : availableScholarshipRows) { %>
                            <option value="<%= attrValue(row.get("type_code")) %>" data-description="<%= attrValue(row.get("description")) %>">
                              <%= valueText(row.get("type_code")) %> - <%= valueText(row.get("description")) %>
                            </option>
                          <% } %>
                        </select>
                      </label>
                      <label>
                        Applicant
                        <input type="text" value="<%= student == null ? "" : fieldValue(student.getName()) %>" readonly>
                      </label>
                      <label>
                        Student ID
                        <input type="text" value="<%= fieldValue(studentID) %>" readonly>
                      </label>
                      <label>
                        Requested Amount
                        <input type="number" name="amount" min="0" step="0.01" placeholder="e.g. 1200">
                      </label>
                      <label>
                        Family Situation
                        <select name="familySituation" required>
                          <option value="">Select</option>
                          <option value="Normal">Normal</option>
                          <option value="Financial Difficulty">Financial Difficulty</option>
                          <option value="Special Difficulty">Special Difficulty</option>
                        </select>
                      </label>
                      <label>
                        GPA / Average Score
                        <input type="text" name="academicScore" placeholder="e.g. 91.5" required>
                      </label>
                      <label>
                        Conduct Evaluation
                        <select name="conductEvaluation" required>
                          <option value="">Select</option>
                          <option value="Excellent">Excellent</option>
                          <option value="Good">Good</option>
                          <option value="Qualified">Qualified</option>
                        </select>
                      </label>
                      <label class="full">
                        Honors / Awards
                        <textarea name="honors" placeholder="List awards, competitions, volunteer work, class contributions"></textarea>
                      </label>
                      <label class="full">
                        Application Reason
                        <textarea name="reason" placeholder="Explain why you are applying, your academic performance, family situation, and future plan" required></textarea>
                      </label>
                      <label class="full">
                        Supporting Materials
                        <textarea name="materials" placeholder="Describe certificates or documents you will submit offline"></textarea>
                      </label>
                      <label class="checkbox-field">
                        <input type="checkbox" name="promise" value="true" required>
                        I promise the submitted information is true and accept review/publicity.
                      </label>
                      <div class="apply-actions">
                        <button class="primary-btn" type="submit">Submit Application</button>
                      </div>
                    </form>
                  </div>
                <% } %>
              </div>
            </article>

            <article class="card side">
              <h2>Application Detail</h2>
              <div class="info-list">
                <% if (selectedScholarship == null) { %>
                  <div class="info-row"><span>Status</span><strong>Select an application.</strong></div>
                <% } else { %>
                  <div class="info-row"><span>Application</span><strong><%= valueText(selectedScholarship.get("app_id")) %></strong></div>
                  <div class="info-row"><span>Type</span><strong><%= valueText(selectedScholarship.get("type_code")) %></strong></div>
                  <div class="info-row"><span>Description</span><strong><%= valueText(selectedScholarship.get("description")) %></strong></div>
                  <div class="info-row"><span>Status</span><span class="pill"><%= valueText(selectedScholarship.get("status")) %></span></div>
                  <div class="info-row"><span>Requested Amount</span><strong><%= valueText(selectedScholarship.get("requested_amount")) %></strong></div>
                  <div class="info-row"><span>Family Situation</span><strong><%= valueText(selectedScholarship.get("family_situation")) %></strong></div>
                  <div class="info-row"><span>Academic Score</span><strong><%= valueText(selectedScholarship.get("academic_score")) %></strong></div>
                  <div class="info-row"><span>Conduct</span><strong><%= valueText(selectedScholarship.get("conduct_evaluation")) %></strong></div>
                  <div class="info-row"><span>Honors</span><strong><%= valueText(selectedScholarship.get("honors")) %></strong></div>
                  <div class="info-row"><span>Reason</span><strong><%= valueText(selectedScholarship.get("application_reason")) %></strong></div>
                  <div class="info-row"><span>Materials</span><strong><%= valueText(selectedScholarship.get("supporting_materials")) %></strong></div>
                <% } %>
              </div>
            </article>
          </div>

          <article class="card span-12">
            <h2>Democratic Review Tasks</h2>
            <table>
              <thead><tr><th>Applicant</th><th>Class</th><th>Scholarship</th><th>Status</th><th>Vote</th></tr></thead>
              <tbody>
                <% if (scholarshipVoteRows.isEmpty()) { %>
                  <tr><td colspan="5">No democratic review tasks.</td></tr>
                <% } else {
                  for (Map<String, Object> row : scholarshipVoteRows) {
                %>
                  <tr>
                    <td><%= valueText(row.get("applicant_name")) %> (<%= valueText(row.get("applicant_id")) %>)</td>
                    <td><%= valueText(row.get("class_name")) %></td>
                    <td><%= valueText(row.get("type_code")) %></td>
                    <td><span class="pill"><%= valueText(row.get("review_status")) %></span></td>
                    <td>
                      <button class="secondary-btn js-detail" type="button"
                        data-title="Democratic Review Detail"
                        data-application="<%= attrValue(row.get("app_id")) %>"
                        data-applicant="<%= attrValue(row.get("applicant_name")) %> (<%= attrValue(row.get("applicant_id")) %>)"
                        data-class="<%= attrValue(row.get("class_name")) %>"
                        data-scholarship="<%= attrValue(row.get("type_code")) %>"
                        data-status="<%= attrValue(row.get("review_status")) %>"
                        data-amount="<%= attrValue(row.get("requested_amount")) %>"
                        data-family="<%= attrValue(row.get("family_situation")) %>"
                        data-score="<%= attrValue(row.get("academic_score")) %>"
                        data-conduct="<%= attrValue(row.get("conduct_evaluation")) %>"
                        data-honors="<%= attrValue(row.get("honors")) %>"
                        data-reason="<%= attrValue(row.get("application_reason")) %>"
                        data-materials="<%= attrValue(row.get("supporting_materials")) %>">View Detail</button>
                      <% if (row.get("agree") == null && "pending".equals(valueText(row.get("review_status")))) { %>
                        <form class="application-form" action="scholarshipVote" method="post">
                          <input type="hidden" name="reviewID" value="<%= valueText(row.get("review_id")) %>">
                          <label>
                            Decision
                            <select name="vote" required>
                              <option value="agree">Agree</option>
                              <option value="disagree">Disagree</option>
                            </select>
                          </label>
                          <label>
                            Comment
                            <input type="text" name="comment" placeholder="Your opinion">
                          </label>
                          <div class="apply-actions"><button class="primary-btn" type="submit">Submit Vote</button></div>
                        </form>
                      <% } else { %>
                        <span class="pill"><%= Boolean.TRUE.equals(row.get("agree")) ? "Agreed" : "Voted" %></span>
                      <% } %>
                    </td>
                  </tr>
                <% }} %>
              </tbody>
            </table>
          </article>

          <article class="card span-12">
            <h2>Applied Scholarships</h2>
            <table>
              <thead><tr><th>Application</th><th>Type</th><th>Description</th><th>Status</th><th>Detail</th></tr></thead>
              <tbody>
                <% if (appliedScholarshipRows.isEmpty()) { %>
                  <tr><td colspan="5">No scholarship applications.</td></tr>
                <% } else {
                  for (Map<String, Object> row : appliedScholarshipRows) {
                %>
                  <tr>
                    <td><%= valueText(row.get("app_id")) %></td>
                    <td><%= valueText(row.get("type_code")) %></td>
                    <td><%= valueText(row.get("description")) %></td>
                    <td><span class="pill"><%= valueText(row.get("status")) %></span></td>
                    <td>
                      <button class="secondary-btn js-detail" type="button"
                        data-title="Application Detail"
                        data-application="<%= attrValue(row.get("app_id")) %>"
                        data-scholarship="<%= attrValue(row.get("type_code")) %>"
                        data-description="<%= attrValue(row.get("description")) %>"
                        data-status="<%= attrValue(row.get("status")) %>"
                        data-amount="<%= attrValue(row.get("requested_amount")) %>"
                        data-family="<%= attrValue(row.get("family_situation")) %>"
                        data-score="<%= attrValue(row.get("academic_score")) %>"
                        data-conduct="<%= attrValue(row.get("conduct_evaluation")) %>"
                        data-honors="<%= attrValue(row.get("honors")) %>"
                        data-reason="<%= attrValue(row.get("application_reason")) %>"
                        data-materials="<%= attrValue(row.get("supporting_materials")) %>">View Detail</button>
                    </td>
                  </tr>
                <% }} %>
              </tbody>
            </table>
          </article>

          <article class="card span-12">
            <h2>Published Scholarships</h2>
            <table>
              <thead><tr><th>Student</th><th>Class</th><th>Type</th><th>Description</th><th>Status</th></tr></thead>
              <tbody>
                <% if (publishedScholarshipRows.isEmpty()) { %>
                  <tr><td colspan="5">No published scholarships.</td></tr>
                <% } else {
                  for (Map<String, Object> row : publishedScholarshipRows) {
                %>
                  <tr>
                    <td><%= valueText(row.get("name")) %></td>
                    <td><%= valueText(row.get("class_name")) %></td>
                    <td><%= valueText(row.get("type_code")) %></td>
                    <td><%= valueText(row.get("description")) %></td>
                    <td><span class="pill"><%= valueText(row.get("status")) %></span></td>
                  </tr>
                <% }} %>
              </tbody>
            </table>
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
          <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
            <h2 style="margin: 0;">Class Meetings</h2>
            <% if (isMonitor && currentClassID != null) { %>
              <button class="primary-btn" type="button" onclick="showCreateForm()">+ Create Meeting</button>
            <% } %>
          </div>

          <% if ("created".equals(createStatus)) { %>
            <div class="notice">Meeting created successfully!</div>
          <% } else if ("updated".equals(createStatus)) { %>
            <div class="notice">Meeting updated successfully!</div>
          <% } else if ("deleted".equals(createStatus)) { %>
            <div class="notice">Meeting deleted successfully!</div>
          <% } else if ("error".equals(createStatus)) { %>
            <div class="notice error">Operation failed. Please try again.</div>
          <% } %>

          <% if (editMeeting != null) { %>
          <div class="application-card" style="margin-bottom: 18px;">
            <h3 style="margin: 0 0 14px 0;">Edit Meeting</h3>
            <form action="manageClassMeeting" method="post" class="application-form">
              <input type="hidden" name="action" value="update">
              <input type="hidden" name="meetingID" value="<%= editMeeting.getMeetingID() %>">
              <label>
                Meeting ID
                <input type="text" name="meetingID_display" value="<%= editMeeting.getMeetingID() %>" readonly>
              </label>
              <label>
                Class ID
                <input type="number" name="classID" value="<%= editMeeting.getClassID() %>" required>
              </label>
              <label class="full">
                Theme
                <input type="text" name="meetingTheme" value="<%= editMeeting.getMeetingTheme() %>" required>
              </label>
              <label class="full">
                Classroom
                <input type="text" name="classroom" value="<%= editMeeting.getClassroom() %>" required>
              </label>
              <div class="apply-actions">
                <button class="secondary-btn" type="button" onclick="cancelEdit()">Cancel</button>
                <button class="primary-btn" type="submit">Update</button>
              </div>
            </form>
          </div>
          <% } %>

          <% if (isMonitor && currentClassID != null) { %>
          <div class="application-card" id="createForm" style="display: none; margin-bottom: 18px;">
            <h3 style="margin: 0 0 14px 0;">Create New Meeting</h3>
            <form action="manageClassMeeting" method="post" class="application-form">
              <input type="hidden" name="action" value="create">
              <label>
                Meeting ID
                <input type="text" name="meetingID" placeholder="e.g., CM004" required>
              </label>
              <label>
                Class ID
                <input type="number" name="classID" value="<%= currentClassID %>" required>
              </label>
              <label class="full">
                Theme
                <input type="text" name="meetingTheme" placeholder="Meeting theme" required>
              </label>
              <label class="full">
                Classroom
                <input type="text" name="classroom" placeholder="e.g., A101" required>
              </label>
              <div class="apply-actions">
                <button class="secondary-btn" type="button" onclick="hideCreateForm()">Cancel</button>
                <button class="primary-btn" type="submit">Create</button>
              </div>
            </form>
          </div>
          <% } %>

          <table>
            <thead><tr><th>Meeting ID</th><th>Theme</th><th>Class</th><th>Classroom</th><th>Organizer</th><% if (isMonitor) { %><th>Actions</th><% } %></tr></thead>
            <tbody>
              <% if (classMeetings.isEmpty()) { %>
                <tr><td colspan="<%= isMonitor ? 6 : 5 %>">No meetings scheduled.</td></tr>
              <% } else {
                for (Map<String, Object> meetingRow : classMeetings) {
                  String organizerName = valueText(meetingRow.get("organizer_name"));
                  // 如果组织者信息为空或无效，显示为 "-"
                  String displayOrganizer = "-";
                  if (!"-".equals(organizerName) && !organizerName.trim().isEmpty()) {
                    displayOrganizer = organizerName;
                  }
              %>
                <tr>
                  <td><%= valueText(meetingRow.get("meeting_id")) %></td>
                  <td><%= valueText(meetingRow.get("meeting_theme")) %></td>
                  <td><%= valueText(meetingRow.get("class_name")) %></td>
                  <td><%= valueText(meetingRow.get("classroom")) %></td>
                  <td><%= displayOrganizer %></td>
                  <% if (isMonitor) { %>
                  <td>
                    <a href="student.jsp?view=meetings&edit=<%= valueText(meetingRow.get("meeting_id")) %>" style="color: var(--navy); font-weight: 700; text-decoration: none; margin-right: 8px;">Edit</a>
                    <a href="manageClassMeeting?action=delete&meetingID=<%= valueText(meetingRow.get("meeting_id")) %>"
                       onclick="return confirm('Are you sure you want to delete this meeting?')"
                       style="color: #c9302c; font-weight: 700; text-decoration: none;">Delete</a>
                  </td>
                  <% } %>
                </tr>
              <% }} %>
            </tbody>
          </table>
        </article>

        <script>
          function showCreateForm() {
            document.getElementById('createForm').style.display = 'block';
          }
          function hideCreateForm() {
            document.getElementById('createForm').style.display = 'none';
          }
          function cancelEdit() {
            window.location.href = 'student.jsp?view=meetings';
          }
        </script>
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
    const scholarshipTypeSelect = document.getElementById('scholarshipTypeSelect');
    const selectedScholarshipDescription = document.getElementById('selectedScholarshipDescription');
    if (scholarshipTypeSelect && selectedScholarshipDescription) {
      scholarshipTypeSelect.addEventListener('change', function() {
        const option = scholarshipTypeSelect.options[scholarshipTypeSelect.selectedIndex];
        selectedScholarshipDescription.textContent = option ? option.dataset.description : '';
      });
    }

    const scholarshipDetailMask = document.getElementById('scholarshipDetailMask');
    const scholarshipDetailBody = document.getElementById('scholarshipDetailBody');
    const scholarshipDetailTitle = document.getElementById('scholarshipDetailTitle');
    const closeScholarshipDetail = document.getElementById('closeScholarshipDetail');
    const detailLabels = {
      application: 'Application',
      applicant: 'Applicant',
      class: 'Class',
      scholarship: 'Scholarship',
      description: 'Description',
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

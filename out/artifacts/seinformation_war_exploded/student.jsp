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

  boolean isMonitor = student != null && "鐝暱".equals(student.getPosition());
  String editMeetingID = request.getParameter("edit");
  ClassMeeting editMeeting = editMeetingID != null ? classMeetingDAO.findById(editMeetingID) : null;

  String createStatus = request.getParameter("status");

  List<Map<String, Object>> appliedScholarshipRows = dashboardDao.findStudentScholarshipApplications(studentID);
  List<Map<String, Object>> availableScholarshipRows = dashboardDao.findAvailableScholarships(studentID);
  List<Map<String, Object>> publishedScholarshipRows = dashboardDao.findPublishedScholarships();

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
        <%@ include file="student/personalinfo.jsp" %>
        <%@ include file="student/classinfo.jsp" %>
        <%@ include file="student/party.jsp" %>
        <%@ include file="student/scholarship.jsp" %>
        <%@ include file="student/grades.jsp" %>
        <%@ include file="student/meetings.jsp" %>
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
              <option value="瀛︾敓" <%= student == null || student.getPosition() == null || "瀛︾敓".equals(student.getPosition()) ? "selected" : "" %>>瀛︾敓</option>
              <option value="鐝暱" <%= student != null && "鐝暱".equals(student.getPosition()) ? "selected" : "" %>>鐝暱</option>
              <option value="瀛︿範濮斿憳" <%= student != null && "瀛︿範濮斿憳".equals(student.getPosition()) ? "selected" : "" %>>瀛︿範濮斿憳</option>
            </select>
          </label>
          <label class="form-field full">
            Origin Place
            <input type="text" name="originPlace" value="<%= personalInfo == null ? "" : fieldValue(personalInfo.getOriginPlace()) %>">
          </label>
          <label class="form-field full">
            Political Status
            <select name="politicalStatus">
              <option value="鍥㈠憳" <%= personalInfo == null || personalInfo.getPoliticalStatus() == null || "鍥㈠憳".equals(personalInfo.getPoliticalStatus()) ? "selected" : "" %>>鍥㈠憳</option>
              <option value="鍏氬憳" <%= personalInfo != null && "鍏氬憳".equals(personalInfo.getPoliticalStatus()) ? "selected" : "" %>>鍏氬憳</option>
              <option value="缇や紬" <%= personalInfo != null && "缇や紬".equals(personalInfo.getPoliticalStatus()) ? "selected" : "" %>>缇や紬</option>
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
    if (closeScholarshipDetail) {
      closeScholarshipDetail.addEventListener('click', closeScholarshipDetailModal);
    }
    if (scholarshipDetailMask) {
      scholarshipDetailMask.addEventListener('click', function(event) {
        if (event.target === scholarshipDetailMask) {
          closeScholarshipDetailModal();
        }
      });
    }

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

    if (openProfileEditor) {
      openProfileEditor.addEventListener('click', openEditor);
    }
    if (closeProfileEditor) {
      closeProfileEditor.addEventListener('click', closeEditor);
    }
    if (cancelProfileEditor) {
      cancelProfileEditor.addEventListener('click', closeEditor);
    }
    if (profileMask) {
      profileMask.addEventListener('click', function(event) {
        if (event.target === profileMask) {
          closeEditor();
        }
      });
    }
  </script>
</body>
</html>

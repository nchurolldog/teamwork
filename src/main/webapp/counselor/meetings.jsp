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
          // 濡傛灉缁勭粐鑰呬俊鎭负绌烘垨鏃犳晥锛屾樉绀轰负 "-"
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

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
                  // 濡傛灉缁勭粐鑰呬俊鎭负绌烘垨鏃犳晥锛屾樉绀轰负 "-"
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

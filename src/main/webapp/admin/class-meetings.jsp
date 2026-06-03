        <section class="panel" id="classMeetingsPanel">
          <div class="panel-head">
            <div class="panel-title">Class Meetings Management</div>
            <div style="display: flex; gap: 8px; align-items: center;">
              <button class="primary-btn" type="button" onclick="showCreateForm()" style="font-size: 12px; padding: 5px 10px; height: auto; border: 0; border-radius: 8px; background: var(--pink); color: var(--ink); cursor: pointer; font-weight: 800;">+ Create Meeting</button>
              <span class="pill">Total: <%= meetingCount %></span>
            </div>
          </div>

          <% if ("created".equals(meetingStatus)) { %>
            <div class="notice" style="padding: 12px 14px; border-radius: 8px; font-size: 13px; background: #e6f8f0; color: #177a59; margin-bottom: 14px;">Meeting created successfully!</div>
          <% } else if ("updated".equals(meetingStatus)) { %>
            <div class="notice" style="padding: 12px 14px; border-radius: 8px; font-size: 13px; background: #e6f8f0; color: #177a59; margin-bottom: 14px;">Meeting updated successfully!</div>
          <% } else if ("deleted".equals(meetingStatus)) { %>
            <div class="notice" style="padding: 12px 14px; border-radius: 8px; font-size: 13px; background: #e6f8f0; color: #177a59; margin-bottom: 14px;">Meeting deleted successfully!</div>
          <% } else if ("error".equals(meetingStatus)) { %>
            <div class="notice error" style="padding: 12px 14px; border-radius: 8px; font-size: 13px; background: #ffe7ee; color: #9b2849; margin-bottom: 14px;">Operation failed. Please try again.</div>
          <% } %>

          <% if (editMeeting != null) { %>
          <div class="application-card" style="border: 1px solid var(--line); border-radius: 8px; padding: 16px; background: #fbfdfe; margin-bottom: 18px;">
            <h3 style="margin: 0 0 14px 0; font-size: 16px;">Edit Meeting</h3>
            <form action="manageClassMeeting" method="post" style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 12px;">
              <input type="hidden" name="action" value="update">
              <input type="hidden" name="meetingID" value="<%= editMeeting.getMeetingID() %>">
              <label style="display: grid; gap: 6px;">
                Meeting ID
                <input type="text" value="<%= editMeeting.getMeetingID() %>" readonly style="width: 100%; height: 36px; border: 1px solid var(--line); border-radius: 6px; padding: 0 10px; background: #f5f5f5;">
              </label>
              <label style="display: grid; gap: 6px;">
                Class ID
                <input type="number" name="classID" value="<%= editMeeting.getClassID() %>" required style="width: 100%; height: 36px; border: 1px solid var(--line); border-radius: 6px; padding: 0 10px;">
              </label>
              <label style="grid-column: 1 / -1; display: grid; gap: 6px;">
                Theme
                <input type="text" name="meetingTheme" value="<%= editMeeting.getMeetingTheme() %>" required style="width: 100%; height: 36px; border: 1px solid var(--line); border-radius: 6px; padding: 0 10px;">
              </label>
              <label style="grid-column: 1 / -1; display: grid; gap: 6px;">
                Classroom
                <input type="text" name="classroom" value="<%= editMeeting.getClassroom() %>" required style="width: 100%; height: 36px; border: 1px solid var(--line); border-radius: 6px; padding: 0 10px;">
              </label>
              <div style="grid-column: 1 / -1; display: flex; gap: 8px; justify-content: flex-end;">
                <a href="admin.jsp?view=meetings" class="secondary-btn" style="font-size: 12px; padding: 5px 10px; height: auto; text-decoration: none; display: inline-flex; align-items: center;">Cancel</a>
                <button class="primary-btn" type="submit" style="font-size: 12px; padding: 5px 10px; height: auto;">Update</button>
              </div>
            </form>
          </div>
          <% } %>

          <div class="application-card" id="createForm" style="display: none; margin-bottom: 18px;">
            <h3 style="margin: 0 0 14px 0; font-size: 16px;">Create New Meeting</h3>
            <form action="manageClassMeeting" method="post" style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 12px;">
              <input type="hidden" name="action" value="create">
              <label style="display: grid; gap: 6px;">
                Meeting ID
                <input type="text" name="meetingID" placeholder="e.g., CM004" required>
              </label>
              <label style="display: grid; gap: 6px;">
                Class ID
                <input type="number" name="classID" placeholder="e.g., 1" required>
              </label>
              <label style="grid-column: 1 / -1; display: grid; gap: 6px;">
                Theme
                <input type="text" name="meetingTheme" placeholder="Meeting theme" required>
              </label>
              <label style="grid-column: 1 / -1; display: grid; gap: 6px;">
                Classroom
                <input type="text" name="classroom" placeholder="e.g., A101" required>
              </label>
              <div style="grid-column: 1 / -1; display: flex; gap: 8px; justify-content: flex-end;">
                <button type="button" onclick="hideCreateForm()" class="secondary-btn" style="border: 0; border-radius: 8px; height: 40px; padding: 0 16px; font-weight: 800; cursor: pointer; font-size: 12px; background: var(--page); color: var(--ink);">Cancel</button>
                <button type="submit" class="primary-btn" style="border: 0; border-radius: 8px; height: 40px; padding: 0 16px; font-weight: 800; cursor: pointer; font-size: 12px; background: var(--pink); color: var(--ink);">Create</button>
              </div>
            </form>
          </div>

          <table>
            <thead>
              <tr>
                <th>Meeting ID</th>
                <th>Theme</th>
                <th>Class</th>
                <th>Classroom</th>
                <th>Organizer</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              <% if (allMeetings.isEmpty()) { %>
                <tr><td colspan="6">No meetings found.</td></tr>
              <% } else {
                for (Map<String, Object> row : allMeetings) {
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
                    <a href="admin.jsp?view=meetings&edit=<%= valueText(row.get("meeting_id")) %>" style="color: var(--navy); font-weight: 700; text-decoration: none; margin-right: 8px; font-size: 12px;">Edit</a>
                    <a href="manageClassMeeting?action=delete&meetingID=<%= valueText(row.get("meeting_id")) %>"
                       onclick="return confirm('Are you sure you want to delete this meeting?')"
                       style="color: #c9302c; font-weight: 700; text-decoration: none; font-size: 12px;">Delete</a>
                  </td>
                </tr>
              <% }} %>
            </tbody>
          </table>
        </section>


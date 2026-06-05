<% if ("meetings".equals(view)) { %>
<article class="card span-12" id="meetings">
  <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
    <h2 style="margin: 0;">班级会议</h2>
    <% if (isMonitor && currentClassID != null) { %>
    <button class="primary-btn" type="button" onclick="showCreateForm()">+ 创建会议</button>
    <% } %>
  </div>

  <% if ("created".equals(createStatus)) { %>
  <div class="notice">会议创建成功！</div>
  <% } else if ("updated".equals(createStatus)) { %>
  <div class="notice">会议更新成功！</div>
  <% } else if ("deleted".equals(createStatus)) { %>
  <div class="notice">会议删除成功！</div>
  <% } else if ("error".equals(createStatus)) { %>
  <div class="notice error">操作失败。请重试。</div>
  <% } %>

  <% if (editMeeting != null) { %>
  <div class="application-card" style="margin-bottom: 18px;">
    <h3 style="margin: 0 0 14px 0;">编辑会议</h3>
    <form action="manageClassMeeting" method="post" class="application-form">
      <input type="hidden" name="action" value="update">
      <input type="hidden" name="meetingID" value="<%= editMeeting.getMeetingID() %>">
      <label>
        会议ID
        <input type="text" name="meetingID_display" value="<%= editMeeting.getMeetingID() %>" readonly>
      </label>
      <label>
        班级ID
        <input type="number" name="classID" value="<%= editMeeting.getClassID() %>" required>
      </label>
      <label class="full">
        主题
        <input type="text" name="meetingTheme" value="<%= editMeeting.getMeetingTheme() %>" required>
      </label>
      <label class="full">
        教室
        <input type="text" name="classroom" value="<%= editMeeting.getClassroom() %>" required>
      </label>
      <div class="apply-actions">
        <button class="secondary-btn" type="button" onclick="cancelEdit()">取消</button>
        <button class="primary-btn" type="submit">更新</button>
      </div>
    </form>
  </div>
  <% } %>

  <% if (isMonitor && currentClassID != null) { %>
  <div class="application-card" id="createForm" style="display: none; margin-bottom: 18px;">
    <h3 style="margin: 0 0 14px 0;">创建新会议</h3>
    <form action="manageClassMeeting" method="post" class="application-form">
      <input type="hidden" name="action" value="create">
      <label>
        会议ID
        <input type="text" name="meetingID" placeholder="例如 CM004" required>
      </label>
      <label>
        班级ID
        <input type="number" name="classID" value="<%= currentClassID %>" required>
      </label>
      <label class="full">
        主题
        <input type="text" name="meetingTheme" placeholder="会议主题" required>
      </label>
      <label class="full">
        教室
        <input type="text" name="classroom" placeholder="例如 A101" required>
      </label>
      <div class="apply-actions">
        <button class="secondary-btn" type="button" onclick="hideCreateForm()">取消</button>
        <button class="primary-btn" type="submit">创建</button>
      </div>
    </form>
  </div>
  <% } %>

  <table>
    <thead><tr><th>会议ID</th><th>主题</th><th>班级</th><th>教室</th><th>组织者</th><% if (isMonitor) { %><th>操作</th><% } %></tr></thead>
    <tbody>
    <% if (classMeetings.isEmpty()) { %>
    <tr><td colspan="<%= isMonitor ? 6 : 5 %>">暂无会议安排。</td></tr>
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
        <a href="student.jsp?view=meetings&edit=<%= valueText(meetingRow.get("meeting_id")) %>" style="color: var(--navy); font-weight: 700; text-decoration: none; margin-right: 8px;">编辑</a>
        <a href="manageClassMeeting?action=delete&meetingID=<%= valueText(meetingRow.get("meeting_id")) %>"
           onclick="return confirm('确定要删除这个会议吗？')"
           style="color: #c9302c; font-weight: 700; text-decoration: none;">删除</a>
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

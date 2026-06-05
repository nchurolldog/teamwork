<% if ("overview".equals(view) || "meetings".equals(view)) { %>
<article class="card <%= "meetings".equals(view) ? "span-12" : "span-6" %>">
  <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
    <h2 style="margin: 0;">班级会议</h2>
    <div>
      <a href="counselor.jsp?view=meetings" class="pill" style="text-decoration: none; margin-right: 8px;">查看全部</a>
      <button class="primary-btn" type="button" onclick="showCreateForm()" style="font-size: 12px; padding: 5px 10px; height: auto;">+ 创建会议</button>
    </div>
  </div>

  <% if ("created".equals(request.getParameter("meetingStatus"))) { %>
  <div class="notice">会议创建成功！</div>
  <% } else if ("updated".equals(request.getParameter("meetingStatus"))) { %>
  <div class="notice">会议更新成功！</div>
  <% } else if ("deleted".equals(request.getParameter("meetingStatus"))) { %>
  <div class="notice">会议删除成功！</div>
  <% } else if ("error".equals(request.getParameter("meetingStatus"))) { %>
  <div class="notice error">操作失败。请重试。</div>
  <% } %>

  <div class="application-card" id="createForm" style="display: none; margin-bottom: 18px;">
    <h3 style="margin: 0 0 14px 0;">创建新会议</h3>
    <form action="manageClassMeeting" method="post" class="application-form">
      <input type="hidden" name="action" value="create">
      <label>
        会议ID
        <input type="text" name="meetingID" placeholder="例如 CM004" required style="width: 100%; height: 36px; border: 1px solid var(--line); border-radius: 6px; padding: 0 10px;">
      </label>
      <label>
        班级ID
        <input type="number" name="classID" placeholder="例如 1" required style="width: 100%; height: 36px; border: 1px solid var(--line); border-radius: 6px; padding: 0 10px;">
      </label>
      <label class="full">
        主题
        <input type="text" name="meetingTheme" placeholder="会议主题" required style="width: 100%; height: 36px; border: 1px solid var(--line); border-radius: 6px; padding: 0 10px;">
      </label>
      <label class="full">
        教室
        <input type="text" name="classroom" placeholder="例如 A101" required style="width: 100%; height: 36px; border: 1px solid var(--line); border-radius: 6px; padding: 0 10px;">
      </label>
      <div class="apply-actions" style="display: flex; gap: 8px; justify-content: flex-end;">
        <button class="secondary-btn" type="button" onclick="hideCreateForm()" style="font-size: 12px; padding: 5px 10px; height: auto;">取消</button>
        <button class="primary-btn" type="submit" style="font-size: 12px; padding: 5px 10px; height: auto;">创建</button>
      </div>
    </form>
  </div>

  <table>
    <thead><tr><th>会议ID</th><th>主题</th><th>班级</th><th>教室</th><th>组织者</th><th>操作</th></tr></thead>
    <tbody>
    <%
      List<Map<String, Object>> displayMeetings = "meetings".equals(view) ? allMeetings : counselorMeetingRows;
      if (displayMeetings.isEmpty()) {
    %>
    <tr><td colspan="6">暂无班级会议。</td></tr>
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
        <a href="counselor.jsp?view=meetings&edit=<%= valueText(row.get("meeting_id")) %>" style="color: var(--navy); font-weight: 700; text-decoration: none; margin-right: 8px; font-size: 12px;">编辑</a>
        <a href="manageClassMeeting?action=delete&meetingID=<%= valueText(row.get("meeting_id")) %>"
           onclick="return confirm('确定要删除这个会议吗？')"
           style="color: #c9302c; font-weight: 700; text-decoration: none; font-size: 12px;">删除</a>
      </td>
    </tr>
    <% }} %>
    </tbody>
  </table>
</article>

<% if (editMeeting != null) { %>
<article class="card span-12" style="margin-top: 18px;">
  <h2>编辑会议</h2>
  <form action="manageClassMeeting" method="post" class="application-form" style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 12px;">
    <input type="hidden" name="action" value="update">
    <input type="hidden" name="meetingID" value="<%= editMeeting.getMeetingID() %>">
    <label style="display: grid; gap: 6px;">
      会议ID
      <input type="text" name="meetingID_display" value="<%= editMeeting.getMeetingID() %>" readonly style="width: 100%; height: 36px; border: 1px solid var(--line); border-radius: 6px; padding: 0 10px; background: #f5f5f5;">
    </label>
    <label style="display: grid; gap: 6px;">
      班级ID
      <input type="number" name="classID" value="<%= editMeeting.getClassID() %>" required style="width: 100%; height: 36px; border: 1px solid var(--line); border-radius: 6px; padding: 0 10px;">
    </label>
    <label class="full" style="grid-column: 1 / -1; display: grid; gap: 6px;">
      主题
      <input type="text" name="meetingTheme" value="<%= editMeeting.getMeetingTheme() %>" required style="width: 100%; height: 36px; border: 1px solid var(--line); border-radius: 6px; padding: 0 10px;">
    </label>
    <label class="full" style="grid-column: 1 / -1; display: grid; gap: 6px;">
      教室
      <input type="text" name="classroom" value="<%= editMeeting.getClassroom() %>" required style="width: 100%; height: 36px; border: 1px solid var(--line); border-radius: 6px; padding: 0 10px;">
    </label>
    <div class="apply-actions" style="grid-column: 1 / -1; display: flex; gap: 8px; justify-content: flex-end;">
      <a href="counselor.jsp?view=meetings" class="secondary-btn" style="font-size: 12px; padding: 5px 10px; height: auto; text-decoration: none; display: inline-flex; align-items: center;">取消</a>
      <button class="primary-btn" type="submit" style="font-size: 12px; padding: 5px 10px; height: auto;">更新</button>
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

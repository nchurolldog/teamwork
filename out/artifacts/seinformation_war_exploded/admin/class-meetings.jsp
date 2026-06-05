<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<section class="panel" id="classMeetingsPanel">
  <div class="panel-head">
    <div class="panel-title">班级会议管理</div>
    <div style="display: flex; gap: 8px; align-items: center;">
      <button class="primary-btn" type="button" onclick="showCreateForm()" style="font-size: 12px; padding: 5px 10px; height: auto; border: 0; border-radius: 8px; background: var(--pink); color: var(--ink); cursor: pointer; font-weight: 800;">+ 创建会议</button>
      <span class="pill">总数: <%= meetingCount %></span>
    </div>
  </div>

  <% if ("created".equals(meetingStatus)) { %>
  <div class="notice" style="padding: 12px 14px; border-radius: 8px; font-size: 13px; background: #e6f8f0; color: #177a59; margin-bottom: 14px;">会议创建成功！</div>
  <% } else if ("updated".equals(meetingStatus)) { %>
  <div class="notice" style="padding: 12px 14px; border-radius: 8px; font-size: 13px; background: #e6f8f0; color: #177a59; margin-bottom: 14px;">会议更新成功！</div>
  <% } else if ("deleted".equals(meetingStatus)) { %>
  <div class="notice" style="padding: 12px 14px; border-radius: 8px; font-size: 13px; background: #e6f8f0; color: #177a59; margin-bottom: 14px;">会议删除成功！</div>
  <% } else if ("error".equals(meetingStatus)) { %>
  <div class="notice error" style="padding: 12px 14px; border-radius: 8px; font-size: 13px; background: #ffe7ee; color: #9b2849; margin-bottom: 14px;">操作失败。请重试。</div>
  <% } %>

  <% if (editMeeting != null) { %>
  <div class="application-card" style="border: 1px solid var(--line); border-radius: 8px; padding: 16px; background: #fbfdfe; margin-bottom: 18px;">
    <h3 style="margin: 0 0 14px 0; font-size: 16px;">编辑会议</h3>
    <form action="manageClassMeeting" method="post" style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 12px;">
      <input type="hidden" name="action" value="update">
      <input type="hidden" name="meetingID" value="<%= editMeeting.getMeetingID() %>">
      <label style="display: grid; gap: 6px;">
        会议ID
        <input type="text" value="<%= editMeeting.getMeetingID() %>" readonly style="width: 100%; height: 36px; border: 1px solid var(--line); border-radius: 6px; padding: 0 10px; background: #f5f5f5;">
      </label>
      <label style="display: grid; gap: 6px;">
        班级ID
        <input type="number" name="classID" value="<%= editMeeting.getClassID() %>" required style="width: 100%; height: 36px; border: 1px solid var(--line); border-radius: 6px; padding: 0 10px;">
      </label>
      <label style="grid-column: 1 / -1; display: grid; gap: 6px;">
        主题
        <input type="text" name="meetingTheme" value="<%= editMeeting.getMeetingTheme() %>" required style="width: 100%; height: 36px; border: 1px solid var(--line); border-radius: 6px; padding: 0 10px;">
      </label>
      <label style="grid-column: 1 / -1; display: grid; gap: 6px;">
        教室
        <input type="text" name="classroom" value="<%= editMeeting.getClassroom() %>" required style="width: 100%; height: 36px; border: 1px solid var(--line); border-radius: 6px; padding: 0 10px;">
      </label>
      <div style="grid-column: 1 / -1; display: flex; gap: 8px; justify-content: flex-end;">
        <a href="admin.jsp?view=meetings" class="secondary-btn" style="font-size: 12px; padding: 5px 10px; height: auto; text-decoration: none; display: inline-flex; align-items: center;">取消</a>
        <button class="primary-btn" type="submit" style="font-size: 12px; padding: 5px 10px; height: auto;">更新</button>
      </div>
    </form>
  </div>
  <% } %>

  <div class="application-card" id="createForm" style="display: none; margin-bottom: 18px;">
    <h3 style="margin: 0 0 14px 0; font-size: 16px;">创建新会议</h3>
    <form action="manageClassMeeting" method="post" style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 12px;">
      <input type="hidden" name="action" value="create">
      <label style="display: grid; gap: 6px;">
        会议ID
        <input type="text" name="meetingID" placeholder="例如 CM004" required>
      </label>
      <label style="display: grid; gap: 6px;">
        班级ID
        <input type="number" name="classID" placeholder="例如 1" required>
      </label>
      <label style="grid-column: 1 / -1; display: grid; gap: 6px;">
        主题
        <input type="text" name="meetingTheme" placeholder="会议主题" required>
      </label>
      <label style="grid-column: 1 / -1; display: grid; gap: 6px;">
        教室
        <input type="text" name="classroom" placeholder="例如 A101" required>
      </label>
      <div style="grid-column: 1 / -1; display: flex; gap: 8px; justify-content: flex-end;">
        <button type="button" onclick="hideCreateForm()" class="secondary-btn" style="border: 0; border-radius: 8px; height: 40px; padding: 0 16px; font-weight: 800; cursor: pointer; font-size: 12px; background: var(--page); color: var(--ink);">取消</button>
        <button type="submit" class="primary-btn" style="border: 0; border-radius: 8px; height: 40px; padding: 0 16px; font-weight: 800; cursor: pointer; font-size: 12px; background: var(--pink); color: var(--ink);">创建</button>
      </div>
    </form>
  </div>

  <table>
    <thead>
    <tr>
      <th>会议ID</th>
      <th>主题</th>
      <th>班级</th>
      <th>教室</th>
      <th>组织者</th>
      <th>操作</th>
    </tr>
    </thead>
    <tbody>
    <% if (allMeetings.isEmpty()) { %>
    <tr><td colspan="6">未找到会议。</td></tr>
    <% } else {
      for (Map<String, Object> row : allMeetings) {
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
        <a href="admin.jsp?view=meetings&edit=<%= valueText(row.get("meeting_id")) %>" style="color: var(--navy); font-weight: 700; text-decoration: none; margin-right: 8px; font-size: 12px;">编辑</a>
        <a href="manageClassMeeting?action=delete&meetingID=<%= valueText(row.get("meeting_id")) %>"
           onclick="return confirm('确定要删除这个会议吗？')"
           style="color: #c9302c; font-weight: 700; text-decoration: none; font-size: 12px;">删除</a>
      </td>
    </tr>
    <% }} %>
    </tbody>
  </table>
</section>

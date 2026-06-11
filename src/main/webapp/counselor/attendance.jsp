<%@ page contentType="text/html;charset=UTF-8" %>
<% if ("attendance".equals(view)) { %>
<%
  String selectedMeetingID = request.getParameter("meetingID");
  List<Map<String, Object>> attendanceRows = new java.util.ArrayList<Map<String, Object>>();
  if (selectedMeetingID != null && !selectedMeetingID.trim().isEmpty()) {
    attendanceRows = dashboardDao.findAttendanceByMeetingId(selectedMeetingID);
  }
  String attendanceStatus = request.getParameter("attendanceStatus");
%>

<% if ("saved".equals(attendanceStatus)) { %>
<div class="notice">考勤记录已保存。</div>
<% } else if ("deleted".equals(attendanceStatus)) { %>
<div class="notice">考勤记录已删除。</div>
<% } else if ("error".equals(attendanceStatus)) { %>
<div class="notice error">操作失败，请重试。</div>
<% } %>

<article class="card span-6">
  <div class="card-head">
    <h2>班会考勤查看</h2>
  </div>
  <form method="get" action="counselor.jsp" style="display: flex; gap: 10px; align-items: center; margin-bottom: 16px; flex-wrap: wrap;">
    <input type="hidden" name="view" value="attendance">
    <select name="meetingID" style="height: 38px; border: 1px solid var(--line); border-radius: 8px; padding: 0 10px; color: var(--ink); background: white; min-width: 260px;">
      <option value="">-- 请选择班会 --</option>
      <%
        for (Map<String, Object> m : allMeetings) {
          String mid = valueText(m.get("meeting_id"));
          String mtheme = valueText(m.get("meeting_theme"));
          String selected = mid.equals(selectedMeetingID) ? "selected" : "";
      %>
      <option value="<%= mid %>" <%= selected %>><%= mid %> - <%= mtheme %></option>
      <% } %>
    </select>
    <button class="primary-btn" type="submit" style="height: 38px; font-size: 13px;">查看考勤</button>
  </form>

  <% if (selectedMeetingID != null && !selectedMeetingID.trim().isEmpty()) { %>
  <table>
    <thead><tr><th>学号</th><th>姓名</th><th>考勤日期</th><th>出勤状态</th></tr></thead>
    <tbody>
    <% if (attendanceRows.isEmpty()) { %>
    <tr><td colspan="4">该班会暂无考勤记录。</td></tr>
    <% } else {
      for (Map<String, Object> row : attendanceRows) {
        Boolean isAbsent = row.get("is_absent") instanceof Boolean ? (Boolean) row.get("is_absent") : false;
        String statusText = Boolean.TRUE.equals(isAbsent) ? "缺勤" : "出勤";
        String statusStyle = Boolean.TRUE.equals(isAbsent) ? "color: #c9302c; font-weight: 700;" : "color: #177a59; font-weight: 700;";
    %>
    <tr>
      <td><%= valueText(row.get("student_id")) %></td>
      <td><%= valueText(row.get("student_name")) %></td>
      <td><%= valueText(row.get("attendance_date")) %></td>
      <td style="<%= statusStyle %>"><%= statusText %></td>
    </tr>
    <% }} %>
    </tbody>
  </table>

  <% if (!attendanceRows.isEmpty()) {
    long presentCount = attendanceRows.stream().filter(r -> !Boolean.TRUE.equals(r.get("is_absent"))).count();
    long absentCount = attendanceRows.size() - presentCount;
  %>
  <div style="margin-top: 14px; display: flex; gap: 20px; color: var(--muted); font-size: 14px;">
    <span>总人数: <strong style="color: var(--ink);"><%= attendanceRows.size() %></strong></span>
    <span>出勤: <strong style="color: #177a59;"><%= presentCount %></strong></span>
    <span>缺勤: <strong style="color: #c9302c;"><%= absentCount %></strong></span>
    <span>出勤率: <strong style="color: var(--ink);"><%= attendanceRows.size() > 0 ? String.format("%.1f%%", presentCount * 100.0 / attendanceRows.size()) : "-" %></strong></span>
  </div>
  <% } %>

  <% } else { %>
  <div style="color: var(--muted); padding: 20px 0;">请选择一个班会查看考勤信息。</div>
  <% } %>
</article>
<% } %>
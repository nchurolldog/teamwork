<%@ page contentType="text/html;charset=UTF-8" %>
<% if ("attendance".equals(view)) { %>
<%
  String attendanceStatus = request.getParameter("attendanceStatus");
  String recordMeetingID = request.getParameter("meetingID");
  List<Map<String, Object>> studentAttendanceRows = dashboardDao.findAttendanceByStudentId(studentID);
  List<Map<String, Object>> classStudents = (isMonitor && currentClassID != null) ? dashboardDao.findClassStudentsForAttendance(currentClassID) : new java.util.ArrayList<Map<String, Object>>();
  List<Map<String, Object>> monitorMeetings = (isMonitor && currentClassID != null) ? dashboardDao.findMeetingsByClassIdForAttendance(currentClassID) : new java.util.ArrayList<Map<String, Object>>();
%>

<% if ("saved".equals(attendanceStatus)) { %>
<div class="notice">考勤记录已保存。</div>
<% } else if ("noStudents".equals(attendanceStatus)) { %>
<div class="notice error">请选择至少一名学生。</div>
<% } else if ("error".equals(attendanceStatus)) { %>
<div class="notice error">操作失败，请重试。</div>
<% } %>

<article class="card span-6">
  <div class="card-head">
    <h2>我的考勤记录</h2>
  </div>
  <table>
    <thead><tr><th>班会ID</th><th>班会主题</th><th>班级</th><th>教室</th><th>考勤日期</th><th>出勤状态</th></tr></thead>
    <tbody>
    <% if (studentAttendanceRows.isEmpty()) { %>
    <tr><td colspan="6">暂无考勤记录。</td></tr>
    <% } else {
      for (Map<String, Object> row : studentAttendanceRows) {
        Boolean isAbsent = row.get("is_absent") instanceof Boolean ? (Boolean) row.get("is_absent") : false;
        String statusText = Boolean.TRUE.equals(isAbsent) ? "缺勤" : "出勤";
        String statusStyle = Boolean.TRUE.equals(isAbsent) ? "color: #c9302c; font-weight: 700;" : "color: #177a59; font-weight: 700;";
    %>
    <tr>
      <td><%= valueText(row.get("meeting_id")) %></td>
      <td><%= valueText(row.get("meeting_theme")) %></td>
      <td><%= valueText(row.get("class_name")) %></td>
      <td><%= valueText(row.get("classroom")) %></td>
      <td><%= valueText(row.get("attendance_date")) %></td>
      <td style="<%= statusStyle %>"><%= statusText %></td>
    </tr>
    <% }} %>
    </tbody>
  </table>
</article>

<% if (isMonitor && currentClassID != null) { %>
<article class="card span-6" style="margin-top: 18px;">
  <div class="card-head">
    <h2>录入班会考勤</h2>
  </div>

  <form method="get" action="student.jsp" style="display: flex; gap: 10px; align-items: center; margin-bottom: 16px; flex-wrap: wrap;">
    <input type="hidden" name="view" value="attendance">
    <select name="meetingID" style="height: 38px; border: 1px solid var(--line); border-radius: 8px; padding: 0 10px; color: var(--ink); background: white; min-width: 260px;">
      <option value="">-- 请选择班会 --</option>
      <% for (Map<String, Object> m : monitorMeetings) {
        String mid = valueText(m.get("meeting_id"));
        String mtheme = valueText(m.get("meeting_theme"));
        String selected = mid.equals(recordMeetingID) ? "selected" : "";
      %>
      <option value="<%= mid %>" <%= selected %>><%= mid %> - <%= mtheme %></option>
      <% } %>
    </select>
    <button class="primary-btn" type="submit" style="height: 38px; font-size: 13px;">选择班会</button>
  </form>

  <% if (recordMeetingID != null && !recordMeetingID.trim().isEmpty() && !classStudents.isEmpty()) { %>
  <%
    List<Map<String, Object>> existingAttendance = dashboardDao.findAttendanceByMeetingId(recordMeetingID);
    java.util.Map<String, Boolean> existMap = new java.util.HashMap<String, Boolean>();
    String existDate = "";
    if (!existingAttendance.isEmpty()) {
      for (Map<String, Object> er : existingAttendance) {
        existMap.put(valueText(er.get("student_id")), Boolean.TRUE.equals(er.get("is_absent")));
      }
      existDate = valueText(existingAttendance.get(0).get("attendance_date"));
    }
  %>
  <form action="manageAttendance" method="post" style="margin-top: 14px;">
    <input type="hidden" name="action" value="submit">
    <input type="hidden" name="meetingID" value="<%= recordMeetingID %>">
    <label style="display: grid; gap: 6px; margin-bottom: 14px; color: var(--muted); font-size: 13px; font-weight: 700;">
      考勤日期
      <input type="date" name="attendanceDate" value="<%= existDate.isEmpty() ? java.time.LocalDate.now().toString() : existDate %>" required style="width: 200px; height: 38px; border: 1px solid var(--line); border-radius: 8px; padding: 0 10px; font: inherit; color: var(--ink); background: white;">
    </label>
    <table>
      <thead><tr><th style="width: 60px;">学号</th><th>姓名</th><th style="width: 100px;">出勤状态</th></tr></thead>
      <tbody>
      <% for (Map<String, Object> s : classStudents) {
        String sid = valueText(s.get("student_id"));
        String sname = valueText(s.get("name"));
        boolean wasAbsent = existMap.containsKey(sid) && Boolean.TRUE.equals(existMap.get(sid));
      %>
      <tr>
        <td><input type="hidden" name="studentID" value="<%= sid %>"><%= sid %></td>
        <td><%= sname %></td>
        <td>
          <select name="absent_<%= sid %>" style="height: 34px; border: 1px solid var(--line); border-radius: 6px; padding: 0 8px; font: inherit; color: var(--ink); background: white;">
            <option value="0" <%= !wasAbsent ? "selected" : "" %>>出勤</option>
            <option value="1" <%= wasAbsent ? "selected" : "" %>>缺勤</option>
          </select>
        </td>
      </tr>
      <% } %>
      </tbody>
    </table>
    <div class="form-actions" style="margin-top: 16px;">
      <button class="primary-btn" type="submit">保存考勤记录</button>
    </div>
  </form>
  <% } else if (recordMeetingID != null && !recordMeetingID.trim().isEmpty()) { %>
  <div style="color: var(--muted); padding: 20px 0;">该班级暂无可考勤的学生。</div>
  <% } %>
</article>
<% } %>

<% } %>
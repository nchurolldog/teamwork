<% if ("class".equals(view)) { %>
<article class="card span-4">
  <h2>班级信息</h2>
  <div class="info-list">
    <% if (classRows.isEmpty()) { %>
    <div class="info-row"><span>班级</span><strong>未分配</strong></div>
    <div class="info-row"><span>教师</span><strong>-</strong></div>
    <div class="info-row"><span>辅导员</span><strong>-</strong></div>
    <% } else {
      Map<String, Object> classRow = classRows.get(0);
    %>
    <div class="info-row"><span>班级</span><strong><%= valueText(classRow.get("class_name")) %></strong></div>
    <div class="info-row"><span>教师</span><strong><%= valueText(classRow.get("teacher_name")) %></strong></div>
    <div class="info-row"><span>辅导员</span><strong><%= valueText(classRow.get("counselor_name")) %></strong></div>
    <% } %>
  </div>
</article>

<article class="card span-8">
  <h2>班级详情</h2>
  <table>
    <thead><tr><th>学号</th><th>姓名</th><th>职位</th><th>性别</th><th>班级</th></tr></thead>
    <tbody>
    <% if (classmateRows.isEmpty()) { %>
    <tr><td colspan="5">未找到同学。</td></tr>
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

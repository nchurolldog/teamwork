<% if ("overview".equals(view) || "classes".equals(view)) { %>
<article class="card <%= "classes".equals(view) ? "span-12" : "span-6" %>" id="classes">
  <h2>我的班级</h2>
  <table>
    <thead><tr><th>班级</th><th>课程</th><th>学生数</th></tr></thead>
    <tbody>
    <% if (teacherClassRows.isEmpty()) { %>
    <tr><td colspan="3">未分配班级。</td></tr>
    <% } else {
      for (Map<String, Object> row : teacherClassRows) {
    %>
    <tr><td><%= valueText(row.get("class_name")) %></td><td>-</td><td><%= valueText(row.get("student_count")) %></td></tr>
    <% }} %>
    </tbody>
  </table>
</article>
<% } %>

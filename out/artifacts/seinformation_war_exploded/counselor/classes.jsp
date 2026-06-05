<% if ("classes".equals(view)) { %>
<article class="card span-12" id="classes">
  <h2>管理的班级</h2>
  <table>
    <thead><tr><th>班级</th><th>学生数</th></tr></thead>
    <tbody>
    <% if (counselorClassRows.isEmpty()) { %>
    <tr><td colspan="2">未分配班级。</td></tr>
    <% } else {
      for (Map<String, Object> row : counselorClassRows) {
    %>
    <tr><td><%= valueText(row.get("class_name")) %></td><td><%= valueText(row.get("student_count")) %></td></tr>
    <% }} %>
    </tbody>
  </table>
</article>
<% } %>

<% if ("grades".equals(view)) { %>
<article class="card span-12" id="grades">
  <h2>成绩</h2>
  <table>
    <thead><tr><th>课程</th><th>平时成绩</th><th>期末成绩</th><th>总成绩</th></tr></thead>
    <tbody>
    <% if (gradeRows.isEmpty()) { %>
    <tr><td colspan="4">无成绩记录。</td></tr>
    <% } else {
      for (Map<String, Object> gradeRow : gradeRows) {
    %>
    <tr>
      <td><%= valueText(gradeRow.get("course_name")) %></td>
      <td><%= valueText(gradeRow.get("regular_grade")) %></td>
      <td><%= valueText(gradeRow.get("final_grade")) %></td>
      <td><%= valueText(gradeRow.get("total_grade")) %></td>
    </tr>
    <% }} %>
    </tbody>
  </table>
</article>
<% } %>

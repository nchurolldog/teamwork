<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<section class="student-table">
  <div class="table-head">
    <div class="table-title">学生列表</div>
    <div class="table-tools">
      <input type="search" placeholder="搜索学生">
      <select aria-label="Student status">
        <option>全部状态</option>
      </select>
      <button class="add-student" type="button">+ 添加学生</button>
    </div>
  </div>
  <table>
    <thead>
    <tr>
      <th>学生</th>
      <th>班级</th>
      <th>GPA</th>
      <th>表现</th>
      <th>出勤率</th>
      <th>职位</th>
    </tr>
    </thead>
    <tbody>
    <% if (adminStudents.isEmpty()) { %>
    <tr><td colspan="6">未找到学生。</td></tr>
    <% } else {
      for (Map<String, Object> row : adminStudents) {
        Object avgGrade = row.get("avg_grade");
        boolean needsSupport = avgGrade instanceof Number && ((Number) avgGrade).doubleValue() < 75;
    %>
    <tr>
      <td><div class="student-name"><img class="avatar" src="<%= valueText(row.get("avatar_path")) %>" alt=""><%= valueText(row.get("name")) %></div></td>
      <td><%= valueText(row.get("class_name")) %></td>
      <td><%= valueText(avgGrade) %></td>
      <td><span class="pill"><%= needsSupport ? "需要帮助" : "良好" %></span></td>
      <td>-</td>
      <td>
        <%
          String position = valueText(row.get("position"));
          String positionClass = "班长".equals(position) ? "position-monitor" : ("学习委员".equals(position) ? "position-study" : "position-student");
        %>
        <span class="pill <%= positionClass %>"><%= position %></span>
      </td>
    </tr>
    <% }} %>
    </tbody>
  </table>
</section>

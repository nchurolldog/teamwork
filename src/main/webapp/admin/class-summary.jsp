<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<section class="student-table">
  <div class="table-head">
    <div class="table-title">班级管理</div>
    <div class="table-tools">
      <span class="pill"><%= classSummaryRows.size() %> 个班级</span>
    </div>
  </div>
  <table>
    <thead>
    <tr>
      <th>班级</th>
      <th>教师</th>
      <th>辅导员</th>
      <th>学生数</th>
    </tr>
    </thead>
    <tbody>
    <% if (classSummaryRows.isEmpty()) { %>
    <tr><td colspan="4">未找到班级。</td></tr>
    <% } else {
      for (Map<String, Object> row : classSummaryRows) {
    %>
    <tr>
      <td><%= valueText(row.get("class_name")) %></td>
      <td><%= valueText(row.get("teacher_name")) %></td>
      <td><%= valueText(row.get("counselor_name")) %></td>
      <td><span class="pill"><%= valueText(row.get("student_count")) %></span></td>
    </tr>
    <% }} %>
    </tbody>
  </table>
</section>

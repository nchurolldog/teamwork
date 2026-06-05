<% if ("overview".equals(view) || "students".equals(view)) { %>
<article class="card <%= "students".equals(view) ? "span-12" : "span-8" %>">
  <h2>我的学生</h2>
  <% if ("students".equals(view)) { %>
  <form class="list-tools" action="manageClassStudent" method="post">
    <input type="hidden" name="action" value="add">
    <input type="text" name="studentID" placeholder="学号" required>
    <select name="classId" required>
      <option value="">班级</option>
      <% for (Map<String, Object> row : counselorClassRows) { %>
      <option value="<%= valueText(row.get("class_id")) %>"><%= valueText(row.get("class_name")) %></option>
      <% } %>
    </select>
    <select name="position">
      <option value="学生">学生</option>
      <option value="班长">班长</option>
      <option value="学习委员">学习委员</option>
    </select>
    <button type="submit">添加学生</button>
  </form>
  <% } %>
  <form class="list-tools" action="counselor.jsp" method="get">
    <input type="hidden" name="view" value="students">
    <input type="search" name="q" value="<%= fieldValue(search) %>" placeholder="搜索学生">
    <select name="classId" aria-label="Class filter">
      <option value="">全部班级</option>
      <% for (Map<String, Object> row : counselorClassRows) {
        String classIdText = valueText(row.get("class_id"));
      %>
      <option value="<%= classIdText %>" <%= filterClassID != null && classIdText.equals(String.valueOf(filterClassID)) ? "selected" : "" %>><%= valueText(row.get("class_name")) %></option>
      <% } %>
    </select>
    <button type="submit">搜索</button>
  </form>
  <table>
    <thead><tr><th>学生</th><th>班级</th><th>职位</th><th>入党申请</th><th>奖学金</th><th>关注</th><% if ("students".equals(view)) { %><th>管理</th><% } %></tr></thead>
    <tbody>
    <% if (counselorStudentPageRows.isEmpty()) { %>
    <tr><td colspan="<%= "students".equals(view) ? 7 : 6 %>">未分配学生。</td></tr>
    <% } else {
      for (Map<String, Object> row : counselorStudentPageRows) {
        boolean pending = "pending".equalsIgnoreCase(valueText(row.get("party_status")))
                || "pending".equalsIgnoreCase(valueText(row.get("scholarship_status")));
    %>
    <tr>
      <td><%= valueText(row.get("name")) %></td>
      <td><%= valueText(row.get("class_name")) %></td>
      <td><%= valueText(row.get("position")) %></td>
      <td><span class="pill <%= pending ? "warning" : "" %>"><%= valueText(row.get("party_status")) %></span></td>
      <td><span class="pill"><%= valueText(row.get("scholarship_status")) %></span></td>
      <td><%= pending ? "需要审核" : "正常" %></td>
      <% if ("students".equals(view)) { %>
      <td>
        <form class="inline-form" action="manageClassStudent" method="post">
          <input type="hidden" name="studentID" value="<%= valueText(row.get("student_id")) %>">
          <input type="hidden" name="classId" value="<%= valueText(row.get("class_id")) %>">
          <select name="position">
            <option value="学生" <%= "学生".equals(valueText(row.get("position"))) ? "selected" : "" %>>学生</option>
            <option value="班长" <%= "班长".equals(valueText(row.get("position"))) ? "selected" : "" %>>班长</option>
            <option value="学习委员" <%= "学习委员".equals(valueText(row.get("position"))) ? "selected" : "" %>>学习委员</option>
          </select>
          <button class="small-btn" type="submit" name="action" value="position">保存</button>
          <button class="small-btn danger" type="submit" name="action" value="delete">删除</button>
        </form>
      </td>
      <% } %>
    </tr>
    <% }} %>
    </tbody>
  </table>
  <div class="pagination">
    <% if (currentPage > 1) { %>
    <a class="page-link" href="counselor.jsp?view=students&q=<%= fieldValue(search) %>&classId=<%= filterClassID == null ? "" : filterClassID %>&page=<%= currentPage - 1 %>">上一页</a>
    <% } %>
    <span>第 <%= currentPage %> / <%= totalPages %> 页，共 <%= totalFilteredStudents %> 条</span>
    <% if (currentPage < totalPages) { %>
    <a class="page-link" href="counselor.jsp?view=students&q=<%= fieldValue(search) %>&classId=<%= filterClassID == null ? "" : filterClassID %>&page=<%= currentPage + 1 %>">下一页</a>
    <% } %>
  </div>
</article>
<% } %>

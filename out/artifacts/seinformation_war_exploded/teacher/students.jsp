        <% if ("overview".equals(view) || "students".equals(view)) { %>
        <article class="card <%= "students".equals(view) ? "span-12" : "span-8" %>">
          <h2>My Students</h2>
          <% if ("students".equals(view)) { %>
            <form class="list-tools" action="manageClassStudent" method="post">
              <input type="hidden" name="action" value="add">
              <input type="text" name="studentID" placeholder="Student ID" required>
              <select name="classId" required>
                <option value="">Class</option>
                <% for (Map<String, Object> row : teacherClassRows) { %>
                  <option value="<%= valueText(row.get("class_id")) %>"><%= valueText(row.get("class_name")) %></option>
                <% } %>
              </select>
              <select name="position">
                <option value="瀛︾敓">瀛︾敓</option>
                <option value="鐝暱">鐝暱</option>
                <option value="瀛︿範濮斿憳">瀛︿範濮斿憳</option>
              </select>
              <button type="submit">Add Student</button>
            </form>
          <% } %>
          <form class="list-tools" action="teacher.jsp" method="get">
            <input type="hidden" name="view" value="students">
            <input type="search" name="q" value="<%= fieldValue(search) %>" placeholder="Search student">
            <select name="classId" aria-label="Class filter">
              <option value="">All Classes</option>
              <% for (Map<String, Object> row : teacherClassRows) {
                String classIdText = valueText(row.get("class_id"));
              %>
                <option value="<%= classIdText %>" <%= filterClassID != null && classIdText.equals(String.valueOf(filterClassID)) ? "selected" : "" %>><%= valueText(row.get("class_name")) %></option>
              <% } %>
            </select>
            <button type="submit">Search</button>
          </form>
          <table>
            <thead><tr><th>Student</th><th>Class</th><th>Position</th><th>Latest Grade</th><th>Attendance</th><th>Status</th><% if ("students".equals(view)) { %><th>Manage</th><% } %></tr></thead>
            <tbody>
              <% if (teacherStudentPageRows.isEmpty()) { %>
                <tr><td colspan="<%= "students".equals(view) ? 7 : 6 %>">No students assigned.</td></tr>
              <% } else {
                for (Map<String, Object> row : teacherStudentPageRows) {
                  Object avgGrade = row.get("avg_grade");
                  boolean needsSupport = avgGrade instanceof Number && ((Number) avgGrade).doubleValue() < 75;
              %>
                <tr>
                  <td><%= valueText(row.get("name")) %></td>
                  <td><%= valueText(row.get("class_name")) %></td>
                  <td><%= valueText(row.get("position")) %></td>
                  <td><%= valueText(avgGrade) %></td>
                  <td>-</td>
                  <td><span class="pill <%= needsSupport ? "warning" : "" %>"><%= needsSupport ? "Needs Support" : "Good" %></span></td>
                  <% if ("students".equals(view)) { %>
                    <td>
                      <form class="inline-form" action="manageClassStudent" method="post">
                        <input type="hidden" name="studentID" value="<%= valueText(row.get("student_id")) %>">
                        <input type="hidden" name="classId" value="<%= valueText(row.get("class_id")) %>">
                        <select name="position">
                          <option value="瀛︾敓" <%= "瀛︾敓".equals(valueText(row.get("position"))) ? "selected" : "" %>>瀛︾敓</option>
                          <option value="鐝暱" <%= "鐝暱".equals(valueText(row.get("position"))) ? "selected" : "" %>>鐝暱</option>
                          <option value="瀛︿範濮斿憳" <%= "瀛︿範濮斿憳".equals(valueText(row.get("position"))) ? "selected" : "" %>>瀛︿範濮斿憳</option>
                        </select>
                        <button class="small-btn" type="submit" name="action" value="position">Save</button>
                        <button class="small-btn danger" type="submit" name="action" value="delete">Delete</button>
                      </form>
                    </td>
                  <% } %>
                </tr>
              <% }} %>
            </tbody>
          </table>
          <div class="pagination">
            <% if (currentPage > 1) { %>
              <a class="page-link" href="teacher.jsp?view=students&q=<%= fieldValue(search) %>&classId=<%= filterClassID == null ? "" : filterClassID %>&page=<%= currentPage - 1 %>">Prev</a>
            <% } %>
            <span>Page <%= currentPage %> / <%= totalPages %>, Total <%= totalFilteredStudents %></span>
            <% if (currentPage < totalPages) { %>
              <a class="page-link" href="teacher.jsp?view=students&q=<%= fieldValue(search) %>&classId=<%= filterClassID == null ? "" : filterClassID %>&page=<%= currentPage + 1 %>">Next</a>
            <% } %>
          </div>
        </article>
        <% } %>

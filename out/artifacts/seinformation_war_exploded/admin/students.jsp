        <section class="student-table">
          <div class="table-head">
            <div class="table-title">Students</div>
            <div class="table-tools">
              <input type="search" placeholder="Search for a student">
              <select aria-label="Student status">
                <option>All Status</option>
              </select>
              <button class="add-student" type="button">+ Add Student</button>
            </div>
          </div>
          <table>
            <thead>
              <tr>
                <th>Student</th>
                <th>Class</th>
                <th>GPA</th>
                <th>Performance</th>
                <th>Attendance</th>
                <th>Position</th>
              </tr>
            </thead>
            <tbody>
              <% if (adminStudents.isEmpty()) { %>
                <tr><td colspan="6">No students found.</td></tr>
              <% } else {
                for (Map<String, Object> row : adminStudents) {
                  Object avgGrade = row.get("avg_grade");
                  boolean needsSupport = avgGrade instanceof Number && ((Number) avgGrade).doubleValue() < 75;
              %>
                <tr>
                  <td><div class="student-name"><img class="avatar" src="<%= valueText(row.get("avatar_path")) %>" alt=""><%= valueText(row.get("name")) %></div></td>
                  <td><%= valueText(row.get("class_name")) %></td>
                  <td><%= valueText(avgGrade) %></td>
                  <td><span class="pill"><%= needsSupport ? "Needs Support" : "Good" %></span></td>
                  <td>-</td>
                  <td>
                    <%
                      String position = valueText(row.get("position"));
                      String positionClass = "鐝暱".equals(position) ? "position-monitor" : ("瀛︿範濮斿憳".equals(position) ? "position-study" : "position-student");
                    %>
                    <span class="pill <%= positionClass %>"><%= position %></span>
                  </td>
                </tr>
              <% }} %>
            </tbody>
          </table>
        </section>

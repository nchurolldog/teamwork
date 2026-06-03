        <% if ("overview".equals(view) || "classes".equals(view)) { %>
        <article class="card <%= "classes".equals(view) ? "span-12" : "span-6" %>" id="classes">
          <h2>My Classes</h2>
          <table>
            <thead><tr><th>Class</th><th>Course</th><th>Students</th></tr></thead>
            <tbody>
              <% if (teacherClassRows.isEmpty()) { %>
                <tr><td colspan="3">No classes assigned.</td></tr>
              <% } else {
                for (Map<String, Object> row : teacherClassRows) {
              %>
                <tr><td><%= valueText(row.get("class_name")) %></td><td>-</td><td><%= valueText(row.get("student_count")) %></td></tr>
              <% }} %>
            </tbody>
          </table>
        </article>
        <% } %>

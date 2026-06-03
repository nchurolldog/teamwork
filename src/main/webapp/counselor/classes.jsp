        <% if ("classes".equals(view)) { %>
        <article class="card span-12" id="classes">
          <h2>Managed Classes</h2>
          <table>
            <thead><tr><th>Class</th><th>Students</th></tr></thead>
            <tbody>
              <% if (counselorClassRows.isEmpty()) { %>
                <tr><td colspan="2">No classes assigned.</td></tr>
              <% } else {
                for (Map<String, Object> row : counselorClassRows) {
              %>
                <tr><td><%= valueText(row.get("class_name")) %></td><td><%= valueText(row.get("student_count")) %></td></tr>
              <% }} %>
            </tbody>
          </table>
        </article>
        <% } %>

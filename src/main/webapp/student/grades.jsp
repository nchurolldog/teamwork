        <% if ("grades".equals(view)) { %>
        <article class="card span-12" id="grades">
          <h2>Grades</h2>
          <table>
            <thead><tr><th>Course</th><th>Regular</th><th>Final</th><th>Total</th></tr></thead>
            <tbody>
              <% if (gradeRows.isEmpty()) { %>
                <tr><td colspan="4">No grade records.</td></tr>
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

        <% if ("class".equals(view)) { %>
        <article class="card span-4">
          <h2>Class Info</h2>
          <div class="info-list">
            <% if (classRows.isEmpty()) { %>
              <div class="info-row"><span>Class</span><strong>Not assigned</strong></div>
              <div class="info-row"><span>Teacher</span><strong>-</strong></div>
              <div class="info-row"><span>Counselor</span><strong>-</strong></div>
            <% } else {
              Map<String, Object> classRow = classRows.get(0);
            %>
              <div class="info-row"><span>Class</span><strong><%= valueText(classRow.get("class_name")) %></strong></div>
              <div class="info-row"><span>Teacher</span><strong><%= valueText(classRow.get("teacher_name")) %></strong></div>
              <div class="info-row"><span>Counselor</span><strong><%= valueText(classRow.get("counselor_name")) %></strong></div>
            <% } %>
          </div>
        </article>

          <article class="card span-8">
            <h2>Class Detail</h2>
            <table>
              <thead><tr><th>Student ID</th><th>Name</th><th>Position</th><th>Gender</th><th>Class</th></tr></thead>
              <tbody>
                <% if (classmateRows.isEmpty()) { %>
                  <tr><td colspan="5">No classmates found.</td></tr>
                <% } else {
                  for (Map<String, Object> row : classmateRows) {
                %>
                  <tr>
                    <td><%= valueText(row.get("student_id")) %></td>
                    <td><%= valueText(row.get("name")) %></td>
                    <td><%= valueText(row.get("position")) %></td>
                    <td><%= genderText(row.get("gender") instanceof Number ? ((Number) row.get("gender")).intValue() : null) %></td>
                    <td><%= valueText(row.get("class_name")) %></td>
                  </tr>
                <% }} %>
              </tbody>
            </table>
          </article>
        <% } %>

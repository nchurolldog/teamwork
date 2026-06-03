        <section class="student-table">
          <div class="table-head">
            <div class="table-title">Class Management</div>
            <div class="table-tools">
              <span class="pill"><%= classSummaryRows.size() %> Classes</span>
            </div>
          </div>
          <table>
            <thead>
              <tr>
                <th>Class</th>
                <th>Teacher</th>
                <th>Counselor</th>
                <th>Students</th>
              </tr>
            </thead>
            <tbody>
              <% if (classSummaryRows.isEmpty()) { %>
                <tr><td colspan="4">No classes found.</td></tr>
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

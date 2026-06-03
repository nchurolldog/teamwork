        <section class="panel">
          <div class="panel-head">
            <div class="panel-title">Grade Statistics</div>
            <select aria-label="Performance period">
              <option>All Courses</option>
            </select>
          </div>
          <table>
            <thead><tr><th>Course</th><th>Records</th><th>Average</th><th>Min</th><th>Max</th></tr></thead>
            <tbody>
              <% if (gradeSummaryRows.isEmpty()) { %>
                <tr><td colspan="5">No grade statistics.</td></tr>
              <% } else {
                for (Map<String, Object> row : gradeSummaryRows) {
              %>
                <tr>
                  <td><%= valueText(row.get("course_name")) %></td>
                  <td><%= valueText(row.get("record_count")) %></td>
                  <td><span class="pill"><%= valueText(row.get("avg_grade")) %></span></td>
                  <td><%= valueText(row.get("min_grade")) %></td>
                  <td><%= valueText(row.get("max_grade")) %></td>
                </tr>
              <% }} %>
            </tbody>
          </table>
        </section>

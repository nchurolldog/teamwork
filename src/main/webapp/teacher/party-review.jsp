        <% if ("partyReview".equals(view)) { %>
        <article class="card span-12">
          <h2>Party Democratic Review</h2>
          <table>
            <thead><tr><th>Review ID</th><th>Application</th><th>Student</th><th>Class</th><th>Detail</th><th>Status</th><th>Action</th></tr></thead>
            <tbody>
            <% if (teacherPartyReviewRows.isEmpty()) { %>
            <tr><td colspan="7">No party review tasks.</td></tr>
            <% } else {
              for (Map<String, Object> row : teacherPartyReviewRows) {
                String status = valueText(row.get("status"));
            %>
            <tr>
              <td><%= valueText(row.get("review_id")) %></td>
              <td><%= valueText(row.get("application_id")) %></td>
              <td><%= valueText(row.get("name")) %> (<%= valueText(row.get("student_id")) %>)</td>
              <td><%= valueText(row.get("class_name")) %></td>
              <td>
                <button class="small-btn js-detail" type="button"
                        data-title="Party Application Detail"
                        data-application="<%= attrValue(row.get("application_id")) %>"
                        data-review="<%= attrValue(row.get("review_id")) %>"
                        data-applicant="<%= attrValue(row.get("name")) %> (<%= attrValue(row.get("student_id")) %>)"
                        data-class="<%= attrValue(row.get("class_name")) %>"
                        data-status="<%= attrValue(row.get("status")) %>"
                        data-reason="<%= attrValue(row.get("reason")) %>">View Detail</button>
              </td>
              <td><span class="pill <%= "pending".equals(status) ? "warning" : "" %>"><%= status %></span></td>
              <td>
                <% if ("pending".equals(status)) { %>
                <form action="teacherPartyReview" method="post" style="display: inline-flex; gap: 8px;">
                  <input type="hidden" name="reviewID" value="<%= valueText(row.get("review_id")) %>">
                  <button class="small-btn" type="submit" name="action" value="start">Start Voting</button>
                </form>
                <% } else if ("voting".equals(status)) { %>
                <form action="teacherPartyReview" method="post" style="display: inline-flex; gap: 8px;">
                  <input type="hidden" name="reviewID" value="<%= valueText(row.get("review_id")) %>">
                  <button class="small-btn danger" type="submit" name="action" value="finish" onclick="return confirm('Are you sure to finish this review? The result will be calculated.')">Finish & Calculate</button>
                </form>
                <% } else { %>
                <span class="pill"><%= status %></span>
                <% } %>
              </td>
            </tr>
            <% }} %>
            </tbody>
          </table>
        </article>
        <% } %>
        // ... existing code ...


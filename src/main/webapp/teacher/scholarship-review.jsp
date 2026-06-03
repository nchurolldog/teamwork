        <% if ("scholarshipReview".equals(view)) { %>
        <article class="card span-12">
          <h2>Scholarship Review</h2>
          <table>
            <thead><tr><th>Application</th><th>Student</th><th>Class</th><th>Type</th><th>Detail</th><th>Status</th><th>Review</th></tr></thead>
            <tbody>
            <% if (teacherScholarshipReviewRows.isEmpty()) { %>
            <tr><td colspan="7">No scholarship review tasks.</td></tr>
            <% } else {
              for (Map<String, Object> row : teacherScholarshipReviewRows) {
            %>
            <tr>
              <td><%= valueText(row.get("app_id")) %></td>
              <td><%= valueText(row.get("name")) %> (<%= valueText(row.get("student_id")) %>)</td>
              <td><%= valueText(row.get("class_name")) %></td>
              <td><%= valueText(row.get("type_code")) %></td>
              <td>
                <button class="small-btn js-detail" type="button"
                        data-title="Teacher Review Detail"
                        data-application="<%= attrValue(row.get("app_id")) %>"
                        data-applicant="<%= attrValue(row.get("name")) %> (<%= attrValue(row.get("student_id")) %>)"
                        data-class="<%= attrValue(row.get("class_name")) %>"
                        data-scholarship="<%= attrValue(row.get("type_code")) %>"
                        data-status="<%= attrValue(row.get("status")) %>"
                        data-amount="<%= attrValue(row.get("requested_amount")) %>"
                        data-family="<%= attrValue(row.get("family_situation")) %>"
                        data-score="<%= attrValue(row.get("academic_score")) %>"
                        data-conduct="<%= attrValue(row.get("conduct_evaluation")) %>"
                        data-honors="<%= attrValue(row.get("honors")) %>"
                        data-reason="<%= attrValue(row.get("application_reason")) %>"
                        data-materials="<%= attrValue(row.get("supporting_materials")) %>">View Detail</button>
              </td>
              <td><span class="pill"><%= valueText(row.get("status")) %></span></td>
              <td>
                <% if ("pending".equals(valueText(row.get("status")))) { %>
                <form class="inline-form" action="scholarshipTeacherReview" method="post">
                  <input type="hidden" name="reviewID" value="<%= valueText(row.get("review_id")) %>">
                  <input type="hidden" name="appID" value="<%= valueText(row.get("app_id")) %>">
                  <input type="text" name="comment" placeholder="Comment">
                  <button class="small-btn" type="submit" name="decision" value="agree">Agree</button>
                  <button class="small-btn danger" type="submit" name="decision" value="disagree">Reject</button>
                </form>
                <% } else { %>
                <span class="pill"><%= valueText(row.get("comment")) %></span>
                <% } %>
              </td>
            </tr>
            <% }} %>
            </tbody>
          </table>
        </article>
        <% } %>

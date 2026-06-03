<% if ("partyReview".equals(view)) { %>

<% if ("started".equals(request.getParameter("status"))) { %>
<div class="notice" style="margin-bottom: 16px; background: #d4edda; color: #155724;">
  Democratic review started. Students can now vote.
</div>
<% } else if ("finished".equals(request.getParameter("status"))) { %>
<div class="notice" style="margin-bottom: 16px; background: #d4edda; color: #155724;">
  Democratic review finished. Results have been calculated.
</div>
<% } else if ("failed".equals(request.getParameter("status"))) { %>
<div class="notice error" style="margin-bottom: 16px;">
  Operation failed. Please try again.
</div>
<% } %>

<article class="card span-12">
  <h2>Party Democratic Review Management</h2>
  <p style="color: var(--muted); font-size: 14px; margin-bottom: 16px;">
    Manage democratic reviews for party applications. Start voting to allow students to vote, then finish to calculate results (pass rate ≥ 60%).
  </p>
  <table>
    <thead><tr><th>Review ID</th><th>Application</th><th>Student</th><th>Class</th><th>Detail</th><th>Status</th><th>Action</th></tr></thead>
    <tbody>
    <% if (teacherPartyReviewRows.isEmpty()) { %>
    <tr><td colspan="7">No party review tasks.</td></tr>
    <% } else {
      for (Map<String, Object> row : teacherPartyReviewRows) {
        String status = valueText(row.get("status"));
        String statusDisplay = "";
        String statusClass = "";
        if ("pending".equals(status)) {
          statusDisplay = "Not Started";
          statusClass = "warning";
        } else if ("voting".equals(status)) {
          statusDisplay = "Voting in Progress";
          statusClass = "";
        } else if ("passed".equals(status)) {
          statusDisplay = "Passed";
          statusClass = "";
        } else if ("failed".equals(status)) {
          statusDisplay = "Failed";
          statusClass = "warning";
        } else {
          statusDisplay = status;
          statusClass = "";
        }
    %>
    <tr>
      <td><%= valueText(row.get("review_id")) %></td>
      <td><%= valueText(row.get("application_id")) %></td>
      <td><%= valueText(row.get("name")) %> (<%= valueText(row.get("student_id")) %>)</td>
      <td><%= valueText(row.get("class_name")) %></td>
      <td>
        <button class="small-btn js-detail" type="button"
                data-title="Party Application & Review Detail"
                data-application="<%= attrValue(row.get("application_id")) %>"
                data-review="<%= attrValue(row.get("review_id")) %>"
                data-applicant="<%= attrValue(row.get("name")) %> (<%= attrValue(row.get("student_id")) %>)"
                data-class="<%= attrValue(row.get("class_name")) %>"
                data-status="<%= attrValue(statusDisplay) %>"
                data-reason="<%= attrValue(row.get("reason")) %>">View Detail</button>
      </td>
      <td><span class="pill <%= statusClass %>"><%= statusDisplay %></span></td>
      <td>
        <% if ("pending".equals(status)) { %>
        <form action="teacherPartyReview" method="post" style="display: inline-flex; gap: 8px;">
          <input type="hidden" name="reviewID" value="<%= valueText(row.get("review_id")) %>">
          <button class="small-btn" type="submit" name="action" value="start" onclick="return confirm('Start democratic review? Students will be able to vote.')">Start Voting</button>
        </form>
        <% } else if ("voting".equals(status)) { %>
        <form action="teacherPartyReview" method="post" style="display: inline-flex; gap: 8px;">
          <input type="hidden" name="reviewID" value="<%= valueText(row.get("review_id")) %>">
          <button class="small-btn danger" type="submit" name="action" value="finish" onclick="return confirm('Finish democratic review? The result will be calculated based on votes (pass rate ≥ 60%).')">Finish & Calculate</button>
        </form>
        <% } else if ("passed".equals(status)) { %>
        <span class="pill" style="background: #d4edda; color: #155724;">Passed - Ready for Inspection</span>
        <% } else if ("failed".equals(status)) { %>
        <span class="pill" style="background: #f8d7da; color: #721c24;">Failed - Review Not Passed</span>
        <% } else { %>
        <span class="pill"><%= statusDisplay %></span>
        <% } %>
      </td>
    </tr>
    <% }} %>
    </tbody>
  </table>
</article>
<% } %>

<tr>
      <td><%= valueText(row.get("review_id")) %></td>
      <td><%= valueText(row.get("application_id")) %></td>
      <td><%= valueText(row.get("name")) %> (<%= valueText(row.get("student_id")) %>)</td>
      <td><%= valueText(row.get("class_name")) %></td>
      <td>
        <button class="small-btn js-detail" type="button"
                data-title="Party Application & Review Detail"
                data-application="<%= attrValue(row.get("application_id")) %>"
                data-review="<%= attrValue(row.get("review_id")) %>"
                data-applicant="<%= attrValue(row.get("name")) %> (<%= attrValue(row.get("student_id")) %>)"
                data-class="<%= attrValue(row.get("class_name")) %>"
                data-status="<%= attrValue(statusDisplay) %>"
                data-reason="<%= attrValue(row.get("reason")) %>">View Detail</button>
      </td>
      <td><span class="pill <%= statusClass %>"><%= statusDisplay %></span></td>
      <td>
        <% if ("pending".equals(status)) { %>
        <form action="teacherPartyReview" method="post" style="display: inline-flex; gap: 8px;">
          <input type="hidden" name="reviewID" value="<%= valueText(row.get("review_id")) %>">
          <button class="small-btn" type="submit" name="action" value="start" onclick="return confirm('Start democratic review? Students will be able to vote.')">Start Voting</button>
        </form>
        <% } else if ("voting".equals(status)) { %>
        <form action="teacherPartyReview" method="post" style="display: inline-flex; gap: 8px;">
          <input type="hidden" name="reviewID" value="<%= valueText(row.get("review_id")) %>">
          <button class="small-btn danger" type="submit" name="action" value="finish" onclick="return confirm('Finish democratic review? The result will be calculated based on votes (pass rate ≥ 60%).')">Finish & Calculate</button>
        </form>
        <% } else if ("passed".equals(status)) { %>
        <span class="pill" style="background: #d4edda; color: #155724;">Passed - Ready for Inspection</span>
        <% } else if ("failed".equals(status)) { %>
        <span class="pill" style="background: #f8d7da; color: #721c24;">Failed - Review Not Passed</span>
        <% } else { %>
        <span class="pill"><%= statusDisplay %></span>
        <% } %>
      </td>
    </tr>
    <% }} %>
    </tbody>
  </table>
</article>
<% } %>



        <% if ("party".equals(view)) { %>
        <article class="card span-12">
          <h2>My Party Application</h2>
          <div class="info-list">
            <div class="info-row"><span>Current Status</span><span class="pill warning"><%= firstStatus(partyRows, "Not Submitted") %></span></div>
            <% if (partyRows == null || partyRows.isEmpty()) { %>
            <div class="info-row"><span>Application</span><strong>No party application record.</strong></div>
            <% } else {
              for (PartyApplication row : partyRows) {
            %>
            <div class="info-row"><span><%= textOrDash(row.getApplicationID()) %></span><strong><%= textOrDash(row.getReason()) %></strong></div>
            <% }} %>
          </div>
        </article>

        <article class="card span-12" style="margin-top: 18px;">
          <h2>Democratic Review Tasks</h2>
          <table>
            <thead><tr><th>Review ID</th><th>Applicant</th><th>Status</th><th>Your Vote</th><th>Action</th></tr></thead>
            <tbody>
            <%
              boolean hasPartyVoteTasks = false;
              if (partyVoteTasks != null && !partyVoteTasks.isEmpty()) {
                for (DemocraticReviewParticipant task : partyVoteTasks) {
                  DemocraticReview review = democraticReviewDao.findById(task.getReviewID());
                  if (review != null) {
                    PartyApplication app = partyApplicationDao.findById(review.getApplicationID());
                    Student applicant = app != null ? studentDAO.findById(app.getApplicantStudentID()) : null;
                    hasPartyVoteTasks = true;
            %>
            <tr>
              <td><%= textOrDash(task.getReviewID()) %></td>
              <td><%= applicant == null ? "-" : textOrDash(applicant.getName()) %> (<%= applicant == null ? "-" : textOrDash(applicant.getStudentID()) %>)</td>
              <td><span class="pill"><%= review != null ? textOrDash(review.getStatus()) : "-" %></span></td>
              <td>
                <% if (task.getAccess() != null && task.getAccess()) { %>
                <span class="pill" style="background: #d4edda; color: #155724;">Agreed</span>
                <% } else if (task.getAccess() != null && !task.getAccess()) { %>
                <span class="pill" style="background: #f8d7da; color: #721c24;">Disagreed</span>
                <% } else { %>
                <span class="pill warning">Not Voted</span>
                <% } %>
              </td>
              <td>
                <% if (review != null && "voting".equals(review.getStatus()) && task.getAccess() == null) { %>
                <form action="studentPartyVote" method="post" style="display: inline-flex; gap: 8px; align-items: center;">
                  <input type="hidden" name="reviewID" value="<%= task.getReviewID() %>">
                  <select name="vote" required style="height: 34px; border: 1px solid var(--line); border-radius: 6px; padding: 0 8px;">
                    <option value="">Select</option>
                    <option value="agree">Agree</option>
                    <option value="disagree">Disagree</option>
                  </select>
                  <button class="primary-btn" type="submit" style="font-size: 12px; padding: 5px 10px; height: auto;">Submit Vote</button>
                </form>
                <% } else if (review != null && "voting".equals(review.getStatus())) { %>
                <span style="color: var(--muted); font-size: 13px;">Voted</span>
                <% } else { %>
                <span style="color: var(--muted); font-size: 13px;">Review <%= review != null ? review.getStatus() : "unknown" %></span>
                <% } %>
              </td>
            </tr>
            <%
                  }
                }
              }
              if (!hasPartyVoteTasks) {
            %>
            <tr><td colspan="5">No democratic review tasks.</td></tr>
            <% } %>
            </tbody>
          </table>
        </article>
        <% } %>

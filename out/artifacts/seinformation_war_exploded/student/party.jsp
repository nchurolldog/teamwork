<% if ("party".equals(view)) { %>

<article class="card span-12">
  <h2>Submit Party Application</h2>
  <p style="color: var(--muted); font-size: 14px; margin-bottom: 16px;">
    Please fill in your application reason carefully. Once submitted, it will be reviewed by your counselor.
  </p>

  <% if (partyRows != null && !partyRows.isEmpty()) {
    boolean hasPending = false;
    for (PartyApplication app : partyRows) {
      if ("pending".equals(app.getStatus()) || "counselor_review".equals(app.getStatus())) {
        hasPending = true;
        break;
      }
    }
    if (hasPending) {
  %>
  <div class="notice" style="background: #fff3cd; color: #856404;">
    You already have a pending application. Please wait for counselor review before submitting a new one.
  </div>
  <% } else { %>

  <form action="applyParty" method="post" id="partyApplicationForm">
    <div style="display: grid; gap: 16px;">
      <label style="display: grid; gap: 8px; color: var(--muted); font-size: 14px; font-weight: 700;">
        Application Reason <span style="color: #dc3545;">*</span>
        <textarea
                name="reason"
                required
                placeholder="Please explain your motivation for joining the party, your understanding of the party, and your commitment..."
                style="min-height: 150px; width: 100%; border: 1px solid var(--line); border-radius: 8px; padding: 12px; font: inherit; color: var(--ink); resize: vertical; line-height: 1.6;"
        ></textarea>
      </label>

      <label class="checkbox-field" style="display: flex; align-items: flex-start; gap: 10px; padding: 12px; background: #f8f9fa; border-radius: 8px; cursor: pointer;">
        <input
                type="checkbox"
                name="promise"
                value="true"
                required
                style="width: 18px; height: 18px; margin-top: 2px; cursor: pointer;"
        >
        <span style="font-size: 14px; color: var(--ink); line-height: 1.5;">
                  I solemnly promise that all the information provided is true and accurate. I understand the responsibilities and obligations of party membership, and I am willing to actively participate in party activities and accept organizational supervision.
                </span>
      </label>

      <div style="display: flex; justify-content: flex-end; gap: 12px;">
        <button type="reset" class="secondary-btn" style="border: 0; border-radius: 8px; height: 42px; padding: 0 20px; font-weight: 700; cursor: pointer; background: var(--page); color: var(--ink);">
          Clear
        </button>
        <button type="submit" class="primary-btn" style="border: 0; border-radius: 8px; height: 42px; padding: 0 24px; font-weight: 700; cursor: pointer; background: var(--pink); color: var(--ink);">
          <i class="fas fa-paper-plane"></i> Submit Application
        </button>
      </div>
    </div>
  </form>
  <% }
  } else {
  %>

  <form action="applyParty" method="post" id="partyApplicationForm">
    <div style="display: grid; gap: 16px;">
      <label style="display: grid; gap: 8px; color: var(--muted); font-size: 14px; font-weight: 700;">
        Application Reason <span style="color: #dc3545;">*</span>
        <textarea
                name="reason"
                required
                placeholder="Please explain your motivation for joining the party, your understanding of the party, and your commitment..."
                style="min-height: 150px; width: 100%; border: 1px solid var(--line); border-radius: 8px; padding: 12px; font: inherit; color: var(--ink); resize: vertical; line-height: 1.6;"
        ></textarea>
      </label>

      <label class="checkbox-field" style="display: flex; align-items: flex-start; gap: 10px; padding: 12px; background: #f8f9fa; border-radius: 8px; cursor: pointer;">
        <input
                type="checkbox"
                name="promise"
                value="true"
                required
                style="width: 18px; height: 18px; margin-top: 2px; cursor: pointer;"
        >
        <span style="font-size: 14px; color: var(--ink); line-height: 1.5;">
                  I solemnly promise that all the information provided is true and accurate. I understand the responsibilities and obligations of party membership, and I am willing to actively participate in party activities and accept organizational supervision.
                </span>
      </label>

      <div style="display: flex; justify-content: flex-end; gap: 12px;">
        <button type="reset" class="secondary-btn" style="border: 0; border-radius: 8px; height: 42px; padding: 0 20px; font-weight: 700; cursor: pointer; background: var(--page); color: var(--ink);">
          Clear
        </button>
        <button type="submit" class="primary-btn" style="border: 0; border-radius: 8px; height: 42px; padding: 0 24px; font-weight: 700; cursor: pointer; background: var(--pink); color: var(--ink);">
          <i class="fas fa-paper-plane"></i> Submit Application
        </button>
      </div>
    </div>
  </form>
  <% } %>
</article>

<article class="card span-12" style="margin-top: 18px;">
  <h2>My Party Application History</h2>
  <div class="info-list">
    <div class="info-row"><span>Current Status</span><span class="pill warning"><%= firstStatus(partyRows, "Not Submitted") %></span></div>
    <% if (partyRows == null || partyRows.isEmpty()) { %>
    <div class="info-row"><span>Application</span><strong>No party application record.</strong></div>
    <% } else {
      for (PartyApplication row : partyRows) {
        String statusDisplay = "";
        String statusClass = "";
        if (row.getStatus() != null) {
          switch (row.getStatus()) {
            case "pending":
            case "counselor_review":
              statusDisplay = "Pending Counselor Review";
              statusClass = "warning";
              break;
            case "counselor_approved":
              statusDisplay = "Waiting Democratic Review";
              statusClass = "";
              break;
            case "review_passed":
              statusDisplay = "Development Inspection Pending";
              statusClass = "";
              break;
            case "inspection_approved":
              statusDisplay = "Final Approval Pending";
              statusClass = "";
              break;
            case "approved":
              statusDisplay = "Approved - Party Member";
              statusClass = "";
              break;
            case "rejected":
            case "review_failed":
            case "inspection_rejected":
            case "approval_rejected":
              statusDisplay = "Rejected";
              statusClass = "warning";
              break;
            default:
              statusDisplay = row.getStatus();
              statusClass = "";
          }
        } else {
          statusDisplay = "Unknown";
          statusClass = "warning";
        }
    %>
    <div class="info-row">
      <span><%= textOrDash(row.getApplicationID()) %></span>
      <div style="text-align: right;">
        <div style="font-weight: 600; color: var(--ink); margin-bottom: 4px;"><%= textOrDash(row.getReason()) %></div>
        <span class="pill <%= statusClass %>"><%= statusDisplay %></span>
      </div>
    </div>
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

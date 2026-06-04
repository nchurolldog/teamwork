<% if ("party".equals(view)) { %>

<% if ("voted".equals(request.getParameter("status"))) { %>
<div class="notice" style="margin-bottom: 16px; background: #d4edda; color: #155724;">
  Your vote has been submitted successfully. Thank you for participating in the democratic review!
</div>
<% } else if ("duplicate".equals(request.getParameter("status"))) { %>
<div class="notice error" style="margin-bottom: 16px;">
  You have already voted for this review. Each student can only vote once.
</div>
<% } else if ("failed".equals(request.getParameter("status"))) { %>
<div class="notice error" style="margin-bottom: 16px;">
  Vote submission failed. Please try again or contact your counselor.
</div>
<% } %>

<% if ("saved".equals(request.getParameter("applicationStatus"))) { %>
<div class="notice" style="margin-bottom: 16px; background: #d4edda; color: #155724;">
  Your party application has been submitted successfully. It will be reviewed by your counselor.
</div>
<% } else if ("duplicate".equals(request.getParameter("applicationStatus"))) { %>
<div class="notice error" style="margin-bottom: 16px;">
  You already have a pending application. Please wait for counselor review before submitting a new one.
</div>
<% } else if ("failed".equals(request.getParameter("applicationStatus"))) { %>
<div class="notice error" style="margin-bottom: 16px;">
  Application submission failed. Please check that all required fields are filled correctly and try again.
</div>
<% } %>

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
  <h2>Democratic Review Tasks - Online Voting</h2>
  <p style="color: var(--muted); font-size: 14px; margin-bottom: 16px;">
    As a classmate, you can participate in democratic reviews by voting on your classmates' party applications.
    Your vote is anonymous and helps ensure fair evaluation.
  </p>
  <table>
    <thead><tr><th>Review ID</th><th>Applicant</th><th>Class</th><th>Review Status</th><th>Your Vote</th><th>Action</th></tr></thead>
    <tbody>
    <%
      boolean hasPartyVoteTasks = false;
      if (partyVoteTasks != null && !partyVoteTasks.isEmpty()) {
        for (DemocraticReviewParticipant task : partyVoteTasks) {
          DemocraticReview review = democraticReviewDao.findById(task.getReviewID());
          if (review != null) {
            PartyApplication app = partyApplicationDao.findById(review.getApplicationID());
            Student applicant = app != null ? studentDAO.findById(app.getApplicantStudentID()) : null;

            String className = "-";
            if (applicant != null) {
              List<Map<String, Object>> classes = dashboardDao.findStudentClasses(applicant.getStudentID());
              if (!classes.isEmpty()) {
                className = valueText(classes.get(0).get("class_name"));
              }
            }

            hasPartyVoteTasks = true;
    %>
    <tr>
      <td><%= textOrDash(task.getReviewID()) %></td>
      <td><%= applicant == null ? "-" : textOrDash(applicant.getName()) %> (<%= applicant == null ? "-" : textOrDash(applicant.getStudentID()) %>)</td>
      <td><%= className %></td>
      <td>
        <% if ("pending".equals(review.getStatus())) { %>
        <span class="pill warning">Not Started</span>
        <% } else if ("voting".equals(review.getStatus())) { %>
        <span class="pill" style="background: #cce5ff; color: #004085;">Voting in Progress</span>
        <% } else if ("passed".equals(review.getStatus())) { %>
        <span class="pill" style="background: #d4edda; color: #155724;">Passed</span>
        <% } else if ("failed".equals(review.getStatus())) { %>
        <span class="pill" style="background: #f8d7da; color: #721c24;">Failed</span>
        <% } else { %>
        <span class="pill"><%= textOrDash(review.getStatus()) %></span>
        <% } %>
      </td>
      <td>
        <% if (task.getAccess() != null && task.getAccess() == 1) { %>
        <span class="pill" style="background: #d4edda; color: #155724;">✓ Agreed (1)</span>
        <% } else if (task.getAccess() != null && task.getAccess() == -1) { %>
        <span class="pill" style="background: #f8d7da; color: #721c24;">✗ Disagreed (-1)</span>
        <% } else { %>
        <span class="pill warning">Not Voted</span>
        <% } %>
      </td>
      <td>
        <% if (review != null && "voting".equals(review.getStatus()) && task.getAccess() == null) { %>
        <form action="studentPartyVote" method="post" style="display: inline-flex; gap: 8px; align-items: center;">
          <input type="hidden" name="reviewID" value="<%= task.getReviewID() %>">
          <select name="vote" required style="height: 34px; border: 1px solid var(--line); border-radius: 6px; padding: 0 8px; font-size: 13px;">
            <option value="">Select Vote</option>
            <option value="agree">✓ Agree (1)</option>
            <option value="disagree">✗ Disagree (0)</option>
          </select>
          <button class="primary-btn" type="submit" style="font-size: 12px; padding: 5px 12px; height: auto;" onclick="return confirm('Are you sure to submit your vote? This action cannot be undone.')">Submit Vote</button>
        </form>
        <% } else if (task.getAccess() != null) { %>
        <span style="color: var(--muted); font-size: 13px;">Vote Submitted</span>
        <% } else if ("pending".equals(review.getStatus())) { %>
        <span style="color: var(--muted); font-size: 13px;">Waiting for teacher to start</span>
        <% } else if ("passed".equals(review.getStatus()) || "failed".equals(review.getStatus())) { %>
        <span style="color: var(--muted); font-size: 13px;">Review completed</span>
        <% } else { %>
        <span style="color: var(--muted); font-size: 13px;">Review <%= textOrDash(review.getStatus()) %></span>
        <% } %>
      </td>
    </tr>
    <%
          }
        }
      }
      if (!hasPartyVoteTasks) {
    %>
    <tr><td colspan="6">No democratic review tasks. You will see tasks when your classmates apply for party membership.</td></tr>
    <% } %>
    </tbody>
  </table>
</article>
<% } %>

<% if ("partyReview".equals(view)) { %>

<% if ("started".equals(request.getParameter("status"))) { %>
<div class="notice" style="margin-bottom: 16px; background: #d4edda; color: #155724;">
  Democratic review started. Students can now vote.
</div>
<% } else if ("passed".equals(request.getParameter("status"))) { %>
<div class="notice" style="margin-bottom: 16px; background: #d4edda; color: #155724;">
  Democratic review passed! Agree rate: <%= request.getParameter("agreeRate") %>%
</div>
<% } else if ("failed".equals(request.getParameter("status"))) { %>
<div class="notice error" style="margin-bottom: 16px;">
  Democratic review failed. Agree rate: <%= request.getParameter("agreeRate") %>% (minimum 60% required)
</div>
<% } else if ("failed".equals(request.getParameter("status")) && request.getParameter("status") != null) { %>
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
        <button class="small-btn js-party-detail" type="button"
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

<div class="modal-mask" id="partyDetailMask" aria-hidden="true">
  <section class="profile-modal" role="dialog" aria-modal="true" aria-labelledby="partyDetailTitle">
    <div class="modal-head">
      <h2 id="partyDetailTitle">Application Detail</h2>
      <button class="close-modal" type="button" id="closePartyDetail" aria-label="Close"><i class="fas fa-xmark"></i></button>
    </div>
    <div class="info-list" id="partyDetailBody"></div>
  </section>
</div>

<script>
  (function() {
    const partyDetailMask = document.getElementById('partyDetailMask');
    const partyDetailBody = document.getElementById('partyDetailBody');
    const partyDetailTitle = document.getElementById('partyDetailTitle');
    const closePartyDetail = document.getElementById('closePartyDetail');

    function openPartyDetail(button) {
      partyDetailTitle.textContent = button.dataset.title || 'Application Detail';

      const fields = [
        { label: 'Application ID', value: button.dataset.application },
        { label: 'Review ID', value: button.dataset.review },
        { label: 'Applicant', value: button.dataset.applicant },
        { label: 'Class', value: button.dataset.class },
        { label: 'Status', value: button.dataset.status },
        { label: 'Application Reason', value: button.dataset.reason, full: true }
      ];

      partyDetailBody.innerHTML = fields.map(function(field) {
        return '<div class="info-row' + (field.full ? '" style="flex-direction: column; gap: 8px;' : '') + '">' +
                '<span>' + field.label + '</span>' +
                '<strong style="' + (field.full ? 'white-space: pre-wrap; word-wrap: break-word;' : '') + '">' +
                escapeHtml(field.value || '-') + '</strong></div>';
      }).join('');

      partyDetailMask.classList.add('show');
      partyDetailMask.setAttribute('aria-hidden', 'false');
    }

    function escapeHtml(value) {
      return String(value).replace(/[&<>"']/g, function(char) {
        return ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[char]);
      });
    }

    function closePartyDetailModal() {
      partyDetailMask.classList.remove('show');
      partyDetailMask.setAttribute('aria-hidden', 'true');
    }

    document.querySelectorAll('.js-party-detail').forEach(function(button) {
      button.addEventListener('click', function() { openPartyDetail(button); });
    });

    if (closePartyDetail) {
      closePartyDetail.addEventListener('click', closePartyDetailModal);
    }

    if (partyDetailMask) {
      partyDetailMask.addEventListener('click', function(event) {
        if (event.target === partyDetailMask) {
          closePartyDetailModal();
        }
      });
    }
  })();
</script>
<% } %>

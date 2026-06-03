<% if ("partyReview".equals(view)) { %>

<% if ("saved".equals(request.getParameter("status"))) { %>
<div class="notice" style="margin-bottom: 16px; background: #d4edda; color: #155724;">
  Application reviewed successfully.
</div>
<% } else if ("approved".equals(request.getParameter("status"))) { %>
<div class="notice" style="margin-bottom: 16px; background: #d4edda; color: #155724;">
  Application approved. Democratic review has been created and assigned to the class teacher.
</div>
<% } else if ("rejected".equals(request.getParameter("status"))) { %>
<div class="notice error" style="margin-bottom: 16px;">
  Application rejected.
</div>
<% } else if ("failed".equals(request.getParameter("status"))) { %>
<div class="notice error" style="margin-bottom: 16px;">
  Operation failed. Please try again.
</div>
<% } %>

<article class="card span-12">
  <h2>Party Application Review</h2>
  <p style="color: var(--muted); font-size: 14px; margin-bottom: 16px;">
    Review student party applications. After approval, a democratic review will be automatically created and assigned to the class teacher.
  </p>
  <table>
    <thead><tr><th>Application</th><th>Student</th><th>Class</th><th>Reason</th><th>Status</th><th>Detail</th><th>Action</th></tr></thead>
    <tbody>
    <% if (counselorPartyRows.isEmpty()) { %>
    <tr><td colspan="7">No party applications.</td></tr>
    <% } else {
      for (Map<String, Object> row : counselorPartyRows) {
        String status = valueText(row.get("status"));
        String statusDisplay = "";
        String statusClass = "";
        if ("pending".equals(status)) {
          statusDisplay = "Pending Review";
          statusClass = "warning";
        } else if ("counselor_approved".equals(status)) {
          statusDisplay = "Approved - Waiting Review";
          statusClass = "";
        } else if ("rejected".equals(status)) {
          statusDisplay = "Rejected";
          statusClass = "warning";
        } else {
          statusDisplay = status;
          statusClass = "";
        }
    %>
    <tr>
      <td><%= valueText(row.get("application_id")) %></td>
      <td><%= valueText(row.get("name")) %> (<%= valueText(row.get("student_id")) %>)</td>
      <td><%= valueText(row.get("class_name")) %></td>
      <td style="max-width: 200px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;" title="<%= attrValue(row.get("reason")) %>"><%= valueText(row.get("reason")) %></td>
      <td><span class="pill <%= statusClass %>"><%= statusDisplay %></span></td>
      <td>
        <button class="small-btn js-party-detail" type="button"
                data-title="Party Application Detail"
                data-application="<%= attrValue(row.get("application_id")) %>"
                data-student="<%= attrValue(row.get("name")) %> (<%= attrValue(row.get("student_id")) %>)"
                data-class="<%= attrValue(row.get("class_name")) %>"
                data-reason="<%= attrValue(row.get("reason")) %>"
                data-status="<%= attrValue(statusDisplay) %>">View Detail</button>
      </td>
      <td>
        <% if ("pending".equals(status)) { %>
        <form action="counselorPartyReview" method="post" style="display: inline-flex; gap: 8px;">
          <input type="hidden" name="applicationID" value="<%= valueText(row.get("application_id")) %>">
          <button class="small-btn" type="submit" name="action" value="approve" onclick="return confirm('Are you sure to approve this application? This will create a democratic review.')">Approve</button>
          <button class="small-btn danger" type="submit" name="action" value="reject" onclick="return confirm('Are you sure to reject this application?')">Reject</button>
        </form>
        <% } else if ("counselor_approved".equals(status)) { %>
        <span style="color: var(--muted); font-size: 13px;">Approved</span>
        <% } else if ("rejected".equals(status)) { %>
        <span style="color: var(--muted); font-size: 13px;">Rejected</span>
        <% } else { %>
        <span style="color: var(--muted); font-size: 13px;">Reviewed</span>
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
        { label: 'Student', value: button.dataset.student },
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
<% if ("developmentInspection".equals(view)) { %>
        <article class="card span-12">
          <h2>Development Inspection</h2>
          <table>
            <thead><tr><th>Inspection ID</th><th>Application</th><th>Student</th><th>Class</th><th>Reason</th><th>Status</th><th>Action</th></tr></thead>
            <tbody>
            <% if (developmentInspectionRows.isEmpty()) { %>
            <tr><td colspan="7">No development inspection tasks.</td></tr>
            <% } else {
              for (Map<String, Object> row : developmentInspectionRows) {
                String status = valueText(row.get("status"));
            %>
            <tr>
              <td><%= valueText(row.get("inspection_id")) %></td>
              <td><%= valueText(row.get("application_id")) %></td>
              <td><%= valueText(row.get("name")) %> (<%= valueText(row.get("student_id")) %>)</td>
              <td><%= valueText(row.get("class_name")) %></td>
              <td><%= valueText(row.get("reason")) %></td>
              <td><span class="pill <%= "pending".equals(status) ? "warning" : "" %>"><%= status %></span></td>
              <td>
                <% if ("pending".equals(status)) { %>
                <form action="counselorDevelopmentInspection" method="post" style="display: inline-flex; gap: 8px;">
                  <input type="hidden" name="inspectionID" value="<%= valueText(row.get("inspection_id")) %>">
                  <button class="small-btn" type="submit" name="action" value="approve">Approve</button>
                  <button class="small-btn danger" type="submit" name="action" value="reject">Reject</button>
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

        <% if ("partyApproval".equals(view)) { %>
        <article class="card span-12">
          <h2>Party Membership Approval</h2>
          <table>
            <thead><tr><th>Approval ID</th><th>Application</th><th>Student</th><th>Class</th><th>Reason</th><th>Status</th><th>Action</th></tr></thead>
            <tbody>
            <% if (partyApprovalRows.isEmpty()) { %>
            <tr><td colspan="7">No party approval tasks.</td></tr>
            <% } else {
              for (Map<String, Object> row : partyApprovalRows) {
                String status = valueText(row.get("status"));
            %>
            <tr>
              <td><%= valueText(row.get("approval_id")) %></td>
              <td><%= valueText(row.get("application_id")) %></td>
              <td><%= valueText(row.get("name")) %> (<%= valueText(row.get("student_id")) %>)</td>
              <td><%= valueText(row.get("class_name")) %></td>
              <td><%= valueText(row.get("reason")) %></td>
              <td><span class="pill <%= "pending".equals(status) ? "warning" : "" %>"><%= status %></span></td>
              <td>
                <% if ("pending".equals(status)) { %>
                <form action="counselorPartyApproval" method="post" style="display: inline-flex; gap: 8px;">
                  <input type="hidden" name="approvalID" value="<%= valueText(row.get("approval_id")) %>">
                  <button class="small-btn" type="submit" name="action" value="approve">Approve</button>
                  <button class="small-btn danger" type="submit" name="action" value="reject">Reject</button>
                </form>
                <% } else if ("approved".equals(status)) { %>
                <span class="pill" style="background: #d4edda; color: #155724;">Approved - Student is now a Party Member</span>
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

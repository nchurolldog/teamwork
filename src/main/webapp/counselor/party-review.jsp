        <% if ("partyReview".equals(view)) { %>
        <article class="card span-12">
          <h2>Party Application Review</h2>
          <table>
            <thead><tr><th>Application</th><th>Student</th><th>Class</th><th>Reason</th><th>Status</th><th>Action</th></tr></thead>
            <tbody>
            <% if (counselorPartyRows.isEmpty()) { %>
            <tr><td colspan="6">No party applications.</td></tr>
            <% } else {
              for (Map<String, Object> row : counselorPartyRows) {
                String status = valueText(row.get("status"));
            %>
            <tr>
              <td><%= valueText(row.get("application_id")) %></td>
              <td><%= valueText(row.get("name")) %> (<%= valueText(row.get("student_id")) %>)</td>
              <td><%= valueText(row.get("class_name")) %></td>
              <td><%= valueText(row.get("reason")) %></td>
              <td><span class="pill <%= "pending".equals(status) ? "warning" : "" %>"><%= status %></span></td>
              <td>
                <% if ("pending".equals(status)) { %>
                <form action="counselorPartyReview" method="post" style="display: inline-flex; gap: 8px;">
                  <input type="hidden" name="applicationID" value="<%= valueText(row.get("application_id")) %>">
                  <button class="small-btn" type="submit" name="action" value="approve">Approve</button>
                  <button class="small-btn danger" type="submit" name="action" value="reject">Reject</button>
                </form>
                <% } else { %>
                <span style="color: var(--muted); font-size: 13px;">Reviewed</span>
                <% } %>
              </td>
            </tr>
            <% }} %>
            </tbody>
          </table>
        </article>
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

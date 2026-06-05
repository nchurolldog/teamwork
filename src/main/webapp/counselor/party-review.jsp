<% if ("partyReview".equals(view)) { %>

<% if ("saved".equals(request.getParameter("status"))) { %>
<div class="notice" style="margin-bottom: 16px; background: #d4edda; color: #155724;">
  申请审核成功。
</div>
<% } else if ("approved".equals(request.getParameter("status"))) { %>
<div class="notice" style="margin-bottom: 16px; background: #d4edda; color: #155724;">
  申请已批准。民主评议已创建并分配给班主任。
</div>
<% } else if ("rejected".equals(request.getParameter("status"))) { %>
<div class="notice error" style="margin-bottom: 16px;">
  申请已拒绝。
</div>
<% } else if ("failed".equals(request.getParameter("status"))) { %>
<div class="notice error" style="margin-bottom: 16px;">
  操作失败。请重试。
</div>
<% } %>

<article class="card span-12">
  <h2>入党申请审核</h2>
  <p style="color: var(--muted); font-size: 14px; margin-bottom: 16px;">
    审核学生入党申请。批准后，将自动创建民主评议并分配给班主任。
  </p>
  <table>
    <thead><tr><th>申请</th><th>学生</th><th>班级</th><th>理由</th><th>状态</th><th>详情</th><th>操作</th></tr></thead>
    <tbody>
    <% if (counselorPartyRows.isEmpty()) { %>
    <tr><td colspan="7">无入党申请。</td></tr>
    <% } else {
      for (Map<String, Object> row : counselorPartyRows) {
        String status = valueText(row.get("status"));
        String statusDisplay = "";
        String statusClass = "";
        if ("pending".equals(status)) {
          statusDisplay = "待审核";
          statusClass = "warning";
        } else if ("counselor_approved".equals(status)) {
          statusDisplay = "已批准 - 等待评议";
          statusClass = "";
        } else if ("rejected".equals(status)) {
          statusDisplay = "已拒绝";
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
                data-title="入党申请详情"
                data-application="<%= attrValue(row.get("application_id")) %>"
                data-student="<%= attrValue(row.get("name")) %> (<%= attrValue(row.get("student_id")) %>)"
                data-class="<%= attrValue(row.get("class_name")) %>"
                data-reason="<%= attrValue(row.get("reason")) %>"
                data-status="<%= attrValue(statusDisplay) %>">查看详情</button>
      </td>
      <td>
        <% if ("pending".equals(status)) { %>
        <form action="counselorPartyReview" method="post" style="display: inline-flex; gap: 8px;">
          <input type="hidden" name="applicationID" value="<%= valueText(row.get("application_id")) %>">
          <button class="small-btn" type="submit" name="action" value="approve" onclick="return confirm('确定批准此申请吗？这将创建民主评议。')">批准</button>
          <button class="small-btn danger" type="submit" name="action" value="reject" onclick="return confirm('确定拒绝此申请吗？')">拒绝</button>
        </form>
        <% } else if ("counselor_approved".equals(status)) { %>
        <span style="color: var(--muted); font-size: 13px;">已批准</span>
        <% } else if ("rejected".equals(status)) { %>
        <span style="color: var(--muted); font-size: 13px;">已拒绝</span>
        <% } else { %>
        <span style="color: var(--muted); font-size: 13px;">已审核</span>
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
      <h2 id="partyDetailTitle">申请详情</h2>
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
      partyDetailTitle.textContent = button.dataset.title || '申请详情';

      const fields = [
        { label: '申请ID', value: button.dataset.application },
        { label: '学生', value: button.dataset.student },
        { label: '班级', value: button.dataset.class },
        { label: '状态', value: button.dataset.status },
        { label: '申请理由', value: button.dataset.reason, full: true }
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
  <h2>发展考察</h2>
  <table>
    <thead><tr><th>考察ID</th><th>申请</th><th>学生</th><th>班级</th><th>理由</th><th>状态</th><th>操作</th></tr></thead>
    <tbody>
    <% if (developmentInspectionRows.isEmpty()) { %>
    <tr><td colspan="7">无发展考察任务。</td></tr>
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
          <button class="small-btn" type="submit" name="action" value="approve">批准</button>
          <button class="small-btn danger" type="submit" name="action" value="reject">拒绝</button>
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
  <h2>党员审批</h2>
  <table>
    <thead><tr><th>审批ID</th><th>申请</th><th>学生</th><th>班级</th><th>理由</th><th>状态</th><th>操作</th></tr></thead>
    <tbody>
    <% if (partyApprovalRows.isEmpty()) { %>
    <tr><td colspan="7">无党员审批任务。</td></tr>
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
          <button class="small-btn" type="submit" name="action" value="approve">批准</button>
          <button class="small-btn danger" type="submit" name="action" value="reject">拒绝</button>
        </form>
        <% } else if ("approved".equals(status)) { %>
        <span class="pill" style="background: #d4edda; color: #155724;">已批准 - 学生已成为党员</span>
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

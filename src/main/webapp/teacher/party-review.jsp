<% if ("partyReview".equals(view)) { %>

<% if ("started".equals(request.getParameter("status"))) { %>
<div class="notice" style="margin-bottom: 16px; background: #d4edda; color: #155724;">
  民主评议已开始。学生现在可以投票。
</div>
<% } else if ("passed".equals(request.getParameter("status"))) { %>
<div class="notice" style="margin-bottom: 16px; background: #d4edda; color: #155724;">
  民主评议通过！同意率: <%= request.getParameter("agreeRate") %>%
</div>
<% } else if ("failed".equals(request.getParameter("status"))) { %>
<div class="notice error" style="margin-bottom: 16px;">
  民主评议未通过。同意率: <%= request.getParameter("agreeRate") %>%（需要至少60%）
</div>
<% } else if ("failed".equals(request.getParameter("status")) && request.getParameter("status") != null) { %>
<div class="notice error" style="margin-bottom: 16px;">
  操作失败。请重试。
</div>
<% } %>

<article class="card span-12">
  <h2>入党民主评议管理</h2>
  <p style="color: var(--muted); font-size: 14px; margin-bottom: 16px;">
    管理入党申请的民主评议。开始投票让学生参与投票，然后结束以计算结果（通过率 ≥ 60%）。
  </p>
  <table>
    <thead><tr><th>评议ID</th><th>申请</th><th>学生</th><th>班级</th><th>详情</th><th>状态</th><th>操作</th></tr></thead>
    <tbody>
    <% if (teacherPartyReviewRows.isEmpty()) { %>
    <tr><td colspan="7">无入党评议任务。</td></tr>
    <% } else {
      for (Map<String, Object> row : teacherPartyReviewRows) {
        String status = valueText(row.get("status"));
        String statusDisplay = "";
        String statusClass = "";
        if ("pending".equals(status)) {
          statusDisplay = "未开始";
          statusClass = "warning";
        } else if ("voting".equals(status)) {
          statusDisplay = "投票进行中";
          statusClass = "";
        } else if ("passed".equals(status)) {
          statusDisplay = "已通过";
          statusClass = "";
        } else if ("failed".equals(status)) {
          statusDisplay = "未通过";
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
                data-title="入党申请与评议详情"
                data-application="<%= attrValue(row.get("application_id")) %>"
                data-review="<%= attrValue(row.get("review_id")) %>"
                data-applicant="<%= attrValue(row.get("name")) %> (<%= attrValue(row.get("student_id")) %>)"
                data-class="<%= attrValue(row.get("class_name")) %>"
                data-status="<%= attrValue(statusDisplay) %>"
                data-reason="<%= attrValue(row.get("reason")) %>">查看详情</button>
      </td>
      <td><span class="pill <%= statusClass %>"><%= statusDisplay %></span></td>
      <td>
        <% if ("pending".equals(status)) { %>
        <form action="teacherPartyReview" method="post" style="display: inline-flex; gap: 8px;">
          <input type="hidden" name="reviewID" value="<%= valueText(row.get("review_id")) %>">
          <button class="small-btn" type="submit" name="action" value="start" onclick="return confirm('开始民主评议？学生将能够投票。')">开始投票</button>
        </form>
        <% } else if ("voting".equals(status)) { %>
        <form action="teacherPartyReview" method="post" style="display: inline-flex; gap: 8px;">
          <input type="hidden" name="reviewID" value="<%= valueText(row.get("review_id")) %>">
          <button class="small-btn danger" type="submit" name="action" value="finish" onclick="return confirm('结束民主评议？将根据投票计算结果（通过率 ≥ 60%）。')">结束并计算</button>
        </form>
        <% } else if ("passed".equals(status)) { %>
        <span class="pill" style="background: #d4edda; color: #155724;">已通过 - 可进行考察</span>
        <% } else if ("failed".equals(status)) { %>
        <span class="pill" style="background: #f8d7da; color: #721c24;">未通过 - 评议不通过</span>
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
        { label: '评议ID', value: button.dataset.review },
        { label: '申请人', value: button.dataset.applicant },
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

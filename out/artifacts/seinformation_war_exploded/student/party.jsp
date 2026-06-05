<% if ("party".equals(view)) { %>

<% if ("voted".equals(request.getParameter("status"))) { %>
<div class="notice" style="margin-bottom: 16px; background: #d4edda; color: #155724;">
  您的投票已成功提交。感谢您参与民主评议！
</div>
<% } else if ("duplicate".equals(request.getParameter("status"))) { %>
<div class="notice error" style="margin-bottom: 16px;">
  您已经为这个评议投过票了。每个学生只能投票一次。
</div>
<% } else if ("failed".equals(request.getParameter("status"))) { %>
<div class="notice error" style="margin-bottom: 16px;">
  投票提交失败。请重试或联系辅导员。
</div>
<% } %>

<% if ("saved".equals(request.getParameter("applicationStatus"))) { %>
<div class="notice" style="margin-bottom: 16px; background: #d4edda; color: #155724;">
  您的入党申请已成功提交。将由辅导员进行审核。
</div>
<% } else if ("duplicate".equals(request.getParameter("applicationStatus"))) { %>
<div class="notice error" style="margin-bottom: 16px;">
  您已有待处理的申请。请在提交新申请前等待辅导员审核。
</div>
<% } else if ("failed".equals(request.getParameter("applicationStatus"))) { %>
<div class="notice error" style="margin-bottom: 16px;">
  申请提交失败。请检查所有必填字段是否正确填写后重试。
</div>
<% } %>

<article class="card span-12">
  <h2>提交入党申请</h2>
  <p style="color: var(--muted); font-size: 14px; margin-bottom: 16px;">
    请认真填写您的申请理由。提交后，将由辅导员进行审核。
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
    您已有待处理的申请。请在提交新申请前等待辅导员审核。
  </div>
  <% } else { %>

  <form action="applyParty" method="post" id="partyApplicationForm">
    <div style="display: grid; gap: 16px;">
      <label style="display: grid; gap: 8px; color: var(--muted); font-size: 14px; font-weight: 700;">
        申请理由 <span style="color: #dc3545;">*</span>
        <textarea
                name="reason"
                required
                placeholder="请说明您加入党组织的动机、对党的认识以及您的承诺..."
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
          我郑重承诺，所提供的所有信息真实准确。我了解党员的责任和义务，愿意积极参加党组织活动，接受组织监督。
        </span>
      </label>

      <div style="display: flex; justify-content: flex-end; gap: 12px;">
        <button type="reset" class="secondary-btn" style="border: 0; border-radius: 8px; height: 42px; padding: 0 20px; font-weight: 700; cursor: pointer; background: var(--page); color: var(--ink);">
          清空
        </button>
        <button type="submit" class="primary-btn" style="border: 0; border-radius: 8px; height: 42px; padding: 0 24px; font-weight: 700; cursor: pointer; background: var(--pink); color: var(--ink);">
          <i class="fas fa-paper-plane"></i> 提交申请
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
        申请理由 <span style="color: #dc3545;">*</span>
        <textarea
                name="reason"
                required
                placeholder="请说明您加入党组织的动机、对党的认识以及您的承诺..."
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
          我郑重承诺，所提供的所有信息真实准确。我了解党员的责任和义务，愿意积极参加党组织活动，接受组织监督。
        </span>
      </label>

      <div style="display: flex; justify-content: flex-end; gap: 12px;">
        <button type="reset" class="secondary-btn" style="border: 0; border-radius: 8px; height: 42px; padding: 0 20px; font-weight: 700; cursor: pointer; background: var(--page); color: var(--ink);">
          清空
        </button>
        <button type="submit" class="primary-btn" style="border: 0; border-radius: 8px; height: 42px; padding: 0 24px; font-weight: 700; cursor: pointer; background: var(--pink); color: var(--ink);">
          <i class="fas fa-paper-plane"></i> 提交申请
        </button>
      </div>
    </div>
  </form>
  <% } %>
</article>

<article class="card span-12" style="margin-top: 18px;">
  <h2>我的入党申请历史</h2>
  <div class="info-list">
    <div class="info-row"><span>当前状态</span><span class="pill warning"><%= firstStatus(partyRows, "未提交") %></span></div>
    <% if (partyRows == null || partyRows.isEmpty()) { %>
    <div class="info-row"><span>申请</span><strong>无入党申请记录。</strong></div>
    <% } else {
      for (PartyApplication row : partyRows) {
        String statusDisplay = "";
        String statusClass = "";
        if (row.getStatus() != null) {
          switch (row.getStatus()) {
            case "pending":
            case "counselor_review":
              statusDisplay = "待辅导员审核";
              statusClass = "warning";
              break;
            case "counselor_approved":
              statusDisplay = "等待民主评议";
              statusClass = "";
              break;
            case "review_passed":
              statusDisplay = "待发展考察";
              statusClass = "";
              break;
            case "inspection_approved":
              statusDisplay = "待最终审批";
              statusClass = "";
              break;
            case "approved":
              statusDisplay = "已通过 - 成为党员";
              statusClass = "";
              break;
            case "rejected":
            case "review_failed":
            case "inspection_rejected":
            case "approval_rejected":
              statusDisplay = "已拒绝";
              statusClass = "warning";
              break;
            default:
              statusDisplay = row.getStatus();
              statusClass = "";
          }
        } else {
          statusDisplay = "未知";
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
  <h2>民主评议任务 - 在线投票</h2>
  <p style="color: var(--muted); font-size: 14px; margin-bottom: 16px;">
    作为同学，您可以参与民主评议，对同学的入党申请进行投票。
    您的投票是匿名的，有助于确保公平评估。
  </p>
  <table>
    <thead><tr><th>评议ID</th><th>申请人</th><th>班级</th><th>评议状态</th><th>您的投票</th><th>操作</th></tr></thead>
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
        <span class="pill warning">未开始</span>
        <% } else if ("voting".equals(review.getStatus())) { %>
        <span class="pill" style="background: #cce5ff; color: #004085;">投票进行中</span>
        <% } else if ("passed".equals(review.getStatus())) { %>
        <span class="pill" style="background: #d4edda; color: #155724;">已通过</span>
        <% } else if ("failed".equals(review.getStatus())) { %>
        <span class="pill" style="background: #f8d7da; color: #721c24;">未通过</span>
        <% } else { %>
        <span class="pill"><%= textOrDash(review.getStatus()) %></span>
        <% } %>
      </td>
      <td>
        <% if (task.getAccess() != null && task.getAccess() == 1) { %>
        <span class="pill" style="background: #d4edda; color: #155724;">✓ 同意 (1)</span>
        <% } else if (task.getAccess() != null && task.getAccess() == -1) { %>
        <span class="pill" style="background: #f8d7da; color: #721c24;">✗ 不同意 (-1)</span>
        <% } else { %>
        <span class="pill warning">未投票</span>
        <% } %>
      </td>
      <td>
        <% if (review != null && "voting".equals(review.getStatus()) && task.getAccess() == null) { %>
        <form action="studentPartyVote" method="post" style="display: inline-flex; gap: 8px; align-items: center;">
          <input type="hidden" name="reviewID" value="<%= task.getReviewID() %>">
          <select name="vote" required style="height: 34px; border: 1px solid var(--line); border-radius: 6px; padding: 0 8px; font-size: 13px;">
            <option value="">选择投票</option>
            <option value="agree">✓ 同意 (1)</option>
            <option value="disagree">✗ 不同意 (0)</option>
          </select>
          <button class="primary-btn" type="submit" style="font-size: 12px; padding: 5px 12px; height: auto;" onclick="return confirm('确定提交您的投票吗？此操作不可撤销。')">提交投票</button>
        </form>
        <% } else if (task.getAccess() != null) { %>
        <span style="color: var(--muted); font-size: 13px;">投票已提交</span>
        <% } else if ("pending".equals(review.getStatus())) { %>
        <span style="color: var(--muted); font-size: 13px;">等待教师开始</span>
        <% } else if ("passed".equals(review.getStatus()) || "failed".equals(review.getStatus())) { %>
        <span style="color: var(--muted); font-size: 13px;">评议已完成</span>
        <% } else { %>
        <span style="color: var(--muted); font-size: 13px;">评议 <%= textOrDash(review.getStatus()) %></span>
        <% } %>
      </td>
    </tr>
    <%
          }
        }
      }
      if (!hasPartyVoteTasks) {
    %>
    <tr><td colspan="6">暂无民主评议任务。当您的同学申请入党时，您将看到任务。</td></tr>
    <% } %>
    </tbody>
  </table>
</article>
<% } %>

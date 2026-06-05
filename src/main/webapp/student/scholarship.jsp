<% if ("scholarship".equals(view)) { %>
<% if ("saved".equals(scholarshipStatus)) { %>
<div class="notice">奖学金申请已提交。</div>
<% } else if ("duplicate".equals(scholarshipStatus)) { %>
<div class="notice error">您已经申请过这个奖学金。</div>
<% } else if ("failed".equals(scholarshipStatus)) { %>
<div class="notice error">奖学金申请失败。</div>
<% } %>
<article class="card span-12" id="applications">
  <h2>奖学金状态</h2>
  <div class="info-list">
    <div class="info-row"><span>奖学金</span><span class="pill"><%= firstStatus(scholarshipRows, "无活跃申请") %></span></div>
  </div>
</article>

<div class="span-12 scholarship-grid">
  <article class="card wide">
    <h2>可用奖学金</h2>
    <div class="info-list">
      <% if (availableScholarshipRows.isEmpty()) { %>
      <div class="info-row"><span>可用</span><strong>没有可用的奖学金。</strong></div>
      <% } else { %>
      <div class="application-card">
        <div class="application-title">
          <strong id="selectedScholarshipDescription"><%= valueText(availableScholarshipRows.get(0).get("description")) %></strong>
          <span class="pill">可以申请</span>
        </div>
        <form class="application-form" action="applyScholarship" method="post">
          <label class="full">
            奖学金类型
            <select id="scholarshipTypeSelect" name="typeCode" required>
              <% for (Map<String, Object> row : availableScholarshipRows) { %>
              <option value="<%= attrValue(row.get("type_code")) %>" data-description="<%= attrValue(row.get("description")) %>">
                <%= valueText(row.get("type_code")) %> - <%= valueText(row.get("description")) %>
              </option>
              <% } %>
            </select>
          </label>
          <label>
            申请人
            <input type="text" value="<%= student == null ? "" : fieldValue(student.getName()) %>" readonly>
          </label>
          <label>
            学号
            <input type="text" value="<%= fieldValue(studentID) %>" readonly>
          </label>
          <label>
            申请金额
            <input type="number" name="amount" min="0" step="0.01" placeholder="例如 1200">
          </label>
          <label>
            家庭情况
            <select name="familySituation" required>
              <option value="">选择</option>
              <option value="正常">正常</option>
              <option value="经济困难">经济困难</option>
              <option value="特殊困难">特殊困难</option>
            </select>
          </label>
          <label>
            GPA / 平均成绩
            <input type="text" name="academicScore" placeholder="例如 91.5" required>
          </label>
          <label>
            品行评价
            <select name="conductEvaluation" required>
              <option value="">选择</option>
              <option value="优秀">优秀</option>
              <option value="良好">良好</option>
              <option value="合格">合格</option>
            </select>
          </label>
          <label class="full">
            荣誉奖项
            <textarea name="honors" placeholder="列出奖项、竞赛、志愿服务、班级贡献"></textarea>
          </label>
          <label class="full">
            申请理由
            <textarea name="reason" placeholder="说明为什么申请，您的学业表现、家庭情况和未来计划" required></textarea>
          </label>
          <label class="full">
            支撑材料
            <textarea name="materials" placeholder="描述您将线下提交的证书或文件"></textarea>
          </label>
          <label class="checkbox-field">
            <input type="checkbox" name="promise" value="true" required>
            我承诺提交的信息真实有效，并接受审核公示。
          </label>
          <div class="apply-actions">
            <button class="primary-btn" type="submit">提交申请</button>
          </div>
        </form>
      </div>
      <% } %>
    </div>
  </article>

  <article class="card side">
    <h2>申请详情</h2>
    <div class="info-list">
      <% if (selectedScholarship == null) { %>
      <div class="info-row"><span>状态</span><strong>请选择一个申请。</strong></div>
      <% } else { %>
      <div class="info-row"><span>申请</span><strong><%= valueText(selectedScholarship.get("app_id")) %></strong></div>
      <div class="info-row"><span>类型</span><strong><%= valueText(selectedScholarship.get("type_code")) %></strong></div>
      <div class="info-row"><span>描述</span><strong><%= valueText(selectedScholarship.get("description")) %></strong></div>
      <div class="info-row"><span>状态</span><span class="pill"><%= valueText(selectedScholarship.get("status")) %></span></div>
      <div class="info-row"><span>申请金额</span><strong><%= valueText(selectedScholarship.get("requested_amount")) %></strong></div>
      <div class="info-row"><span>家庭情况</span><strong><%= valueText(selectedScholarship.get("family_situation")) %></strong></div>
      <div class="info-row"><span>学业成绩</span><strong><%= valueText(selectedScholarship.get("academic_score")) %></strong></div>
      <div class="info-row"><span>品行评价</span><strong><%= valueText(selectedScholarship.get("conduct_evaluation")) %></strong></div>
      <div class="info-row"><span>荣誉奖项</span><strong><%= valueText(selectedScholarship.get("honors")) %></strong></div>
      <div class="info-row"><span>申请理由</span><strong><%= valueText(selectedScholarship.get("application_reason")) %></strong></div>
      <div class="info-row"><span>支撑材料</span><strong><%= valueText(selectedScholarship.get("supporting_materials")) %></strong></div>
      <% } %>
    </div>
  </article>
</div>

<article class="card span-12">
  <h2>已申请的奖学金</h2>
  <table>
    <thead><tr><th>申请</th><th>类型</th><th>描述</th><th>状态</th><th>详情</th></tr></thead>
    <tbody>
    <% if (appliedScholarshipRows.isEmpty()) { %>
    <tr><td colspan="5">无奖学金申请。</td></tr>
    <% } else {
      for (Map<String, Object> row : appliedScholarshipRows) {
    %>
    <tr>
      <td><%= valueText(row.get("app_id")) %></td>
      <td><%= valueText(row.get("type_code")) %></td>
      <td><%= valueText(row.get("description")) %></td>
      <td><span class="pill"><%= valueText(row.get("status")) %></span></td>
      <td>
        <button class="secondary-btn js-detail" type="button"
                data-title="申请详情"
                data-application="<%= attrValue(row.get("app_id")) %>"
                data-scholarship="<%= attrValue(row.get("type_code")) %>"
                data-description="<%= attrValue(row.get("description")) %>"
                data-status="<%= attrValue(row.get("status")) %>"
                data-amount="<%= attrValue(row.get("requested_amount")) %>"
                data-family="<%= attrValue(row.get("family_situation")) %>"
                data-score="<%= attrValue(row.get("academic_score")) %>"
                data-conduct="<%= attrValue(row.get("conduct_evaluation")) %>"
                data-honors="<%= attrValue(row.get("honors")) %>"
                data-reason="<%= attrValue(row.get("application_reason")) %>"
                data-materials="<%= attrValue(row.get("supporting_materials")) %>">查看详情</button>
      </td>
    </tr>
    <% }} %>
    </tbody>
  </table>
</article>

<article class="card span-12">
  <h2>已公布的奖学金</h2>
  <table>
    <thead><tr><th>学生</th><th>班级</th><th>类型</th><th>描述</th><th>状态</th></tr></thead>
    <tbody>
    <% if (publishedScholarshipRows.isEmpty()) { %>
    <tr><td colspan="5">无已公布的奖学金。</td></tr>
    <% } else {
      for (Map<String, Object> row : publishedScholarshipRows) {
    %>
    <tr>
      <td><%= valueText(row.get("name")) %></td>
      <td><%= valueText(row.get("class_name")) %></td>
      <td><%= valueText(row.get("type_code")) %></td>
      <td><%= valueText(row.get("description")) %></td>
      <td><span class="pill"><%= valueText(row.get("status")) %></span></td>
    </tr>
    <% }} %>
    </tbody>
  </table>
</article>
<% } %>

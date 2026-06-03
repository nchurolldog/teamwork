        <% if ("scholarship".equals(view)) { %>
          <% if ("saved".equals(scholarshipStatus)) { %>
            <div class="notice">Scholarship application submitted.</div>
          <% } else if ("duplicate".equals(scholarshipStatus)) { %>
            <div class="notice error">You have already applied for this scholarship.</div>
          <% } else if ("failed".equals(scholarshipStatus)) { %>
            <div class="notice error">Scholarship application failed.</div>
          <% } %>
          <article class="card span-12" id="applications">
            <h2>Scholarship Status</h2>
            <div class="info-list">
              <div class="info-row"><span>Scholarship</span><span class="pill"><%= firstStatus(scholarshipRows, "No Active Application") %></span></div>
            </div>
          </article>

          <div class="span-12 scholarship-grid">
            <article class="card wide">
              <h2>Available Scholarships</h2>
              <div class="info-list">
                <% if (availableScholarshipRows.isEmpty()) { %>
                  <div class="info-row"><span>Available</span><strong>No available scholarships.</strong></div>
                <% } else { %>
                  <div class="application-card">
                    <div class="application-title">
                      <strong id="selectedScholarshipDescription"><%= valueText(availableScholarshipRows.get(0).get("description")) %></strong>
                      <span class="pill">Ready to apply</span>
                    </div>
                    <form class="application-form" action="applyScholarship" method="post">
                      <label class="full">
                        Scholarship Type
                        <select id="scholarshipTypeSelect" name="typeCode" required>
                          <% for (Map<String, Object> row : availableScholarshipRows) { %>
                            <option value="<%= attrValue(row.get("type_code")) %>" data-description="<%= attrValue(row.get("description")) %>">
                              <%= valueText(row.get("type_code")) %> - <%= valueText(row.get("description")) %>
                            </option>
                          <% } %>
                        </select>
                      </label>
                      <label>
                        Applicant
                        <input type="text" value="<%= student == null ? "" : fieldValue(student.getName()) %>" readonly>
                      </label>
                      <label>
                        Student ID
                        <input type="text" value="<%= fieldValue(studentID) %>" readonly>
                      </label>
                      <label>
                        Requested Amount
                        <input type="number" name="amount" min="0" step="0.01" placeholder="e.g. 1200">
                      </label>
                      <label>
                        Family Situation
                        <select name="familySituation" required>
                          <option value="">Select</option>
                          <option value="Normal">Normal</option>
                          <option value="Financial Difficulty">Financial Difficulty</option>
                          <option value="Special Difficulty">Special Difficulty</option>
                        </select>
                      </label>
                      <label>
                        GPA / Average Score
                        <input type="text" name="academicScore" placeholder="e.g. 91.5" required>
                      </label>
                      <label>
                        Conduct Evaluation
                        <select name="conductEvaluation" required>
                          <option value="">Select</option>
                          <option value="Excellent">Excellent</option>
                          <option value="Good">Good</option>
                          <option value="Qualified">Qualified</option>
                        </select>
                      </label>
                      <label class="full">
                        Honors / Awards
                        <textarea name="honors" placeholder="List awards, competitions, volunteer work, class contributions"></textarea>
                      </label>
                      <label class="full">
                        Application Reason
                        <textarea name="reason" placeholder="Explain why you are applying, your academic performance, family situation, and future plan" required></textarea>
                      </label>
                      <label class="full">
                        Supporting Materials
                        <textarea name="materials" placeholder="Describe certificates or documents you will submit offline"></textarea>
                      </label>
                      <label class="checkbox-field">
                        <input type="checkbox" name="promise" value="true" required>
                        I promise the submitted information is true and accept review/publicity.
                      </label>
                      <div class="apply-actions">
                        <button class="primary-btn" type="submit">Submit Application</button>
                      </div>
                    </form>
                  </div>
                <% } %>
              </div>
            </article>

            <article class="card side">
              <h2>Application Detail</h2>
              <div class="info-list">
                <% if (selectedScholarship == null) { %>
                  <div class="info-row"><span>Status</span><strong>Select an application.</strong></div>
                <% } else { %>
                  <div class="info-row"><span>Application</span><strong><%= valueText(selectedScholarship.get("app_id")) %></strong></div>
                  <div class="info-row"><span>Type</span><strong><%= valueText(selectedScholarship.get("type_code")) %></strong></div>
                  <div class="info-row"><span>Description</span><strong><%= valueText(selectedScholarship.get("description")) %></strong></div>
                  <div class="info-row"><span>Status</span><span class="pill"><%= valueText(selectedScholarship.get("status")) %></span></div>
                  <div class="info-row"><span>Requested Amount</span><strong><%= valueText(selectedScholarship.get("requested_amount")) %></strong></div>
                  <div class="info-row"><span>Family Situation</span><strong><%= valueText(selectedScholarship.get("family_situation")) %></strong></div>
                  <div class="info-row"><span>Academic Score</span><strong><%= valueText(selectedScholarship.get("academic_score")) %></strong></div>
                  <div class="info-row"><span>Conduct</span><strong><%= valueText(selectedScholarship.get("conduct_evaluation")) %></strong></div>
                  <div class="info-row"><span>Honors</span><strong><%= valueText(selectedScholarship.get("honors")) %></strong></div>
                  <div class="info-row"><span>Reason</span><strong><%= valueText(selectedScholarship.get("application_reason")) %></strong></div>
                  <div class="info-row"><span>Materials</span><strong><%= valueText(selectedScholarship.get("supporting_materials")) %></strong></div>
                <% } %>
              </div>
            </article>
          </div>

          <article class="card span-12">
            <h2>Applied Scholarships</h2>
            <table>
              <thead><tr><th>Application</th><th>Type</th><th>Description</th><th>Status</th><th>Detail</th></tr></thead>
              <tbody>
                <% if (appliedScholarshipRows.isEmpty()) { %>
                  <tr><td colspan="5">No scholarship applications.</td></tr>
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
                        data-title="Application Detail"
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
                        data-materials="<%= attrValue(row.get("supporting_materials")) %>">View Detail</button>
                    </td>
                  </tr>
                <% }} %>
              </tbody>
            </table>
          </article>

          <article class="card span-12">
            <h2>Published Scholarships</h2>
            <table>
              <thead><tr><th>Student</th><th>Class</th><th>Type</th><th>Description</th><th>Status</th></tr></thead>
              <tbody>
                <% if (publishedScholarshipRows.isEmpty()) { %>
                  <tr><td colspan="5">No published scholarships.</td></tr>
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

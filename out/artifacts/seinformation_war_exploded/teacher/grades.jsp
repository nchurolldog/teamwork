<% if ("overview".equals(view) || "grades".equals(view)) { %>
<article class="card <%= "grades".equals(view) ? "span-12" : "span-6" %>" id="grade-work">
  <h2>成绩工作</h2>
  <% if ("success".equals(gradeStatus)) { %>
    <div class="notice">成绩保存成功。</div>
  <% } else if ("created".equals(gradeStatus)) { %>
    <div class="notice">成绩创建成功。</div>
  <% } else if (gradeError != null && !gradeError.isEmpty()) { %>
    <div class="notice error">
      <%
        String errorMsg = "操作失败。";
        if ("missing_fields".equals(gradeError)) {
          errorMsg = "请填写所有必填字段。";
        } else if ("invalid_weight".equals(gradeError)) {
          errorMsg = "平时成绩占比必须在0-100之间。";
        } else if ("invalid_regular".equals(gradeError)) {
          errorMsg = "平时成绩必须在0-100之间。";
        } else if ("invalid_final".equals(gradeError)) {
          errorMsg = "期末成绩必须在0-100之间。";
        } else if ("invalid_number".equals(gradeError)) {
          errorMsg = "请输入有效的数字。";
        } else if ("save_failed".equals(gradeError)) {
          errorMsg = "保存失败，请稍后重试。";
        } else if ("already_exists".equals(gradeError)) {
          errorMsg = "该学生此课程的成绩已存在。";
        }
      %><%= errorMsg %>
    </div>
  <% } %>

  <% if ("grades".equals(view)) { %>
    <div style="margin-bottom: 16px; display: flex; justify-content: space-between; align-items: center;">
      <h3 style="margin: 0;">成绩列表</h3>
      <button type="button" class="primary-btn" id="openNewGradeModal" style="cursor: pointer;">
        <i class="fas fa-plus"></i> 新建成绩
      </button>
    </div>

    <table>
      <thead>
        <tr>
          <th>课程</th>
          <th>学生</th>
          <th>班级</th>
          <th>平时成绩占比(%)</th>
          <th>平时成绩</th>
          <th>期末成绩</th>
          <th>总成绩</th>
          <th>操作</th>
        </tr>
      </thead>
      <tbody>
      <% if (teacherCourseGrades.isEmpty()) { %>
        <tr><td colspan="8">暂无成绩记录。</td></tr>
      <% } else {
        String currentCourseId = null;
        for (Map<String, Object> row : teacherCourseGrades) {
          String courseId = (String) row.get("course_id");
          if (!courseId.equals(currentCourseId)) {
            currentCourseId = courseId;
      %>
        <tr style="background-color: var(--cyan); font-weight: bold;">
          <td colspan="8"><%= valueText(row.get("course_name")) %></td>
        </tr>
      <% } %>
        <tr>
          <td></td>
          <td><%= valueText(row.get("student_name")) %></td>
          <td><%= valueText(row.get("class_name")) %></td>
          <td>
            <input type="number" name="regularWeight_<%= valueText(row.get("student_id")) %>_<%= valueText(row.get("course_id")) %>"
                   id="weight_<%= valueText(row.get("student_id")) %>_<%= valueText(row.get("course_id")) %>"
                   value="<%= row.get("regular_weight") != null ? row.get("regular_weight") : 30 %>"
                   min="0" max="100" step="1"
                   style="width: 70px;" required
                   onchange="calculateTotal('<%= valueText(row.get("student_id")) %>', '<%= valueText(row.get("course_id")) %>')">
          </td>
          <td>
              <input type="number" name="regularGrade_<%= valueText(row.get("student_id")) %>_<%= valueText(row.get("course_id")) %>"
                     id="regular_<%= valueText(row.get("student_id")) %>_<%= valueText(row.get("course_id")) %>"
                     value="<%= row.get("regular_grade") != null ? row.get("regular_grade") : "" %>"
                     min="0" max="100" step="0.01"
                     style="width: 80px;" required
                     onchange="calculateTotal('<%= valueText(row.get("student_id")) %>', '<%= valueText(row.get("course_id")) %>')">
          </td>
          <td>
              <input type="number" name="finalGrade_<%= valueText(row.get("student_id")) %>_<%= valueText(row.get("course_id")) %>"
                     id="final_<%= valueText(row.get("student_id")) %>_<%= valueText(row.get("course_id")) %>"
                     value="<%= row.get("final_grade") != null ? row.get("final_grade") : "" %>"
                     min="0" max="100" step="0.01"
                     style="width: 80px;" required
                     onchange="calculateTotal('<%= valueText(row.get("student_id")) %>', '<%= valueText(row.get("course_id")) %>')">
          </td>
          <td>
              <span class="total-grade" id="total_<%= valueText(row.get("student_id")) %>_<%= valueText(row.get("course_id")) %>" style="font-weight: bold; color: var(--navy);">
                <%= row.get("total_grade") != null ? row.get("total_grade") : "-" %>
              </span>
          </td>
          <td>
              <form action="updateGrade" method="post" style="display: inline-flex; gap: 8px; align-items: center;">
                <input type="hidden" name="studentID" value="<%= valueText(row.get("student_id")) %>">
                <input type="hidden" name="courseID" value="<%= valueText(row.get("course_id")) %>">
                <input type="hidden" name="regularWeight" id="form_weight_<%= valueText(row.get("student_id")) %>_<%= valueText(row.get("course_id")) %>">
                <input type="hidden" name="regularGrade" id="form_regular_<%= valueText(row.get("student_id")) %>_<%= valueText(row.get("course_id")) %>">
                <input type="hidden" name="finalGrade" id="form_final_<%= valueText(row.get("student_id")) %>_<%= valueText(row.get("course_id")) %>">
                <button type="submit" class="small-btn">保存</button>
              </form>
          </td>
        </tr>
      <% }} %>
      </tbody>
    </table>

    <script>
      function calculateTotal(studentId, courseId) {
        var weightInput = document.getElementById('weight_' + studentId + '_' + courseId);
        var regularInput = document.getElementById('regular_' + studentId + '_' + courseId);
        var finalInput = document.getElementById('final_' + studentId + '_' + courseId);
        var totalSpan = document.getElementById('total_' + studentId + '_' + courseId);

        var formWeightInput = document.getElementById('form_weight_' + studentId + '_' + courseId);
        var formRegularInput = document.getElementById('form_regular_' + studentId + '_' + courseId);
        var formFinalInput = document.getElementById('form_final_' + studentId + '_' + courseId);

        var weight = parseFloat(weightInput.value) || 0;
        var regular = parseFloat(regularInput.value);
        var finalScore = parseFloat(finalInput.value);

        if (!isNaN(regular) && !isNaN(finalScore)) {
          var finalWeight = 100 - weight;
          var total = (weight * regular + finalWeight * finalScore) / 100;
          totalSpan.textContent = total.toFixed(2);

          formWeightInput.value = weightInput.value;
          formRegularInput.value = regularInput.value;
          formFinalInput.value = finalInput.value;
        } else {
          totalSpan.textContent = '-';
          formWeightInput.value = '';
          formRegularInput.value = '';
          formFinalInput.value = '';
        }
      }

      document.addEventListener('DOMContentLoaded', function() {
        var rows = document.querySelectorAll('tbody tr');
        rows.forEach(function(row) {
          var inputs = row.querySelectorAll('input[type="number"]');
          if (inputs.length >= 3) {
            var studentId = inputs[0].id.replace('weight_', '').split('_')[0];
            var courseId = inputs[0].id.replace('weight_', '').split('_')[1];
            calculateTotal(studentId, courseId);
          }
        });
      });

      // 新建成绩模态框
      const newGradeModal = document.createElement('div');
      newGradeModal.className = 'modal-mask';
      newGradeModal.id = 'newGradeModal';
      newGradeModal.setAttribute('aria-hidden', 'true');
      newGradeModal.innerHTML = `
        <section class="profile-modal" role="dialog" aria-modal="true" aria-labelledby="newGradeTitle">
          <div class="modal-head">
            <h2 id="newGradeTitle">新建成绩</h2>
            <button class="close-modal" type="button" id="closeNewGrade" aria-label="Close"><i class="fas fa-xmark"></i></button>
          </div>
          <form action="createGrade" method="post">
            <div class="form-grid">
              <label class="form-field full">
                选择学生
                <select name="studentID" required>
                  <option value="">请选择学生</option>
                  <% for (Map<String, Object> student : teacherClassStudents) { %>
                    <option value="<%= valueText(student.get("student_id")) %>">
                      <%= valueText(student.get("name")) %> (<%= valueText(student.get("class_name")) %>)
                    </option>
                  <% } %>
                </select>
              </label>
              <label class="form-field full">
                选择课程
                <select name="courseID" required>
                  <option value="">请选择课程</option>
                  <% for (Map<String, Object> course : teacherCourses) { %>
                    <option value="<%= valueText(course.get("course_id")) %>">
                      <%= valueText(course.get("course_name")) %>
                    </option>
                  <% } %>
                </select>
              </label>
              <label class="form-field">
                平时成绩占比(%)
                <input type="number" name="regularWeight" value="30" min="0" max="100" step="1" required>
              </label>
              <label class="form-field">
                平时成绩
                <input type="number" name="regularGrade" min="0" max="100" step="0.01" required>
              </label>
              <label class="form-field">
                期末成绩
                <input type="number" name="finalGrade" min="0" max="100" step="0.01" required>
              </label>
              <label class="form-field">
                总成绩（自动计算）
                <input type="text" id="previewTotal" readonly style="background: var(--page); font-weight: bold; color: var(--navy);">
              </label>
            </div>
            <div class="form-actions">
              <button class="secondary-btn" type="button" id="cancelNewGrade">取消</button>
              <button class="primary-btn" type="submit">创建</button>
            </div>
          </form>
        </section>
      `;
      document.body.appendChild(newGradeModal);

      const openNewGradeBtn = document.getElementById('openNewGradeModal');
      const closeNewGradeBtn = document.getElementById('closeNewGrade');
      const cancelNewGradeBtn = document.getElementById('cancelNewGrade');

      function openNewGradeModal() {
        newGradeModal.classList.add('show');
        newGradeModal.setAttribute('aria-hidden', 'false');
      }

      function closeNewGradeModal() {
        newGradeModal.classList.remove('show');
        newGradeModal.setAttribute('aria-hidden', 'true');
      }

      if (openNewGradeBtn) {
        openNewGradeBtn.addEventListener('click', openNewGradeModal);
      }
      if (closeNewGradeBtn) {
        closeNewGradeBtn.addEventListener('click', closeNewGradeModal);
      }
      if (cancelNewGradeBtn) {
        cancelNewGradeBtn.addEventListener('click', closeNewGradeModal);
      }
      if (newGradeModal) {
        newGradeModal.addEventListener('click', function(event) {
          if (event.target === newGradeModal) {
            closeNewGradeModal();
          }
        });
      }

      // 自动计算总分预览
      const newGradeForm = newGradeModal.querySelector('form');
      const weightInput = newGradeForm.querySelector('[name="regularWeight"]');
      const regularInput = newGradeForm.querySelector('[name="regularGrade"]');
      const finalInput = newGradeForm.querySelector('[name="finalGrade"]');
      const previewTotal = document.getElementById('previewTotal');

      function updatePreviewTotal() {
        var weight = parseFloat(weightInput.value) || 30;
        var regular = parseFloat(regularInput.value);
        var finalScore = parseFloat(finalInput.value);

        if (!isNaN(regular) && !isNaN(finalScore)) {
          var finalWeight = 100 - weight;
          var total = (weight * regular + finalWeight * finalScore) / 100;
          previewTotal.value = total.toFixed(2);
        } else {
          previewTotal.value = '';
        }
      }

      weightInput.addEventListener('input', updatePreviewTotal);
      regularInput.addEventListener('input', updatePreviewTotal);
      finalInput.addEventListener('input', updatePreviewTotal);
    </script>
  <% } else { %>
    <div class="info-list">
      <div class="info-row"><span>成绩记录</span><strong><%= teacherGradeCount %></strong></div>
      <div class="info-row"><span>有更新的课程</span><strong><%= teacherCourseCount %></strong></div>
      <div class="info-row"><span>需要关注的学生</span><strong>
        <%
          int supportCount = 0;
          for (Map<String, Object> row : teacherStudentRows) {
            Object avgGrade = row.get("avg_grade");
            if (avgGrade instanceof Number && ((Number) avgGrade).doubleValue() < 75) {
              supportCount++;
            }
          }
        %><%= supportCount %>
      </strong></div>
    </div>
    <div style="margin-top: 16px;">
      <a href="teacher.jsp?view=grades" class="primary-btn" style="text-decoration: none; display: inline-block;">进入成绩管理</a>
    </div>
  <% } %>
</article>
<% } %>

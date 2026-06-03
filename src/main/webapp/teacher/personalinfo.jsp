        <% if ("overview".equals(view) || "personal".equals(view)) { %>
        <article class="card <%= "personal".equals(view) ? "span-12" : "span-4" %>">
          <div class="card-head">
            <h2>Personal Info</h2>
            <button class="edit-profile" type="button" id="openProfileEditor"><i class="fas fa-pen-to-square"></i><span>Edit</span></button>
          </div>
          <div class="info-list">
            <div class="info-row"><span>Employee ID</span><strong><%= textOrDash(employeeID) %></strong></div>
            <div class="info-row"><span>Name</span><strong><%= teacher == null ? "Waiting for teacher profile" : textOrDash(teacher.getName()) %></strong></div>
            <div class="info-row"><span>Gender</span><strong><%= teacher == null ? "-" : genderText(teacher.getGender()) %></strong></div>
            <div class="info-row"><span>Role</span><span class="pill">Teacher</span></div>
          </div>
        </article>
        <% } %>

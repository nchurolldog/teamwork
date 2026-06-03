        <% if ("personal".equals(view)) { %>
        <article class="card span-12">
          <div class="card-head">
            <h2>Personal Info</h2>
            <button class="edit-profile" type="button" id="openProfileEditor"><i class="fas fa-pen-to-square"></i><span>Edit</span></button>
          </div>
          <div class="info-list">
            <div class="info-row"><span>Name</span><strong><%= student == null ? "Waiting for profile data" : textOrDash(student.getName()) %></strong></div>
            <div class="info-row"><span>Student ID</span><strong><%= textOrDash(studentID) %></strong></div>
            <div class="info-row"><span>Gender</span><strong><%= student == null ? "-" : genderText(student.getGender()) %></strong></div>
            <div class="info-row"><span>Position</span><strong><%= student == null ? "-" : textOrDash(student.getPosition()) %></strong></div>
            <div class="info-row"><span>Origin Place</span><strong><%= personalInfo == null ? "-" : textOrDash(personalInfo.getOriginPlace()) %></strong></div>
            <div class="info-row"><span>Political Status</span><strong><%= personalInfo == null ? "-" : textOrDash(personalInfo.getPoliticalStatus()) %></strong></div>
          </div>
        </article>
        <% } %>

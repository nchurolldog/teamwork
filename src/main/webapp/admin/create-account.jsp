        <section class="panel">
          <div class="panel-head">
            <div class="panel-title">Create Staff Account</div>
            <span class="pill">Admin Only</span>
          </div>
          <form action="adminCreateUser" method="post" class="table-tools" style="flex-wrap: wrap;">
            <input type="text" name="account" placeholder="Account" required>
            <input type="password" name="password" placeholder="Password" required>
            <select name="userType" aria-label="User role" required>
              <option value="1">Teacher</option>
              <option value="2">Counselor</option>
              <option value="0">Administrator</option>
            </select>
            <button class="add-student" type="submit">+ Create Account</button>
          </form>
          <p style="margin: 12px 0 0; color: #708092; font-size: 12px;">Students create their own accounts from the login page. Teacher, counselor, and administrator accounts can only be created here.</p>
        </section>

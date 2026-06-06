# Controller Package Layout

Servlet routes stay on their original `@WebServlet` paths. The folders below are only for source-code organization.

- `admin`: administrator-only actions, such as creating managed accounts.
- `auth`: login, logout, and student self-registration.
- `profile`: personal information and avatar updates.
- `scholarship`: scholarship application and review workflow actions.
- `student`: class-student management actions shared by teacher and counselor pages.

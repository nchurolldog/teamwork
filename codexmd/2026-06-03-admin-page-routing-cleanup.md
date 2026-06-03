# Admin Page Routing Cleanup

## What changed

- Reworked `admin.jsp` navigation to use real server-side links with a `view` parameter.
- Added functional admin views for dashboard, accounts, students, classes, applications, and class meetings.
- Fixed Class Meetings so edit, create, update, delete, cancel, and default redirects return to `admin.jsp?view=meetings`.
- Removed the old JavaScript-only Class Meetings toggle that hid and showed panels on one overloaded page.
- Removed unused or fake admin blocks, including static enrollment trends, attendance overview, and special programs fallback cards.
- Added a single-column layout for the Class Meetings view so it no longer leaves an empty right column.
- Styled sidebar links and the sidebar system snapshot link so they behave like the rest of the dashboard UI.

## Verification

- Ran `mvn -q package` successfully.
- Synced updated JSP files and compiled classes into `out/artifacts/seinformation_war_exploded`.

# Entra AD Sign-In Logs 

This PowerShell script connects to Microsoft Graph to retrieve and analyze Azure AD sign-in activity for members of a specific group.

**Key Features:**

* Connects to Microsoft Graph with permissions to read audit logs and group information.
* Retrieves all members of a specified Azure AD group.
* Fetches sign-in logs from the past 7 days.
* Filters sign-ins by location and application (placeholders in the script).
* Outputs a readable table with date, user, location, IP, app, and sign-in status.
* Sorts results by date, newest first.

**Setup & Usage:**

1. Install the required modules if not already installed:

   ```powershell
   Install-Module Microsoft.Graph.Users
   Install-Module Microsoft.Graph.Reports
   ```
2. Set your **Azure AD Group ID** and optional filters in the script.
3. Run the script in PowerShell:

   ```powershell
   .\SignIn-Logs-Monitoring.ps1
   ```

---


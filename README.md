# Team Project Board

An ASP.NET Web Forms (.NET Framework 4.8) and SQL Server app for managing team projects: create projects, manage members, track tasks on a Kanban board, and view progress reports.

## Features
- **Dashboard** (`Default.aspx`): counts, calendar, tasks due on a chosen date, pie-chart shortcut to reports
- **Board** (`Board.aspx`): Kanban columns To Do / In Progress / Done; add, move and delete tasks
- **Projects** (`Projects.aspx`): create, edit, delete projects
- **Team** (`Team.aspx`): create, edit, delete members
- **Report** (`Report.aspx`): open tasks by priority (bar chart), tasks by status (pie chart), progress bars with overdue flags

## Setup
1. In SSMS, open `Database/TeamBoardDB.sql` and execute it (creates the database, 3 tables and sample data).
2. Edit the connection string in `Web.config` if your server differs (e.g. `.\SQLEXPRESS`, `localhost`, `(localdb)\MSSQLLocalDB`).
3. In Visual Studio: File > Open > Web Site... and select this folder, then press F5.

## Tech
ASP.NET Web Forms, C#, SQL Server, Chart control (`System.Web.DataVisualization`), HTML/CSS.

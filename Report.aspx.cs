using System;
using System.Data;
using System.Web.UI.DataVisualization.Charting;

public partial class Report : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack) return;

        BindPriorityChart();
        BindStatusChart();
        BindEmployeeProgress();
        BindProjectProgress();
    }

    void BindPriorityChart()
    {
        DataTable dt = Db.Table(
            @"SELECT Priority, COUNT(*) AS Cnt FROM Tasks
              WHERE Status <> 'Done' GROUP BY Priority");

        var colors = new System.Collections.Generic.Dictionary<string, System.Drawing.Color> {
            { "High",   System.Drawing.ColorTranslator.FromHtml("#B42318") },
            { "Medium", System.Drawing.ColorTranslator.FromHtml("#D97706") },
            { "Low",    System.Drawing.ColorTranslator.FromHtml("#15803D") }
        };

        var series = chtPriority.Series["Priority"];
        series.Points.DataBindXY(dt.DefaultView, "Priority", dt.DefaultView, "Cnt");
        series.IsValueShownAsLabel = true;
        foreach (DataPoint pt in series.Points)
            if (colors.ContainsKey(pt.AxisLabel)) pt.Color = colors[pt.AxisLabel];

        var area = chtPriority.ChartAreas["CA1"];
        area.AxisY.MajorGrid.LineColor = System.Drawing.ColorTranslator.FromHtml("#E1E6EC");
        area.AxisX.MajorGrid.Enabled = false;
        area.AxisY.Interval = 1;
    }

    void BindStatusChart()
    {
        DataTable dt = Db.Table("SELECT Status, COUNT(*) AS Cnt FROM Tasks GROUP BY Status");

        var colors = new System.Collections.Generic.Dictionary<string, System.Drawing.Color> {
            { "To Do",       System.Drawing.ColorTranslator.FromHtml("#94A3B8") },
            { "In Progress", System.Drawing.ColorTranslator.FromHtml("#D97706") },
            { "Done",        System.Drawing.ColorTranslator.FromHtml("#0F766E") }
        };

        var series = chtStatus.Series["Status"];
        series.Points.DataBindXY(dt.DefaultView, "Status", dt.DefaultView, "Cnt");
        series.IsValueShownAsLabel = true;
        series["PieLabelStyle"] = "Outside";
        foreach (DataPoint pt in series.Points)
            if (colors.ContainsKey(pt.AxisLabel)) pt.Color = colors[pt.AxisLabel];
    }

    void BindEmployeeProgress()
    {
        DataTable dt = Db.Table(
            @"SELECT m.FullName,
                     COUNT(t.TaskId) AS Total,
                     SUM(CASE WHEN t.Status = 'Done' THEN 1 ELSE 0 END) AS Done,
                     SUM(CASE WHEN t.Status <> 'Done' AND t.DueDate < CAST(GETDATE() AS date) THEN 1 ELSE 0 END) AS Overdue
              FROM Members m LEFT JOIN Tasks t ON t.AssignedTo = m.MemberId
              GROUP BY m.MemberId, m.FullName ORDER BY m.FullName");

        AddPctColumn(dt);
        rptEmployees.DataSource = dt;
        rptEmployees.DataBind();
    }

    void BindProjectProgress()
    {
        DataTable dt = Db.Table(
            @"SELECT p.Name, p.DueDate,
                     COUNT(t.TaskId) AS Total,
                     SUM(CASE WHEN t.Status = 'Done' THEN 1 ELSE 0 END) AS Done,
                     SUM(CASE WHEN t.Status <> 'Done' AND t.DueDate < CAST(GETDATE() AS date) THEN 1 ELSE 0 END) AS Overdue
              FROM Projects p LEFT JOIN Tasks t ON t.ProjectId = p.ProjectId
              GROUP BY p.ProjectId, p.Name, p.DueDate ORDER BY p.DueDate");

        AddPctColumn(dt);
        rptProjects.DataSource = dt;
        rptProjects.DataBind();
    }

    // Adds a whole-number "Pct" column (% of Total that are Done), safe against divide-by-zero.
    void AddPctColumn(DataTable dt)
    {
        dt.Columns.Add("Pct", typeof(int));
        foreach (DataRow row in dt.Rows)
        {
            int total = row["Total"] == DBNull.Value ? 0 : Convert.ToInt32(row["Total"]);
            int done = row["Done"] == DBNull.Value ? 0 : Convert.ToInt32(row["Done"]);
            row["Pct"] = total == 0 ? 0 : (int)Math.Round(done * 100.0 / total);
        }
    }
}

using System;
using System.Data;

public partial class _Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
            calDue.SelectedDate = DateTime.Today;

        lblProjects.Text = Db.Scalar("SELECT COUNT(*) FROM Projects").ToString();
        lblMembers.Text  = Db.Scalar("SELECT COUNT(*) FROM Members").ToString();
        lblOpen.Text     = Db.Scalar("SELECT COUNT(*) FROM Tasks WHERE Status <> 'Done'").ToString();
        lblDone.Text     = Db.Scalar("SELECT COUNT(*) FROM Tasks WHERE Status = 'Done'").ToString();
        lblOverdue.Text  = Db.Scalar("SELECT COUNT(*) FROM Tasks WHERE Status <> 'Done' AND DueDate < CAST(GETDATE() AS date)").ToString();

        if (!IsPostBack) BindMiniChart();
    }

    // Small status pie used as the shortcut into the Report page.
    void BindMiniChart()
    {
        DataTable dt = Db.Table("SELECT Status, COUNT(*) AS Cnt FROM Tasks GROUP BY Status");

        var colors = new System.Collections.Generic.Dictionary<string, System.Drawing.Color> {
            { "To Do",       System.Drawing.ColorTranslator.FromHtml("#94A3B8") },
            { "In Progress", System.Drawing.ColorTranslator.FromHtml("#D97706") },
            { "Done",        System.Drawing.ColorTranslator.FromHtml("#0F766E") }
        };

        var series = chtMini.Series["S1"];
        series.Points.DataBindXY(dt.DefaultView, "Status", dt.DefaultView, "Cnt");
        foreach (System.Web.UI.DataVisualization.Charting.DataPoint pt in series.Points)
        {
            pt.Label = "";
            if (colors.ContainsKey(pt.AxisLabel)) pt.Color = colors[pt.AxisLabel];
        }
    }

    protected void Page_PreRender(object sender, EventArgs e)
    {
        lblDate.Text = calDue.SelectedDate.ToString("dd MMM yyyy");
    }
}

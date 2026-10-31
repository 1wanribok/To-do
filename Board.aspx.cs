using System;
using System.Data;
using System.Web.UI.WebControls;

public partial class Board : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack) return;

        ddlProject.DataSource = Db.Table("SELECT ProjectId, Name FROM Projects ORDER BY Name");
        ddlProject.DataValueField = "ProjectId";
        ddlProject.DataTextField = "Name";
        ddlProject.DataBind();

        ddlAssignee.DataSource = Db.Table("SELECT MemberId, FullName FROM Members ORDER BY FullName");
        ddlAssignee.DataValueField = "MemberId";
        ddlAssignee.DataTextField = "FullName";
        ddlAssignee.DataBind();
        ddlAssignee.Items.Insert(0, new ListItem("Unassigned", ""));
    }

    // Runs after button clicks, so the board always shows the latest data.
    protected void Page_PreRender(object sender, EventArgs e)
    {
        bool hasProject = ddlProject.Items.Count > 0;
        pnlBoard.Visible = hasProject;
        lblEmpty.Visible = !hasProject;
        if (!hasProject) return;

        DataTable dt = Db.Table(
            @"SELECT t.TaskId, t.Title, t.Priority, t.DueDate, t.Status, ISNULL(m.FullName, 'Unassigned') AS Assignee
              FROM Tasks t LEFT JOIN Members m ON m.MemberId = t.AssignedTo
              WHERE t.ProjectId = @p ORDER BY t.TaskId",
            "@p", int.Parse(ddlProject.SelectedValue));

        Fill(rptTodo,  lblTodo,  dt, "To Do");
        Fill(rptDoing, lblDoing, dt, "In Progress");
        Fill(rptDone,  lblDone,  dt, "Done");
    }

    void Fill(Repeater rpt, Label count, DataTable dt, string status)
    {
        var view = new DataView(dt) { RowFilter = "Status = '" + status + "'" };
        rpt.DataSource = view;
        rpt.DataBind();
        count.Text = view.Count.ToString();
    }

    protected void btnAdd_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        object assignee = ddlAssignee.SelectedValue == "" ? null : (object)int.Parse(ddlAssignee.SelectedValue);
        DateTime due;
        object dueDate = DateTime.TryParse(txtDue.Text, out due) ? (object)due : null;

        Db.Exec(@"INSERT INTO Tasks (ProjectId, AssignedTo, Title, Priority, DueDate)
                  VALUES (@p, @a, @t, @pr, @d)",
                "@p", int.Parse(ddlProject.SelectedValue), "@a", assignee,
                "@t", txtTitle.Text.Trim(), "@pr", rblPriority.SelectedValue, "@d", dueDate);

        txtTitle.Text = "";
        txtDue.Text = "";
    }

    // One handler for the three columns: move right, move left, or delete.
    protected void Card_Command(object source, RepeaterCommandEventArgs e)
    {
        int id = int.Parse((string)e.CommandArgument);

        if (e.CommandName == "Right")
            Db.Exec(@"UPDATE Tasks SET Status = CASE Status WHEN 'To Do' THEN 'In Progress'
                                                            WHEN 'In Progress' THEN 'Done' ELSE Status END
                      WHERE TaskId = @id", "@id", id);
        else if (e.CommandName == "Left")
            Db.Exec(@"UPDATE Tasks SET Status = CASE Status WHEN 'Done' THEN 'In Progress'
                                                            WHEN 'In Progress' THEN 'To Do' ELSE Status END
                      WHERE TaskId = @id", "@id", id);
        else if (e.CommandName == "Delete")
            Db.Exec("DELETE FROM Tasks WHERE TaskId = @id", "@id", id);
    }
}

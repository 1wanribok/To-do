using System;

public partial class Projects : System.Web.UI.Page
{
    protected void btnAdd_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;
        sdsProjects.Insert();
        txtName.Text = "";
        txtDesc.Text = "";
        txtDue.Text = "";
    }
}

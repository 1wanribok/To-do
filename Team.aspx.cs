using System;

public partial class Team : System.Web.UI.Page
{
    protected void btnAdd_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;
        sdsMembers.Insert();
        txtName.Text = "";
        txtEmail.Text = "";
    }
}

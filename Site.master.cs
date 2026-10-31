using System;
using System.IO;
using System.Web.UI.WebControls;

public partial class SiteMaster : System.Web.UI.MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        lblYear.Text = DateTime.Now.Year.ToString();
        lblToday.Text = DateTime.Now.ToString("dddd, dd MMM yyyy");

        // Highlight the link of the page that is currently open
        string current = Path.GetFileName(Request.Path);
        foreach (var c in nav.Controls)
        {
            var link = c as HyperLink;
            if (link != null && link.NavigateUrl.EndsWith(current, StringComparison.OrdinalIgnoreCase))
                link.CssClass = "active";
        }
    }
}

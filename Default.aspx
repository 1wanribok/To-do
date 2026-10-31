<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h1>Dashboard</h1>

    <div class="stats">
        <div class="stat"><b><asp:Label ID="lblProjects" runat="server" /></b>Projects</div>
        <div class="stat"><b><asp:Label ID="lblMembers" runat="server" /></b>Team members</div>
        <div class="stat"><b><asp:Label ID="lblOpen" runat="server" /></b>Open tasks</div>
        <div class="stat"><b><asp:Label ID="lblDone" runat="server" /></b>Completed</div>
        <div class="stat late"><b><asp:Label ID="lblOverdue" runat="server" /></b>Overdue</div>
    </div>

    <a class="panel report-shortcut" href="Report.aspx">
        <asp:Chart ID="chtMini" runat="server" Width="110px" Height="90px" BackColor="Transparent">
            <Series><asp:Series Name="S1" ChartType="Pie" /></Series>
            <ChartAreas><asp:ChartArea Name="CA1" /></ChartAreas>
        </asp:Chart>
        <div class="report-shortcut-text">
            <h2>Report</h2>
            <p class="hint">Employee &amp; project progress by priority and due date</p>
        </div>
        <span class="report-shortcut-arrow">&rarr;</span>
    </a>

    <div class="two-col">
        <section class="panel">
            <h2>Pick a due date</h2>
            <asp:Calendar ID="calDue" runat="server" CssClass="calendar" />
        </section>

        <section class="panel">
            <h2>Tasks due on <asp:Label ID="lblDate" runat="server" /></h2>
            <asp:GridView ID="gvDue" runat="server" DataSourceID="sdsDue" AutoGenerateColumns="False"
                CssClass="grid" GridLines="None" EmptyDataText="No tasks are due on this date.">
                <Columns>
                    <asp:BoundField DataField="Title"    HeaderText="Task" />
                    <asp:BoundField DataField="Project"  HeaderText="Project" />
                    <asp:BoundField DataField="Assignee" HeaderText="Assigned to" />
                    <asp:BoundField DataField="Status"   HeaderText="Status" />
                </Columns>
            </asp:GridView>
            <asp:SqlDataSource ID="sdsDue" runat="server"
                ConnectionString="<%$ ConnectionStrings:TeamBoardDB %>"
                SelectCommand="SELECT t.Title, p.Name AS Project, ISNULL(m.FullName,'Unassigned') AS Assignee, t.Status
                               FROM Tasks t JOIN Projects p ON p.ProjectId = t.ProjectId
                               LEFT JOIN Members m ON m.MemberId = t.AssignedTo
                               WHERE t.DueDate = @d ORDER BY t.Status">
                <SelectParameters>
                    <asp:ControlParameter Name="d" ControlID="calDue" PropertyName="SelectedDate" Type="DateTime" />
                </SelectParameters>
            </asp:SqlDataSource>
        </section>
    </div>
</asp:Content>

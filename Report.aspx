<%@ Page Title="Report" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Report.aspx.cs" Inherits="Report" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h1>Report</h1>

    <div class="two-col">
        <section class="panel chart-panel">
            <h2>Open tasks by priority</h2>
            <asp:Chart ID="chtPriority" runat="server" Width="320px" Height="220px" BackColor="Transparent">
                <Series><asp:Series Name="Priority" ChartType="Column" /></Series>
                <ChartAreas><asp:ChartArea Name="CA1" /></ChartAreas>
            </asp:Chart>
        </section>

        <section class="panel chart-panel">
            <h2>All tasks by status</h2>
            <asp:Chart ID="chtStatus" runat="server" Width="320px" Height="220px" BackColor="Transparent">
                <Series><asp:Series Name="Status" ChartType="Pie" /></Series>
                <ChartAreas><asp:ChartArea Name="CA1" /></ChartAreas>
                <Legends><asp:Legend Docking="Right" /></Legends>
            </asp:Chart>
        </section>
    </div>

    <section class="panel">
        <h2>Employee progress</h2>
        <asp:Repeater ID="rptEmployees" runat="server">
            <ItemTemplate>
                <div class="progress-row">
                    <div class="progress-label">
                        <span><%#: Eval("FullName") %></span>
                        <span class="progress-sub">
                            <%#: Eval("Done") %>/<%#: Eval("Total") %> done
                            <%# (int)Eval("Overdue") > 0 ? " · " + Eval("Overdue") + " overdue" : "" %>
                        </span>
                    </div>
                    <div class="progress-bar"><div class="progress-fill" style="width:<%#: Eval("Pct") %>%"></div></div>
                    <div class="progress-pct"><%#: Eval("Pct") %>%</div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </section>

    <section class="panel">
        <h2>Project progress</h2>
        <asp:Repeater ID="rptProjects" runat="server">
            <ItemTemplate>
                <div class="progress-row">
                    <div class="progress-label">
                        <span><%#: Eval("Name") %></span>
                        <span class="progress-sub">
                            Due <%# Eval("DueDate", "{0:dd MMM yyyy}") %> &middot; <%#: Eval("Done") %>/<%#: Eval("Total") %> done
                            <%# (int)Eval("Overdue") > 0 ? "<span class=\"badge-overdue\"> overdue</span>" : "" %>
                        </span>
                    </div>
                    <div class="progress-bar"><div class="progress-fill" style="width:<%#: Eval("Pct") %>%"></div></div>
                    <div class="progress-pct"><%#: Eval("Pct") %>%</div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </section>
</asp:Content>

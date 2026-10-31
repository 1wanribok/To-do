<%@ Page Title="Board" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Board.aspx.cs" Inherits="Board" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h1>Board</h1>

    <div class="form-row project-pick">
        <div>
            <label>Project</label>
            <asp:DropDownList ID="ddlProject" runat="server" AutoPostBack="True" />
        </div>
    </div>

    <asp:Label ID="lblEmpty" runat="server" Visible="False" CssClass="hint"
        Text="No projects yet. Create one on the Projects page first." />

    <asp:Panel ID="pnlBoard" runat="server">
        <section class="panel">
            <h2>Add a task</h2>
            <div class="form-row">
                <div class="grow">
                    <label>Title</label>
                    <asp:TextBox ID="txtTitle" runat="server" MaxLength="200" />
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtTitle" ValidationGroup="task"
                        ErrorMessage="Enter a task title." CssClass="err" Display="Dynamic" />
                </div>
                <div>
                    <label>Assign to</label>
                    <asp:DropDownList ID="ddlAssignee" runat="server" />
                </div>
                <div>
                    <label>Due date</label>
                    <asp:TextBox ID="txtDue" runat="server" TextMode="Date" />
                </div>
                <div>
                    <label>Priority</label>
                    <asp:RadioButtonList ID="rblPriority" runat="server" RepeatDirection="Horizontal" CssClass="radios">
                        <asp:ListItem>Low</asp:ListItem>
                        <asp:ListItem Selected="True">Medium</asp:ListItem>
                        <asp:ListItem>High</asp:ListItem>
                    </asp:RadioButtonList>
                </div>
                <div>
                    <asp:Button ID="btnAdd" runat="server" Text="Add task" CssClass="btn" ValidationGroup="task" OnClick="btnAdd_Click" />
                </div>
            </div>
        </section>

        <div class="board">
            <section class="column">
                <h2>To Do <span class="count"><asp:Label ID="lblTodo" runat="server" /></span></h2>
                <asp:Repeater ID="rptTodo" runat="server" OnItemCommand="Card_Command">
                    <ItemTemplate>
                        <div class="card p-<%# Eval("Priority") %>">
                            <div class="card-title"><%#: Eval("Title") %></div>
                            <div class="card-meta"><%#: Eval("Assignee") %> &middot; <%#: Eval("Priority") %> &middot; <%# Eval("DueDate", "{0:dd MMM}") %></div>
                            <div class="card-actions">
                                <asp:LinkButton runat="server" CommandName="Right" CommandArgument='<%# Eval("TaskId") %>' Text="Start" />
                                <asp:LinkButton runat="server" CommandName="Delete" CommandArgument='<%# Eval("TaskId") %>' Text="Delete" CssClass="danger" OnClientClick="return confirm('Delete this task?');" />
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </section>

            <section class="column">
                <h2>In Progress <span class="count"><asp:Label ID="lblDoing" runat="server" /></span></h2>
                <asp:Repeater ID="rptDoing" runat="server" OnItemCommand="Card_Command">
                    <ItemTemplate>
                        <div class="card p-<%# Eval("Priority") %>">
                            <div class="card-title"><%#: Eval("Title") %></div>
                            <div class="card-meta"><%#: Eval("Assignee") %> &middot; <%#: Eval("Priority") %> &middot; <%# Eval("DueDate", "{0:dd MMM}") %></div>
                            <div class="card-actions">
                                <asp:LinkButton runat="server" CommandName="Left" CommandArgument='<%# Eval("TaskId") %>' Text="Move back" />
                                <asp:LinkButton runat="server" CommandName="Right" CommandArgument='<%# Eval("TaskId") %>' Text="Finish" />
                                <asp:LinkButton runat="server" CommandName="Delete" CommandArgument='<%# Eval("TaskId") %>' Text="Delete" CssClass="danger" OnClientClick="return confirm('Delete this task?');" />
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </section>

            <section class="column">
                <h2>Done <span class="count"><asp:Label ID="lblDone" runat="server" /></span></h2>
                <asp:Repeater ID="rptDone" runat="server" OnItemCommand="Card_Command">
                    <ItemTemplate>
                        <div class="card p-<%# Eval("Priority") %>">
                            <div class="card-title"><%#: Eval("Title") %></div>
                            <div class="card-meta"><%#: Eval("Assignee") %> &middot; <%#: Eval("Priority") %> &middot; <%# Eval("DueDate", "{0:dd MMM}") %></div>
                            <div class="card-actions">
                                <asp:LinkButton runat="server" CommandName="Left" CommandArgument='<%# Eval("TaskId") %>' Text="Reopen" />
                                <asp:LinkButton runat="server" CommandName="Delete" CommandArgument='<%# Eval("TaskId") %>' Text="Delete" CssClass="danger" OnClientClick="return confirm('Delete this task?');" />
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </section>
        </div>
    </asp:Panel>
</asp:Content>

﻿<%@ Page Title="Sole Vendor Request Form" Language="C#" MasterPageFile="~/Shared/ModuleMaster.master" AutoEventWireup="true" CodeFile="frmSoleVendorRequest.aspx.cs" Inherits="Chai.WorkflowManagment.Modules.Request.Views.frmSoleVendorRequest" %>

<%@ MasterType TypeName="Chai.WorkflowManagment.Modules.Shell.BaseMaster" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="content" ContentPlaceHolderID="DefaultContent" runat="Server">
    <script src="../js/libs/jquery-2.0.2.min.js"></script>
    <script type="text/javascript">
        function showSearch() {
            $(document).ready(function () {
                $('#searchModal').modal('show');
            });
        }
    </script>
    <script type="text/javascript">
        function Clickheretoprint(theid) {
            var disp_setting = "toolbar=yes,location=no,directories=yes,menubar=yes,";
            disp_setting += "scrollbars=yes,width=750, height=600, left=100, top=25";
            var content_vlue = document.getElementById(theid).innerHTML;

            var docprint = window.open("", "", disp_setting);
            docprint.document.open();
            docprint.document.write('<html><head><title>CHAI Ethiopia</title>');
            docprint.document.write('</head><body onLoad="self.print()"><center>');
            docprint.document.write(content_vlue);
            docprint.document.write('</center></body></html>');
            docprint.document.close();
            docprint.focus();
        }
    </script>
    

    <div class="jarviswidget jarviswidget-sortable">
        <header role="heading">
            <span class="widget-icon"><i class="fa fa-edit"></i></span>
            <h2>Sole Vendor Request</h2>
        </header>
        <div class="smart-form">
            <fieldset>
                <section class="col col-4">
                    <label id="lblPurchaseReq" runat="server" class="label" visible="true">
                        Purchase Request
                    </label>
                    <label class="select">
                        <asp:DropDownList ID="ddlPurchaseReq" AutoPostBack="true" runat="server" DataValueField="Id" DataTextField="RequestNo" OnSelectedIndexChanged="ddlPurchaseReq_SelectedIndexChanged" >
                        </asp:DropDownList><i></i>
                    </label>
                </section>
            </fieldset>
            <asp:Panel ID="pnlInfo" runat="server">
                <div class="alert alert-info fade in">
                    <button class="close" data-dismiss="alert">
                        ×
                    </button>
                    <i class="fa-fw fa fa-info"></i>
                    <strong>Info!</strong> Please select the Purchase Request Transaction to perform Solevendor Form
                </div>
            </asp:Panel>
            <asp:GridView ID="grvDetails" Visible="False"
                runat="server" AutoGenerateColumns="False" DataKeyNames="Id"
                CssClass="table table-striped table-bordered table-hover" OnSelectedIndexChanged="grvDetails_SelectedIndexChanged" AllowPaging="True" OnPageIndexChanging="grvDetails_PageIndexChanging" PageSize="15">
                <RowStyle CssClass="rowstyle" />
                <Columns>
                      <asp:BoundField DataField="PurchaseRequest.RequestNo" HeaderText="Purchase Request No" SortExpression="PurchaseRequest.RequestNo" />
                    <asp:BoundField DataField="ItemAccount.AccountName" HeaderText="AccountName" SortExpression="ItemAccount.AccountName" />
                    <asp:BoundField DataField="ItemAccount.AccountCode" HeaderText="Account Code" SortExpression="ItemAccount.AccountCode" />
                    <asp:BoundField DataField="Item" HeaderText="Item Description" SortExpression="Item"></asp:BoundField>
                    <asp:BoundField DataField="Qty" HeaderText="Quantity" SortExpression="Qty" />
                    <%--<asp:BoundField DataField="Project.ProjectCode" HeaderText="Project Code" />
                    <asp:BoundField DataField="Grant.GrantCode" HeaderText="Grant Code" />     --%>
                  <%--  <asp:CommandField ShowSelectButton="True" />--%>
                      
                      <asp:TemplateField>
                         
                          <ItemTemplate>
                              <asp:CheckBox ID="chkSelect" runat="server" />
                          </ItemTemplate>
                      </asp:TemplateField>
                      
                </Columns>
                <FooterStyle CssClass="FooterStyle" />
                <HeaderStyle CssClass="headerstyle" />
                <PagerStyle CssClass="PagerStyle" />
                <RowStyle CssClass="rowstyle" />
            </asp:GridView>

              <footer>
           <asp:Button ID="btnCreateSoleVendor" runat="server" CssClass="btn btn-primary" Text="Prepare Sole Vendor" OnClick="btnCreateSoleVendor_Click"/>
          </footer>

        </div>
        <!-- widget div-->


        <!-- widget edit box -->
        <div class="jarviswidget-editbox">
            <!-- This area used as dropdown edit box -->

        </div>
        <!-- end widget edit box -->

        <!-- widget content -->
        <div id="wid-id-1" class="jarviswidget" data-widget-custombutton="false" data-widget-editbutton="false">
            <div class="smart-form">
                <div class="widget-body no-padding">




                    
                </div>


                <div role="content">

                    <!-- widget edit box -->
                    <div class="jarviswidget-editbox">
                        <!-- This area used as dropdown edit box -->

                    </div>
                    <!-- end widget edit box -->

                    <!-- widget content -->
                    <div class="widget-body">
                        <div class="tab-content">
                            <div class="tab-pane" id="hr1">
                                <div class="tabbable tabs-below">
                                    <div class="tab-content padding-10">
                                        <div class="tab-pane" id="AA">
                                        </div>
                                    </div>
                                    <ul class="nav nav-tabs">
                                        <li class="active">
                                            <a data-toggle="tab" href="#AA">Tab 1</a>
                                        </li>
                                    </ul>
                                </div>

                            </div>
                            <div class="tab-pane active" id="hr2">
                                <ul class="nav nav-tabs">
                                    <li class="active">
                                        <a href="#iss1" data-toggle="tab">Sole Vendor Item Detail</a>
                                    </li>
                                    <li class="">
                                        <a href="#iss2" data-toggle="tab">Attachments</a>
                                    </li>
                                </ul>
                                <div class="tab-content padding-10">
                                    <div class="tab-pane active" id="iss1">
                                        <fieldset>
                                            <div class="row">
                                                <asp:DataGrid ID="dgSoleVenderDetail" runat="server" AlternatingRowStyle-CssClass="" AutoGenerateColumns="False" CellPadding="0"
                                                    CssClass="table table-striped table-bordered table-hover" PagerStyle-CssClass="paginate_button active" DataKeyField="Id"
                                                    GridLines="None" OnItemDataBound="dgSoleVenderDetail_ItemDataBound" ShowFooter="True" OnDeleteCommand="dgSoleVenderDetail_DeleteCommand"
                                                    OnItemCommand="dgSoleVenderDetail_ItemCommand" OnPageIndexChanged="dgSoleVenderDetail_PageIndexChanged" OnSelectedIndexChanged="dgSoleVenderDetail_SelectedIndexChanged" OnUpdateCommand="dgSoleVenderDetail_UpdateCommand" OnEditCommand="dgSoleVenderDetail_EditCommand">
                                                    <Columns>
                                                        <asp:TemplateColumn HeaderText="Account Code">


                                                            <%--  <FooterTemplate>
                                                                    <asp:DropDownList ID="ddlFItemAcc" runat="server" CssClass="form-control"
                                                                        AppendDataBoundItems="True" DataTextField="AccountName" DataValueField="Id"
                                                                        EnableViewState="true" AutoPostBack="True">
                                                                        <asp:ListItem Value="0">Select Item Account</asp:ListItem>
                                                                    </asp:DropDownList>
                                                                    <asp:RequiredFieldValidator ID="RfvFItemAcc" runat="server" CssClass="validator"
                                                                        ControlToValidate="ddlFItemAcc" Display="Dynamic"
                                                                        ErrorMessage="Item Account Required" InitialValue="0" SetFocusOnError="True"
                                                                        ValidationGroup="proadd"></asp:RequiredFieldValidator>
                                                                </FooterTemplate>--%>

                                                            <%-- <EditItemTemplate>
                                                                    <asp:DropDownList ID="ddlItemAcc" runat="server" CssClass="form-control"
                                                                        AppendDataBoundItems="True" DataTextField="AccountName" DataValueField="Id"
                                                                        AutoPostBack="True">
                                                                        <asp:ListItem Value="0">Select Item Account</asp:ListItem>
                                                                    </asp:DropDownList>
                                                                    <asp:RequiredFieldValidator ID="RfvItemAcc" runat="server" CssClass="validator"
                                                                        ControlToValidate="ddlItemAcc" ErrorMessage="Item Account Required"
                                                                        InitialValue="0" SetFocusOnError="True" ValidationGroup="proedit">*</asp:RequiredFieldValidator>
                                                                </EditItemTemplate>--%>

                                                            <ItemTemplate>
                                                                <asp:TextBox ID="txtAccCode" runat="server" CssClass="form-control" Enabled="false" Text='<%# DataBinder.Eval(Container.DataItem, "ItemAccount.AccountCode")%>'></asp:TextBox>
                                                                 </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderText="Item Description">



                                                            <%--   <FooterTemplate>
                                                                    <asp:TextBox ID="txtFDescription" runat="server" CssClass="form-control"></asp:TextBox>
                                                                    <asp:RequiredFieldValidator ID="RfvFDescription" runat="server" CssClass="validator" ControlToValidate="txtFDescription" ErrorMessage="Item Description Required" ValidationGroup="proadd">*</asp:RequiredFieldValidator>
                                                                </FooterTemplate>--%>
                                                            <%--  <EditItemTemplate>
                                                                    <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" Text=' <%# DataBinder.Eval(Container.DataItem, "ItemDescription")%>'></asp:TextBox>
                                                                    <asp:RequiredFieldValidator ID="RfvDescription" runat="server" CssClass="validator" ControlToValidate="txtDescription" ErrorMessage="Item Description Required" ValidationGroup="proedit">*</asp:RequiredFieldValidator>
                                                                </EditItemTemplate>--%>

                                                            <ItemTemplate>
                                                                <asp:TextBox ID="txtItem" runat="server" CssClass="form-control" Enabled="false" Text='<%# DataBinder.Eval(Container.DataItem, "ItemDescription")%>'></asp:TextBox>
                                                              
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                         <asp:TemplateColumn HeaderText="Supplier">
                                    <EditItemTemplate>
                                        <asp:DropDownList ID="ddlEdtSupplier" runat="server" CssClass="form-control"
                                            AppendDataBoundItems="True" DataTextField="SupplierName" DataValueField="Id"
                                            ValidationGroup="proedit">
                                            <asp:ListItem Value="0">Select Supplier</asp:ListItem>
                                        </asp:DropDownList>
                                        <asp:RequiredFieldValidator ID="RfvSupplier" runat="server" CssClass="validator"
                                            ControlToValidate="ddlEdtSupplier" ErrorMessage="Supplier Required"
                                            InitialValue="0" SetFocusOnError="True" ValidationGroup="proedit"></asp:RequiredFieldValidator>
                                    </EditItemTemplate>
                                   
                                    <ItemTemplate>
                                        <%# DataBinder.Eval(Container.DataItem, "SoleVendorSupplier.SupplierName")%>
                                    </ItemTemplate>
                                </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderText="Sole Vendor Justification Type">
                                                            <EditItemTemplate>
                                                                <asp:DropDownList runat="server" ID="ddlEdtSoleVendorJustification" CssClass="form-control">
                                                                    <asp:ListItem Value=" ">--Select Sole Vendor Justification--</asp:ListItem>
                                                                    <asp:ListItem>One Supplier</asp:ListItem>
                                                                    <asp:ListItem>One-of-a-kind</asp:ListItem>
                                                                    <asp:ListItem>Compatibility</asp:ListItem>
                                                                    <asp:ListItem>Replacement Part</asp:ListItem>
                                                                    <asp:ListItem>Research Continuity</asp:ListItem>
                                                                    <asp:ListItem>CHAI standards</asp:ListItem>
                                                                    <asp:ListItem>Unique design</asp:ListItem>
                                                                    <asp:ListItem>Other</asp:ListItem>
                                                                </asp:DropDownList>
                                                                <asp:RequiredFieldValidator ID="rfvSoleJust" runat="server" ControlToValidate="ddlEdtSoleVendorJustification"
                                                                    CssClass="validator" InitialValue="" Display="Dynamic" ErrorMessage="Enter Sole Vendor Justification"
                                                                    SetFocusOnError="true" ValidationGroup="proedit">*</asp:RequiredFieldValidator>
                                                            </EditItemTemplate>
                                                            <%--<FooterTemplate>
                                                                    <asp:DropDownList runat="server" ID="ddlSoleVendorJustification" CssClass="form-control">
                                                                        <asp:ListItem Value="">--Select Sole Vendor Justification--</asp:ListItem>
                                                                        <asp:ListItem>One Supplier</asp:ListItem>
                                                                        <asp:ListItem>One-of-a-kind</asp:ListItem>
                                                                        <asp:ListItem>Compatibility</asp:ListItem>
                                                                        <asp:ListItem>Replacement Part</asp:ListItem>
                                                                        <asp:ListItem>Research Continuity</asp:ListItem>
                                                                        <asp:ListItem>CHAI standards</asp:ListItem>
                                                                        <asp:ListItem>Unique design</asp:ListItem>
                                                                        <asp:ListItem>Other</asp:ListItem>
                                                                    </asp:DropDownList>
                                                                    <asp:RequiredFieldValidator ID="rfvFSoleJust" runat="server" ControlToValidate="ddlSoleVendorJustification"
                                                                        CssClass="validator" InitialValue="" Display="Dynamic" ErrorMessage="Enter Sole Vendor Justification"
                                                                        SetFocusOnError="true" ValidationGroup="proadd">*</asp:RequiredFieldValidator>
                                                                </FooterTemplate>--%>
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "SoleVendorJustificationType")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                          <asp:TemplateColumn HeaderText="Reason For Selection">
                                    <ItemTemplate>
                                        <%# DataBinder.Eval(Container.DataItem, "ReasonForSelection")%>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtReason" runat="server" CssClass="form-control" Visible="true" Text=' <%# DataBinder.Eval(Container.DataItem, "ReasonForSelection")%>'></asp:TextBox>
                                        
                                        <asp:RequiredFieldValidator ID="RfvReas" runat="server" CssClass="validator" ControlToValidate="txtReason" ErrorMessage="Reason For Selection Required" ValidationGroup="proedit">*</asp:RequiredFieldValidator>
                                    </EditItemTemplate>
                                 
                                </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderText="Qty">

                                                            <%--  <FooterTemplate>
                                                                        <asp:TextBox ID="txtFQty" runat="server" CssClass="form-control" AutoPostBack="true"></asp:TextBox>
                                                                        <asp:RequiredFieldValidator ID="rfvtxtFQty" runat="server" CssClass="validator" ControlToValidate="txtFQty" ErrorMessage="Qty. is required" ValidationGroup="save" InitialValue=""></asp:RequiredFieldValidator>
                                                                    </FooterTemplate>--%>
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "Qty")%>
                                                                <asp:HiddenField ID="hfqty" runat="server" Value='<%# DataBinder.Eval(Container.DataItem, "Qty")%>'></asp:HiddenField>
                                                            </ItemTemplate>
                                                            <%--   <FooterTemplate>
                                                                    <asp:TextBox ID="txtQty" runat="server" Enabled="true" CssClass="form-control"></asp:TextBox>
                                                                </FooterTemplate>--%>
                                                            <%--<EditItemTemplate>
                                                                <asp:TextBox ID="txtEdtQty" runat="server" CssClass="form-control" Text='<%# DataBinder.Eval(Container.DataItem, "Qty")%>'></asp:TextBox>
                                                            </EditItemTemplate>--%>

                                                            <%--<ItemTemplate>
                                                                <asp:TextBox ID="txtQty" runat="server" CssClass="form-control" AutoPostBack="true" Text='<%# DataBinder.Eval(Container.DataItem, "Qty")%>'></asp:TextBox>
                                                                <asp:RequiredFieldValidator ID="rfvtxtQty" runat="server" ControlToValidate="txtQty" CssClass="validator" ErrorMessage="Qty. is required" ValidationGroup="request" InitialValue=""></asp:RequiredFieldValidator>
                                                                <%# DataBinder.Eval(Container.DataItem, "Qty")%>
                                                                <asp:HiddenField ID="hfqty" runat="server" Value='<%# DataBinder.Eval(Container.DataItem, "Qty")%>'></asp:HiddenField>

                                                            </ItemTemplate>--%>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderText="Unit Cost">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "UnitCost")%>
                                                            </ItemTemplate>
                                                            <EditItemTemplate>
                                                                <asp:TextBox ID="txtEdtUnitCost" runat="server" CssClass="form-control" Text='<%# DataBinder.Eval(Container.DataItem, "UnitCost")%>'></asp:TextBox>
                                                            </EditItemTemplate>
                                                            <%--   <FooterTemplate>
                                                                    <asp:TextBox ID="txtUnitCost" runat="server" CssClass="form-control"></asp:TextBox>
                                                                </FooterTemplate>--%>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderText="Total Cost">
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "TotalCost")%>
                                                            </ItemTemplate>
                                                            <EditItemTemplate>
                                                                <asp:TextBox ID="txtEdtTotalCost" runat="server" Enabled="false" CssClass="form-control" Text='<%# DataBinder.Eval(Container.DataItem, "TotalCost")%>'></asp:TextBox>
                                                            </EditItemTemplate>
                                                            <%--<FooterTemplate>
                                                                    <asp:TextBox ID="txtTotalCost" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                                </FooterTemplate>--%>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderText="Actions">
                                                            <EditItemTemplate>
                                                                <asp:LinkButton ID="lnkUpdate" runat="server" CommandName="Update" ValidationGroup="proedit" CssClass="btn btn-xs btn-default"><i class="fa fa-save"></i></asp:LinkButton>
                                                                <asp:LinkButton ID="lnkDelete" runat="server" CommandName="Delete" CssClass="btn btn-xs btn-default"><i class="fa fa-times"></i></asp:LinkButton>
                                                            </EditItemTemplate>
                                                            <%-- <FooterTemplate>
                                                                    <asp:LinkButton ID="lnkAddNew" runat="server" CommandName="AddNew" ValidationGroup="proadd" CssClass="btn btn-sm btn-success"><i class="fa fa-save"></i></asp:LinkButton>
                                                                </FooterTemplate>--%>
                                                            <ItemTemplate>
                                                                <asp:LinkButton ID="lnkEdit" runat="server" CommandName="Edit" CssClass="btn btn-xs btn-default"><i class="fa fa-pencil"></i></asp:LinkButton>
                                                                <asp:LinkButton ID="lnkDelete" runat="server" CommandName="Delete" CssClass="btn btn-xs btn-default" OnClientClick="javascript:return confirm('Are you sure you want to delete this entry?');"><i class="fa fa-times"></i></asp:LinkButton>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                    </Columns>
                                                    <PagerStyle CssClass="paginate_button active" HorizontalAlign="Center" />
                                                </asp:DataGrid>
                                            </div>
                                        </fieldset>
                                    </div>

                                    <div class="tab-pane" id="iss2">
                                        <fieldset>
                                            <div class="row">
                                                <section class="col col-6">
                                                    <label class="label">Attachments</label>
                                                    <asp:FileUpload ID="fuReciept" runat="server" />
                                                    <asp:Button ID="btnUpload" runat="server" Text="Upload" CssClass="btn btn-primary" OnClick="btnUpload_Click" />
                                                </section>
                                            </div>

                                            <asp:GridView ID="grvAttachments"
                                                runat="server" AutoGenerateColumns="False" DataKeyNames="Id"
                                                CssClass="table table-striped table-bordered table-hover" PagerStyle-CssClass="paginate_button active">
                                                <RowStyle CssClass="rowstyle" />
                                                <Columns>
                                                    <asp:BoundField DataField="FilePath" HeaderText="File Name" SortExpression="FilePath" />
                                                    <asp:TemplateField>
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="lnkDownload" Text="Download" CommandArgument='<%# Eval("FilePath") %>' runat="server" OnClick="DownloadFile"></asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField>
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="lnkDelete" Text="Delete" CommandArgument='<%# Eval("FilePath") %>' runat="server" OnClick="DeleteFile" />
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                </Columns>
                                                <FooterStyle CssClass="FooterStyle" />
                                                <HeaderStyle CssClass="headerstyle" />
                                                <PagerStyle CssClass="PagerStyle" />
                                                <RowStyle CssClass="rowstyle" />
                                            </asp:GridView>
                                        </fieldset>

                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <footer>
                    <asp:Button ID="btnSave" runat="server" Text="Request" OnClick="btnSave_Click" CausesValidation="true" ValidationGroup="save" CssClass="btn btn-primary"></asp:Button>
                    <%--<asp:Button ID="btnSearch" data-toggle="modal" href="#myModal" Text="Search" CssClass="btn btn-primary"></asp:Button>--%>
                    <a data-toggle="modal" runat="server" id="searchLink" href="#searchModal" class="btn btn-primary"><i class="fa fa-circle-arrow-up fa-lg"></i>Search</a>
                    <asp:Button ID="btnDelete" runat="server" CausesValidation="False" CssClass="btn btn-primary" Text="Delete" OnClick="btnDelete_Click"></asp:Button>
                    <cc1:ConfirmButtonExtender ID="btnDelete_ConfirmButtonExtender" runat="server"
                        ConfirmText="Are you sure you want to delete this record?" Enabled="True" TargetControlID="btnDelete">
                    </cc1:ConfirmButtonExtender>
                    <asp:Button ID="btnPrint" runat="server" Text="Print" CssClass="btn btn-primary" OnClientClick="javascript:Clickheretoprint('divprint')" Enabled="False"></asp:Button>
                     <asp:HiddenField ID="hfDetailId" runat="server" />
                    <asp:Button ID="btnCancel" runat="server" CssClass="btn btn-primary" OnClick="btnCancel_Click" Text="New" />
                    <asp:Button ID="btnClosepage" runat="server" Text="Close" data-dismiss="modal" CssClass="btn btn-primary" PostBackUrl="../Default.aspx"></asp:Button>
                </footer>
            </div>
        </div>
    </div>
    </div>

    <%--<cc1:ModalPopupExtender runat="server" DynamicServicePath="" PopupControlID="myModal"
        Enabled="True" TargetControlID="btnSearch" CancelControlID="btnCancelSearch" BackgroundCssClass="modalBackground"
        ID="pnlSearch_ModalPopupExtender">
    </cc1:ModalPopupExtender>--%>
    <%--<asp:Panel ID="pnlSearch" runat="server">--%>

    <%-- </asp:Panel>--%>

    <div class="modal fade" id="searchModal" tabindex="-1" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title" id="myModalLabel">Search Vehicle Requests</h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="txtSrchRequestNo">Request Number</label>
                                <asp:TextBox ID="txtSrchRequestNo" CssClass="form-control" ToolTip="Request No" runat="server"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="txtSrchRequestDate">Requested Date</label>
                                <label class="input" style="position: relative; display: block; font-weight: 400;">
                                    <i class="icon-append fa fa-calendar" style="position: absolute; top: 5px; width: 22px; height: 22px; font-size: 14px; line-height: 22px; text-align: center; right: 5px; padding-left: 3px; border-left-width: 1px; border-left-style: solid; color: #A2A2A2;"></i>
                                    <asp:TextBox ID="txtSrchRequestDate" CssClass="form-control datepicker"
                                        data-dateformat="mm/dd/yy" ToolTip="Request Date" runat="server"></asp:TextBox>
                                </label>
                            </div>
                        </div>
                    </div>
                    <div class="row" style="text-align: right;">
                        <div class="col-md-12">
                            <div class="form-group">
                                <asp:Button ID="btnFind" runat="server" OnClick="btnFind_Click" Text="Find" CssClass="btn btn-primary"></asp:Button>
                                <asp:Button ID="btnCancelSearch" Text="Close" runat="server" class="btn btn-primary"></asp:Button>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12">
                            <div class="form-group">
                                <div class="well well-sm well-primary">
                                    <asp:GridView ID="grvSoleVendorRequestList"
                                        runat="server" AutoGenerateColumns="False" DataKeyNames="Id"
                                        OnSelectedIndexChanged="grvSoleVendorRequestList_SelectedIndexChanged"
                                        AllowPaging="True" OnPageIndexChanging="grvSoleVendorRequestList_PageIndexChanging"
                                        CssClass="table table-striped table-bordered table-hover" PagerStyle-CssClass="paginate_button active" PageSize="5" OnRowDataBound="grvSoleVendorRequestList_RowDataBound">
                                        <RowStyle CssClass="rowstyle" />
                                        <Columns>
                                            <asp:BoundField DataField="RequestNo" HeaderText="Request No" SortExpression="RequestNo" />
                                            <asp:TemplateField HeaderText="Request Date">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblDate" runat="server" Text='<%# Eval("RequestDate", "{0:dd/MM/yyyy}")%>'></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:BoundField DataField="Supplier.SupplierName" HeaderText="Supplier" SortExpression="SupplierName" />
                                            <asp:BoundField DataField="CurrentStatus" HeaderText="Status" SortExpression="CurrentStatus" />
                                            <asp:CommandField ShowSelectButton="True" />
                                        </Columns>
                                        <FooterStyle CssClass="FooterStyle" />
                                        <HeaderStyle CssClass="headerstyle" />
                                        <PagerStyle CssClass="PagerStyle" />
                                        <RowStyle CssClass="rowstyle" />
                                    </asp:GridView>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>
    <div id="divprint" style="display: none; width: 942px;">
        <fieldset>
            <table style="width: 100%;">
                <tr>
                    <td style="width: 17%; text-align: left;">
                        <img src="../img/CHAI%20Logo.png" width="70" height="50" /></td>
                    <td style="font-size: large; text-align: center;">
                        <strong>CHAI ETHIOPIA
                            <br />
                            SOLE VENDOR REQUEST FORM</strong></td>
                </tr>
            </table>
            <table style="width: 100%">

                <tr>
                    <td align="right" style="">&nbsp;</td>
                    <td align="right" style="width: 244px" class="inbox-data-from">&nbsp;</td>
                    <td align="right" style="width: 271px">&nbsp;</td>
                    <td align="right" style="width: 389px">&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td style="width: 629px; height: 18px; padding-left: 20%;">
                        <strong>
                            <asp:Label ID="lblRequestNo" runat="server" Text="Request No.:"></asp:Label>
                        </strong>
                    </td>
                    <td style="width: 244px; height: 18px;">
                        <asp:Label ID="lblRequestNoresult" runat="server"></asp:Label>
                    </td>
                    <td style="width: 389px;">&nbsp;</td>
                    <td style="width: 389px;">&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td style="width: 629px; height: 18px; padding-left: 20%;">
                        <strong>
                            <asp:Label ID="lblRequestedDate" runat="server" Text="Requested Date:"></asp:Label>
                        </strong></td>
                    <td style="width: 244px; height: 18px;">
                        <asp:Label ID="lblRequestedDateresult" runat="server"></asp:Label>
                    </td>
                    <td align="right" style="width: 334px">&nbsp;</td>
                    <td align="right" style="width: 335px">&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td style="width: 629px; height: 18px; padding-left: 20%;">
                        <strong>
                            <asp:Label ID="lblRequester" runat="server" Text="Requester:"></asp:Label>
                        </strong></td>
                    <td style="width: 244px; height: 18px;">
                        <asp:Label ID="lblRequesterres" runat="server"></asp:Label>
                    </td>
                    <td style="width: 334px">&nbsp;</td>
                    <td style="width: 335px">&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td style="width: 629px; height: 18px; padding-left: 20%;">
                        <strong>
                            <asp:Label ID="lblEmployeeNo" runat="server" Text="Employee No:"></asp:Label>
                        </strong></td>
                    <td style="width: 244px; height: 18px;">
                        <asp:Label ID="lblEmpNoRes" runat="server"></asp:Label>
                    </td>
                    <td style="width: 334px; height: 18px;">&nbsp;</td>
                    <td style="width: 335px; height: 18px;">&nbsp;</td>
                    <td style="height: 18px">&nbsp;</td>
                </tr>
                <tr>
                    <td style="width: 682px; height: 18px;">&nbsp;</td>
                    <td style="width: 244px; height: 18px;">&nbsp;</td>
                    <td style="width: 334px; height: 18px;">&nbsp;</td>
                    <td style="width: 335px; height: 18px;">&nbsp;</td>
                    <td style="height: 18px">&nbsp;</td>
                </tr>
                <tr>
                    <td style="width: 629px; height: 18px;">
                        <strong>
                            <asp:Label ID="lblContactPersonNumber" runat="server" Text="Contact Person & Number:"></asp:Label>
                        </strong>
                    </td>
                    <td style="width: 244px; height: 18px;">
                        <asp:Label ID="lblContactPersonNumberRes" runat="server"></asp:Label>
                    </td>
                    <td style="width: 334px; height: 18px;">
                        <strong>
                            <asp:Label ID="lblProposedPurchasedprice" runat="server" Text="Proposed Purchased price:"></asp:Label>
                        </strong></td>
                    <td style="width: 335px; height: 18px;">
                        <asp:Label ID="lblProposedPurchasedpriceres" runat="server"></asp:Label>
                    </td>
                    <td style="height: 18px">&nbsp;</td>
                </tr>
                <tr>
                    <td style="width: 682px; height: 18px;">
                        <strong>
                            <asp:Label ID="lblProposedSupplier" runat="server" Text="Proposed Supplier:"></asp:Label>
                        </strong>
                    </td>
                    <td style="width: 244px; height: 18px;">
                        <asp:Label ID="lblProposedSupplierresp" runat="server"></asp:Label>
                    </td>
                    <td style="width: 334px; height: 18px;">
                        <strong>
                            <asp:Label ID="lblRequestedSupplier" runat="server" Text="Requested Supplier"></asp:Label>
                        </strong>
                    </td>
                    <td style="width: 335px; height: 18px;">
                        <asp:Label ID="lblRequestedSupplierres" runat="server"></asp:Label>
                    </td>
                    <td style="height: 18px">&nbsp;</td>
                </tr>
                <tr>
                    <td style="width: 682px; height: 18px;">
                        <strong>
                            <asp:Label ID="lblSoleSourceJustificationPreparedBy" runat="server" Text="Sole Source Justification PreparedBy:"></asp:Label>
                        </strong>
                    </td>
                    <td style="width: 244px; height: 18px;">
                        <asp:Label ID="lblSoleSourceJustificationPreparedByresp" runat="server"></asp:Label>
                    </td>
                    <td style="width: 334px; height: 18px;">
                        <strong>
                            <asp:Label ID="lblSoleVendorJustificationType" runat="server" Text="Sole Vendor JustificationType"></asp:Label>
                        </strong>
                    </td>
                    <td style="width: 335px; height: 18px;">
                        <asp:Label ID="lblSoleVendorJustificationTyperes" runat="server"></asp:Label>
                    </td>
                    <td style="height: 18px">&nbsp;</td>
                </tr>
                <tr>
                    <td style="width: 334px; height: 18px;">
                        <strong>
                            <asp:Label ID="lblApprovalStatusp" runat="server" Text="Approval Status"></asp:Label>
                        </strong>
                    </td>
                    <td style="width: 244px; height: 18px;">
                        <asp:Label ID="lblapprovalstatusres" runat="server"></asp:Label>
                    </td>
                    <td style="height: 18px">&nbsp;</td>
                </tr>
            </table>
            <br />
            <br />
            <asp:GridView ID="grvStatuses" CellPadding="5" CellSpacing="3"
                runat="server" AutoGenerateColumns="False" DataKeyNames="Id" OnRowDataBound="grvStatuses_RowDataBound"
                CssClass="table table-striped table-bordered table-hover">
                <RowStyle CssClass="rowstyle" />
                <Columns>
                    <asp:TemplateField HeaderText="Date">
                        <ItemTemplate>
                            <asp:Label ID="lblDate" runat="server" Text='<%# Eval("ApprovalDate", "{0:dd/MM/yyyy}")%>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:BoundField HeaderText="Approver" />
                    <asp:BoundField DataField="AssignedBy" HeaderText="Assignee Approver" SortExpression="AssignedBy" />
                    <asp:BoundField HeaderText="Approval Status" DataField="ApprovalStatus" />
                </Columns>
                <FooterStyle CssClass="FooterStyle" />
                <HeaderStyle CssClass="headerstyle" />
                <PagerStyle CssClass="PagerStyle" />
                <RowStyle CssClass="rowstyle" />
            </asp:GridView>
        </fieldset>
    </div>
    <asp:Panel ID="pnlWarning" Visible="false" Style="position: absolute; top: 55px; left: 108px;" runat="server">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                </div>
                <div class="modal-body no-padding">
                    <div class="jarviswidget" data-widget-editbutton="false" data-widget-custombutton="false">
                        <div>
                            <div class="jarviswidget-editbox"></div>
                            <div class="widget-body no-padding">
                                <div class="smart-form">
                                    <div class="alert alert-block alert-danger">
                                        <h4 class="alert-heading">Warning</h4>
                                        <p>
                                            The current Request has no Approval Settings defined. Please contact your administrator
                                        </p>
                                    </div>
                                    <footer>
                                        <asp:Button ID="btnCancelPopup" runat="server" Text="Cancel" CssClass="btn btn-primary" OnClick="btnCancelPopup_Click"></asp:Button>
                                    </footer>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- /.modal-content -->
    </asp:Panel>

</asp:Content>

﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Chai.WorkflowManagment.CoreDomain.Requests;
using Chai.WorkflowManagment.CoreDomain.Setting;
using Chai.WorkflowManagment.Enums;
using Chai.WorkflowManagment.Modules.Approval.Views;
using Chai.WorkflowManagment.Shared;
using Chai.WorkflowManagment.Shared.MailSender;
using log4net;
using log4net.Config;
using Microsoft.Practices.ObjectBuilder;
using System.IO;
using Chai.WorkflowManagment.CoreDomain.Users;

namespace Chai.WorkflowManagment.Modules.Approval.Views
{
    public partial class frmOperationalControlApproval : POCBasePage, IOperationalControlApprovalView
    {
        private OperationalControlApprovalPresenter _presenter;
        private static readonly ILog Log = LogManager.GetLogger("AuditTrailLog");
        private int reqID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!this.IsPostBack)
            {
                this._presenter.OnViewInitialized();
                XmlConfigurator.Configure();
                PopProgressStatus();
                BindSearchOperationalControlRequestGrid();
            }
            this._presenter.OnViewLoaded();
            if (_presenter.CurrentOperationalControlRequest != null)
            {
                if (_presenter.CurrentOperationalControlRequest.Id != 0)
                {
                    PrintTransaction();
                }
            }
        }
        [CreateNew]
        public OperationalControlApprovalPresenter Presenter
        {
            get
            {
                return this._presenter;
            }
            set
            {
                if (value == null)
                    throw new ArgumentNullException("value");

                this._presenter = value;
                this._presenter.View = this;
            }
        }

        public override string PageID
        {
            get
            {
                return "{00397B85-1427-4EE2-94D7-7A1E8650A568}";
            }
        }

        #region Field Getters
        public int GetOperationalControlRequestId
        {
            get
            {
                if (grvOperationalControlRequestList.SelectedDataKey != null)
                {
                    return Convert.ToInt32(grvOperationalControlRequestList.SelectedDataKey.Value);
                }
                else if (Convert.ToInt32(Session["ReqID"]) != 0)
                {
                    return Convert.ToInt32(Session["ReqID"]);
                }
                else
                {
                    return 0;
                }
            }
        }
        public int GetAccountId
        {
            get { return 0; }
        }
        #endregion
        private void PopApprovalStatus()
        {
            ddlApprovalStatus.Items.Clear();
            ddlApprovalStatus.Items.Add(new ListItem("Select Status", "0"));

            string[] s = Enum.GetNames(typeof(ApprovalStatus));

            for (int i = 0; i < s.Length; i++)
            {
                if (GetWillStatus().Substring(0, 3) == s[i].Substring(0, 3))
                {
                    ddlApprovalStatus.Items.Add(new ListItem(s[i].Replace('_', ' '), s[i].Replace('_', ' ')));
                }

            }

            ddlApprovalStatus.Items.Add(new ListItem(ApprovalStatus.Rejected.ToString().Replace('_', ' '), ApprovalStatus.Rejected.ToString().Replace('_', ' ')));

        }
        private string GetWillStatus()
        {
            ApprovalSetting AS = _presenter.GetApprovalSettingforProcess(RequestType.OperationalControl_Request.ToString().Replace('_', ' ').ToString(), 0);
            string will = "";
            foreach (ApprovalLevel AL in AS.ApprovalLevels)
            {
                if (AL.EmployeePosition.PositionName == "Superviser/Line Manager" || AL.EmployeePosition.PositionName == "Program Manager" && _presenter.CurrentOperationalControlRequest.CurrentLevel == 1)
                {
                    will = "Approve";
                    break;

                }
                /*else if (_presenter.GetUser(_presenter.CurrentOperationalControlRequest.CurrentApprover).EmployeePosition.PositionName == AL.EmployeePosition.PositionName)
                {
                    will = AL.Will;
                }*/
                else
                {
                    try
                    {
                        if (_presenter.GetUser(_presenter.CurrentOperationalControlRequest.CurrentApprover).EmployeePosition.PositionName == AL.EmployeePosition.PositionName && AL.WorkflowLevel == _presenter.CurrentOperationalControlRequest.CurrentLevel)
                        {
                            will = AL.Will;
                            break;
                        }
                    }
                    catch
                    {
                        if (_presenter.CurrentOperationalControlRequest.CurrentApproverPosition == AL.EmployeePosition.Id && AL.WorkflowLevel == _presenter.CurrentOperationalControlRequest.CurrentLevel)
                        {
                            will = AL.Will;
                            break;
                        }
                    }
                }

            }
            return will;
        }
        private void PopProgressStatus()
        {
            string[] s = Enum.GetNames(typeof(ProgressStatus));

            for (int i = 0; i < s.Length; i++)
            {
                ddlSrchProgressStatus.Items.Add(new ListItem(s[i].Replace('_', ' '), s[i].Replace('_', ' ')));
                ddlSrchProgressStatus.DataBind();
            }
        }
        private void BindSearchOperationalControlRequestGrid()
        {
            grvOperationalControlRequestList.DataSource = _presenter.ListOperationalControlRequests(txtSrchRequestNo.Text, txtSrchRequestDate.Text, ddlSrchProgressStatus.SelectedValue);
            grvOperationalControlRequestList.DataBind();
        }
        private void BindOperationalControlRequestStatus()
        {
            foreach (OperationalControlRequestStatus OCRS in _presenter.CurrentOperationalControlRequest.OperationalControlRequestStatuses)
            {

                if (_presenter.CurrentOperationalControlRequest.CurrentLevel == _presenter.CurrentOperationalControlRequest.OperationalControlRequestStatuses.Count && _presenter.CurrentOperationalControlRequest.ProgressStatus == ProgressStatus.Completed.ToString())
                {
                    btnPrint.Enabled = true;

                    btnApprove.Enabled = false;
                }
                else
                    btnPrint.Enabled = false;

            }
        }
        private void BindProject(DropDownList ddlProject)
        {
            ddlProject.DataSource = _presenter.ListProjects();
            ddlProject.DataValueField = "Id";
            ddlProject.DataTextField = "ProjectCode";
            ddlProject.DataBind();
        }
        private void BindGrant(DropDownList ddlGrant, int ProjectId)
        {
            ddlGrant.DataSource = _presenter.GetGrantbyprojectId(ProjectId);
            ddlGrant.DataValueField = "Id";
            ddlGrant.DataTextField = "GrantCode";
            ddlGrant.DataBind();
        }
        private void BindAccountDescription(DropDownList ddlAccountDescription)
        {
            ddlAccountDescription.DataSource = _presenter.ListItemAccounts();
            ddlAccountDescription.DataValueField = "Id";
            ddlAccountDescription.DataTextField = "AccountName";
            ddlAccountDescription.DataBind();
        }
        private void ShowPrint()
        {
            if (_presenter.CurrentOperationalControlRequest.CurrentLevel == _presenter.CurrentOperationalControlRequest.OperationalControlRequestStatuses.Count && _presenter.CurrentOperationalControlRequest.ProgressStatus == ProgressStatus.Completed.ToString())
            {
                btnPrint.Enabled = true;
            }
        }
        private void SendEmail(OperationalControlRequestStatus OCRS)
        {
            if (OCRS.Approver != 0)
            {
                if (_presenter.GetUser(OCRS.Approver).IsAssignedJob != true)
                {
                    EmailSender.Send(_presenter.GetUser(OCRS.Approver).Email, "Bank Payment Approval", (_presenter.CurrentOperationalControlRequest.AppUser.FullName).ToUpper() + " Requests for payment");
                }
                else
                {
                    EmailSender.Send(_presenter.GetUser(_presenter.GetAssignedJobbycurrentuser(OCRS.Approver).AssignedTo).Email, "Bank Payment Approval", (_presenter.CurrentOperationalControlRequest.AppUser.FullName).ToUpper() + " Requests for payment");
                }
            }
            else
            {
                foreach (AppUser Payer in _presenter.GetAppUsersByEmployeePosition(OCRS.ApproverPosition))
                {
                    if (Payer.IsAssignedJob != true)
                    {
                        EmailSender.Send(Payer.Email, "Bank Payment Approval", (_presenter.CurrentOperationalControlRequest.AppUser.FullName).ToUpper() + " Requests for Bank Payment with Request No. " + (_presenter.CurrentOperationalControlRequest.RequestNo).ToUpper());
                    }
                    else
                    {
                        EmailSender.Send(_presenter.GetUser(_presenter.GetAssignedJobbycurrentuser(Payer.Id).AssignedTo).Email, "Bank Payment Approval", (_presenter.CurrentOperationalControlRequest.AppUser.FullName).ToUpper() + " Requests for Bank Payment with Request No. '" + (_presenter.CurrentOperationalControlRequest.RequestNo).ToUpper());
                    }
                }
            }
        }
        private void SendEmailRejected(OperationalControlRequestStatus OCRS)
        {
            EmailSender.Send(_presenter.GetUser(_presenter.CurrentOperationalControlRequest.AppUser.Id).Email, "Bank Payment Request Rejection", "Your Bank Payment Request with Request No. - '" + (_presenter.CurrentOperationalControlRequest.RequestNo.ToString()).ToUpper() + " was Rejected by " + _presenter.CurrentUser().FullName + " for this reason - '" + (OCRS.RejectedReason).ToUpper() + "'");

            if (OCRS.WorkflowLevel > 1)
            {
                for (int i = 0; i + 1 < OCRS.WorkflowLevel; i++)
                {
                    EmailSender.Send(_presenter.GetUser(_presenter.CurrentOperationalControlRequest.OperationalControlRequestStatuses[i].Approver).Email, "Bank Payment Request Rejection", "Bank Payment Request with Request No. - '" + (_presenter.CurrentOperationalControlRequest.RequestNo.ToString()).ToUpper() + "' made by " + (_presenter.GetUser(_presenter.CurrentOperationalControlRequest.AppUser.Id).FullName).ToUpper() + " was Rejected by " + _presenter.CurrentUser().FullName + " for this reason - '" + (OCRS.RejectedReason).ToUpper() + "'");
                }
            }
        }
        private void GetNextApprover()
        {
            foreach (OperationalControlRequestStatus OCRS in _presenter.CurrentOperationalControlRequest.OperationalControlRequestStatuses)
            {
                if (OCRS.ApprovalStatus == null)
                {
                    if (OCRS.Approver == 0)
                    {
                        //This is to handle multiple Accountants responding to this request
                        //SendEmailToFinanceOfficers;
                        _presenter.CurrentOperationalControlRequest.CurrentApproverPosition = OCRS.ApproverPosition;
                    }
                    else
                    {
                        _presenter.CurrentOperationalControlRequest.CurrentApproverPosition = 0;
                    }
                    _presenter.CurrentOperationalControlRequest.CurrentApprover = OCRS.Approver;
                    _presenter.CurrentOperationalControlRequest.CurrentLevel = OCRS.WorkflowLevel;
                    _presenter.CurrentOperationalControlRequest.CurrentStatus = OCRS.ApprovalStatus;
                    _presenter.CurrentOperationalControlRequest.ProgressStatus = ProgressStatus.InProgress.ToString();
                    SendEmail(OCRS);
                    break;
                }
            }
        }
        private void SaveOperationalControlRequestStatus()
        {
            foreach (OperationalControlRequestStatus OCRS in _presenter.CurrentOperationalControlRequest.OperationalControlRequestStatuses)
            {
                if ((OCRS.Approver == _presenter.CurrentUser().Id || (OCRS.ApproverPosition == _presenter.CurrentUser().EmployeePosition.Id) || _presenter.CurrentUser().Id == (_presenter.GetAssignedJobbycurrentuser(OCRS.Approver) != null ? _presenter.GetAssignedJobbycurrentuser(OCRS.Approver).AssignedTo : 0)) && OCRS.WorkflowLevel == _presenter.CurrentOperationalControlRequest.CurrentLevel)
                {
                    OCRS.ApprovalStatus = ddlApprovalStatus.SelectedValue;
                    OCRS.RejectedReason = txtRejectedReason.Text;
                    OCRS.Account = _presenter.GetAccount(_presenter.CurrentOperationalControlRequest.Account.Id);
                    OCRS.Date = DateTime.Now;
                    OCRS.AssignedBy = _presenter.GetAssignedJobbycurrentuser(OCRS.Approver) != null ? _presenter.GetAssignedJobbycurrentuser(OCRS.Approver).AppUser.FullName : "";
                    if (OCRS.ApprovalStatus != ApprovalStatus.Rejected.ToString())
                    {
                        if (_presenter.CurrentOperationalControlRequest.CurrentLevel == _presenter.CurrentOperationalControlRequest.OperationalControlRequestStatuses.Count)
                        {
                            _presenter.CurrentOperationalControlRequest.ProgressStatus = ProgressStatus.Completed.ToString();
                        }
                        GetNextApprover();
                        OCRS.Approver = _presenter.CurrentUser().Id;
                        Log.Info(_presenter.GetUser(OCRS.Approver).FullName + " has " + OCRS.ApprovalStatus + " Bank Payment Request made by " + _presenter.CurrentOperationalControlRequest.AppUser.FullName);
                    }
                    else
                    {
                        _presenter.CurrentOperationalControlRequest.ProgressStatus = ProgressStatus.Completed.ToString();
                        OCRS.Approver = _presenter.CurrentUser().Id;
                        SendEmailRejected(OCRS);
                        Log.Info(_presenter.GetUser(OCRS.Approver).FullName + " has " + OCRS.ApprovalStatus + " Bank Payment Request made by " + _presenter.CurrentOperationalControlRequest.AppUser.FullName);
                    }
                    break;
                }

            }
        }
        protected void grvOperationalControlRequestList_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName != "Page")
            {
                reqID = (int)grvOperationalControlRequestList.DataKeys[Convert.ToInt32(e.CommandArgument)].Value;
                Session["ReqID"] = reqID;
                _presenter.CurrentOperationalControlRequest = _presenter.GetOperationalControlRequest(reqID);
                if (e.CommandName == "ViewItem")
                {
                    dgOperationalControlRequestDetail.DataSource = _presenter.CurrentOperationalControlRequest.OperationalControlRequestDetails;
                    dgOperationalControlRequestDetail.DataBind();
                    grvOperationalControlStatuses.DataSource = _presenter.CurrentOperationalControlRequest.OperationalControlRequestStatuses;
                    grvOperationalControlStatuses.DataBind();
                    grvdetailAttachments.DataSource = _presenter.CurrentOperationalControlRequest.OCRAttachments;
                    grvdetailAttachments.DataBind();

                    //If this Bank Payment request was initiated from Travel Advance, show the details of the Travel Advance here
                    if (_presenter.CurrentOperationalControlRequest.TravelAdvanceId > 0)
                    {
                        lblTravelDetail.Visible = true;
                        dgTravelAdvanceRequestDetail.DataSource = _presenter.GetTravelAdvanceRequest(_presenter.CurrentOperationalControlRequest.TravelAdvanceId).TravelAdvanceRequestDetails;
                        dgTravelAdvanceRequestDetail.DataBind();
                        grvTravelAdvanceStatuses.DataSource = _presenter.GetTravelAdvanceRequest(_presenter.CurrentOperationalControlRequest.TravelAdvanceId).TravelAdvanceRequestStatuses;
                        grvTravelAdvanceStatuses.DataBind();
                    }
                    else
                    {
                        dgTravelAdvanceRequestDetail.DataSource = null;
                        dgTravelAdvanceRequestDetail.DataBind();
                        grvTravelAdvanceCosts.DataSource = null;
                        grvTravelAdvanceCosts.DataBind();
                        grvTravelAdvanceStatuses.DataSource = null;
                        grvTravelAdvanceStatuses.DataBind();
                        lblTravelDetail.Visible = false;
                    }

                    ScriptManager.RegisterStartupScript(this, GetType(), "showDetailModal", "showDetailModal();", true);
                }
            }

        }
        protected void dgTravelAdvanceRequestDetail_SelectedIndexChanged(object sender, EventArgs e)
        {
            int recordId = (int)dgTravelAdvanceRequestDetail.DataKeys[dgTravelAdvanceRequestDetail.SelectedIndex];
            if (_presenter.GetTravelAdvanceRequest(_presenter.CurrentOperationalControlRequest.TravelAdvanceId) != null)
            {
                grvTravelAdvanceCosts.DataSource = _presenter.GetTravelAdvanceRequest(_presenter.CurrentOperationalControlRequest.TravelAdvanceId).GetTravelAdvanceRequestDetail(recordId).TravelAdvanceCosts;
                grvTravelAdvanceCosts.DataBind();
            }

            ScriptManager.RegisterStartupScript(this, GetType(), "showDetailModal", "showDetailModal();", true);
        }
        protected void DownloadFile(object sender, EventArgs e)
        {
            string filePath = (sender as LinkButton).CommandArgument;
            Response.ContentType = ContentType;
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Path.GetFileName(filePath));
            Response.WriteFile(filePath);
            Response.End();
        }
        protected void grvOperationalControlRequestList_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            Button btnStatus = e.Row.FindControl("btnStatus") as Button;
            OperationalControlRequest CSR = e.Row.DataItem as OperationalControlRequest;
            if (CSR != null)
            {
                if (e.Row.RowType == DataControlRowType.DataRow)
                {

                    if (CSR.ProgressStatus == ProgressStatus.InProgress.ToString())
                    {
                        btnStatus.BackColor = System.Drawing.ColorTranslator.FromHtml("#FFFF6C");

                    }
                    else if (CSR.ProgressStatus == ProgressStatus.Completed.ToString())
                    {
                        btnStatus.BackColor = System.Drawing.ColorTranslator.FromHtml("#FF7251");

                    }
                }
            }
        }
        protected void grvOperationalControlRequestList_SelectedIndexChanged(object sender, EventArgs e)
        {
            _presenter.OnViewLoaded();
            if (_presenter.CurrentOperationalControlRequest.ProgressStatus == ProgressStatus.Completed.ToString())
            {
                PrintTransaction();
            }

            PopApprovalStatus();
            btnApprove.Enabled = true;
            ShowPrint();
            BindOperationalControlRequestStatus();
            txtRejectedReason.Visible = false;
            rfvRejectedReason.Enabled = false;
            ScriptManager.RegisterStartupScript(this, GetType(), "showApprovalModal", "showApprovalModal();", true);
        }
        protected void grvOperationalControlRequestList_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            grvOperationalControlRequestList.PageIndex = e.NewPageIndex;
            btnFind_Click(sender, e);
        }
        protected void btnFind_Click(object sender, EventArgs e)
        {
            BindSearchOperationalControlRequestGrid();
        }
        protected void btnApprove_Click(object sender, EventArgs e)
        {
            try
            {
                if (_presenter.CurrentOperationalControlRequest.ProgressStatus != ProgressStatus.Completed.ToString())
                {
                    SaveOperationalControlRequestStatus();

                    _presenter.SaveOrUpdateOperationalControlRequest(_presenter.CurrentOperationalControlRequest);
                    ShowPrint();
                    if (ddlApprovalStatus.SelectedValue != "Rejected")
                    {
                        Master.ShowMessage(new AppMessage("Bank Payment Approval Processed", Chai.WorkflowManagment.Enums.RMessageType.Info));
                    }
                    else
                    {
                        Master.ShowMessage(new AppMessage("Bank Payment Approval Rejected", Chai.WorkflowManagment.Enums.RMessageType.Info));
                    }
                    btnApprove.Enabled = false;
                    BindSearchOperationalControlRequestGrid();
                    ScriptManager.RegisterStartupScript(this, GetType(), "showApprovalModal", "showApprovalModal();", true);
                    PrintTransaction();
                }
            }
            catch (Exception ex)
            {

            }
        }
        private void PrintTransaction()
        {
            lblRequesterResult.Text = _presenter.CurrentOperationalControlRequest.AppUser.FullName;
            lblRequestedDateResult.Text = _presenter.CurrentOperationalControlRequest.RequestDate.Value.ToShortDateString();
            lblChaiBankResult.Text = _presenter.CurrentOperationalControlRequest.Account.Name;
            lblChaiBankAccResult.Text = _presenter.CurrentOperationalControlRequest.Account.AccountNo;
            lblDescriptionResult.Text = _presenter.CurrentOperationalControlRequest.Description;
            if (_presenter.CurrentOperationalControlRequest.Beneficiary != null)
            {
                lblBankNameResult.Text = _presenter.CurrentOperationalControlRequest.Beneficiary.BankName;
                lblBeneficiaryNameResult.Text = _presenter.CurrentOperationalControlRequest.Beneficiary.BeneficiaryName;
                lblBankAccountNoResult.Text = _presenter.CurrentOperationalControlRequest.Beneficiary.AccountNumber;
            }
            lblVoucherNoResult.Text = _presenter.CurrentOperationalControlRequest.VoucherNo.ToString();
            lblTotalAmountResult.Text = _presenter.CurrentOperationalControlRequest.TotalAmount.ToString();
            lblApprovalStatusResult.Text = _presenter.CurrentOperationalControlRequest.ProgressStatus.ToString();

            grvDetails.DataSource = _presenter.CurrentOperationalControlRequest.OperationalControlRequestDetails;
            grvDetails.DataBind();

            grvStatuses.DataSource = _presenter.CurrentOperationalControlRequest.OperationalControlRequestStatuses;
            grvStatuses.DataBind();

            if (_presenter.CurrentOperationalControlRequest.TravelAdvanceId > 0)
            {
                lblProjectCodeResult.Text = _presenter.GetTravelAdvanceRequest(_presenter.CurrentOperationalControlRequest.TravelAdvanceId).Project.ProjectCode;
                lblGrantCodeResult.Text = _presenter.GetTravelAdvanceRequest(_presenter.CurrentOperationalControlRequest.TravelAdvanceId).Grant.GrantCode;

                pnlTravelDetail.Visible = true;
                pnlPaymentDetail.Visible = false;
                lblTravelDetails.Visible = true;
                grvTravelDetails.DataSource = _presenter.GetTravelAdvanceRequest(_presenter.CurrentOperationalControlRequest.TravelAdvanceId).TravelAdvanceRequestDetails;
                grvTravelDetails.DataBind();

                grvTravelStatuses.DataSource = _presenter.GetTravelAdvanceRequest(_presenter.CurrentOperationalControlRequest.TravelAdvanceId).TravelAdvanceRequestStatuses;
                grvTravelStatuses.DataBind();

                IList<TravelAdvanceCost> allCosts = new List<TravelAdvanceCost>();

                foreach (TravelAdvanceRequestDetail detail in _presenter.GetTravelAdvanceRequest(_presenter.CurrentOperationalControlRequest.TravelAdvanceId).TravelAdvanceRequestDetails)
                {
                    foreach (TravelAdvanceCost cost in detail.TravelAdvanceCosts)
                    {
                        allCosts.Add(cost);
                    }
                }
                grvTravelCosts.DataSource = allCosts;
                grvTravelCosts.DataBind();
            }

            if (_presenter.CurrentOperationalControlRequest.PaymentId > 0)
            {
                pnlPaymentDetail.Visible = true;
                pnlTravelDetail.Visible = false;
                lblPaymentDetail.Visible = true;
                grvPaymentDetails.DataSource = _presenter.GetCashPaymentRequest(_presenter.CurrentOperationalControlRequest.PaymentId).CashPaymentRequestDetails;
                grvPaymentDetails.DataBind();

                grvPaymentStatuses.DataSource = _presenter.GetCashPaymentRequest(_presenter.CurrentOperationalControlRequest.PaymentId).CashPaymentRequestStatuses;
                grvPaymentStatuses.DataBind();
            }

        }
        protected void grvTravelStatuses_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (_presenter.GetTravelAdvanceRequest(_presenter.CurrentOperationalControlRequest.TravelAdvanceId).TravelAdvanceRequestStatuses != null)
            {
                if (e.Row.RowType == DataControlRowType.DataRow)
                {
                    if (_presenter.GetTravelAdvanceRequest(_presenter.CurrentOperationalControlRequest.TravelAdvanceId).TravelAdvanceRequestStatuses[e.Row.RowIndex].Approver > 0)
                        e.Row.Cells[1].Text = _presenter.GetUser(_presenter.GetTravelAdvanceRequest(_presenter.CurrentOperationalControlRequest.TravelAdvanceId).TravelAdvanceRequestStatuses[e.Row.RowIndex].Approver).FullName;
                }
            }
        }
        protected void grvPaymentStatuses_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (_presenter.GetCashPaymentRequest(_presenter.CurrentOperationalControlRequest.PaymentId).CashPaymentRequestStatuses != null)
            {
                if (e.Row.RowType == DataControlRowType.DataRow)
                {
                    if (_presenter.GetCashPaymentRequest(_presenter.CurrentOperationalControlRequest.PaymentId).CashPaymentRequestStatuses[e.Row.RowIndex].Approver > 0)
                        e.Row.Cells[1].Text = _presenter.GetUser(_presenter.GetCashPaymentRequest(_presenter.CurrentOperationalControlRequest.PaymentId).CashPaymentRequestStatuses[e.Row.RowIndex].Approver).FullName;
                }
            }
        }
        protected void grvStatuses_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (_presenter.CurrentOperationalControlRequest.OperationalControlRequestStatuses != null)
            {
                if (e.Row.RowType == DataControlRowType.DataRow)
                {
                    if (_presenter.CurrentOperationalControlRequest.OperationalControlRequestStatuses[e.Row.RowIndex].Approver > 0)
                        e.Row.Cells[1].Text = _presenter.GetUser(_presenter.CurrentOperationalControlRequest.OperationalControlRequestStatuses[e.Row.RowIndex].Approver).FullName;
                }
            }
        }
        protected void ddlApprovalStatus_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlApprovalStatus.SelectedValue == "Rejected")
            {
                lblRejectedReason.Visible = true;
                txtRejectedReason.Visible = true;
                rfvRejectedReason.Enabled = true;
            }
            else
            {
                lblRejectedReason.Visible = false;
                txtRejectedReason.Visible = false;
                rfvRejectedReason.Enabled = false;
            }
            ScriptManager.RegisterStartupScript(this, GetType(), "showApprovalModal", "showApprovalModal();", true);
        }
        protected void dgOperationalControlRequestDetail_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Footer)
            {
            }
            else
            {
                if (_presenter.CurrentOperationalControlRequest.OperationalControlRequestDetails != null)
                {
                    DropDownList ddlProject = e.Item.FindControl("ddlEdtProject") as DropDownList;
                    if (ddlProject != null)
                    {
                        BindProject(ddlProject);
                        if (_presenter.CurrentOperationalControlRequest.OperationalControlRequestDetails[e.Item.DataSetIndex].Project.Id != 0)
                        {
                            ListItem liI = ddlProject.Items.FindByValue(_presenter.CurrentOperationalControlRequest.OperationalControlRequestDetails[e.Item.DataSetIndex].Project.Id.ToString());
                            if (liI != null)
                                liI.Selected = true;
                        }
                    }
                    DropDownList ddlAccountDescription = e.Item.FindControl("ddlEdtAccountDescription") as DropDownList;
                    if (ddlAccountDescription != null)
                    {
                        BindAccountDescription(ddlAccountDescription);
                        if (_presenter.CurrentOperationalControlRequest.OperationalControlRequestDetails[e.Item.DataSetIndex].ItemAccount.Id != 0)
                        {
                            ListItem liI = ddlAccountDescription.Items.FindByValue(_presenter.CurrentOperationalControlRequest.OperationalControlRequestDetails[e.Item.DataSetIndex].ItemAccount.Id.ToString());
                            if (liI != null)
                                liI.Selected = true;
                        }
                    }
                    DropDownList ddlEdtGrant = e.Item.FindControl("ddlEdtGrant") as DropDownList;
                    if (ddlEdtGrant != null)
                    {
                        BindGrant(ddlEdtGrant, Convert.ToInt32(ddlProject.SelectedValue));
                        if (_presenter.CurrentOperationalControlRequest.OperationalControlRequestDetails[e.Item.DataSetIndex].Grant.Id != null)
                        {
                            ListItem liI = ddlEdtGrant.Items.FindByValue(_presenter.CurrentOperationalControlRequest.OperationalControlRequestDetails[e.Item.DataSetIndex].Grant.Id.ToString());
                            if (liI != null)
                                liI.Selected = true;
                        }

                    }
                }
            }
        }
        protected void dgOperationalControlRequestDetail_EditCommand(object source, DataGridCommandEventArgs e)
        {
            this.dgOperationalControlRequestDetail.EditItemIndex = e.Item.ItemIndex;
            dgOperationalControlRequestDetail.DataSource = _presenter.CurrentOperationalControlRequest.OperationalControlRequestDetails;
            dgOperationalControlRequestDetail.DataBind();
            ScriptManager.RegisterStartupScript(this, GetType(), "showDetailModal", "showDetailModal();", true);
        }
        protected void dgOperationalControlRequestDetail_UpdateCommand(object source, DataGridCommandEventArgs e)
        {
            int CPRDId = (int)dgOperationalControlRequestDetail.DataKeys[e.Item.ItemIndex];
            OperationalControlRequestDetail cprd;

            if (CPRDId > 0)
                cprd = _presenter.CurrentOperationalControlRequest.GetOperationalControlRequestDetail(CPRDId);
            else
                cprd = (OperationalControlRequestDetail)_presenter.CurrentOperationalControlRequest.OperationalControlRequestDetails[e.Item.ItemIndex];

            try
            {
                cprd.OperationalControlRequest = _presenter.CurrentOperationalControlRequest;
                TextBox txtEdtAccountCode = e.Item.FindControl("txtEdtAccountCode") as TextBox;
                cprd.AccountCode = txtEdtAccountCode.Text;
                DropDownList ddlAccountDescription = e.Item.FindControl("ddlEdtAccountDescription") as DropDownList;
                cprd.ItemAccount = _presenter.GetItemAccount(Convert.ToInt32(ddlAccountDescription.SelectedValue));
                DropDownList ddlProject = e.Item.FindControl("ddlEdtProject") as DropDownList;
                cprd.Project = _presenter.GetProject(Convert.ToInt32(ddlProject.SelectedValue));
                DropDownList ddlGrant = e.Item.FindControl("ddlEdtGrant") as DropDownList;
                cprd.Grant = _presenter.GetGrant(int.Parse(ddlGrant.SelectedValue));

                dgOperationalControlRequestDetail.EditItemIndex = -1;
                dgOperationalControlRequestDetail.DataSource = _presenter.CurrentOperationalControlRequest.OperationalControlRequestDetails;
                dgOperationalControlRequestDetail.DataBind();
                ScriptManager.RegisterStartupScript(this, GetType(), "showDetailModal", "showDetailModal();", true);
                Master.ShowMessage(new AppMessage("Bank Payment Detail Successfully Updated", Chai.WorkflowManagment.Enums.RMessageType.Info));
            }
            catch (Exception ex)
            {
                Master.ShowMessage(new AppMessage("Error: Unable to Update Bank Payment Detail. " + ex.Message, Chai.WorkflowManagment.Enums.RMessageType.Error));
            }
        }
        protected void ddlEdtAccountDescription_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddl = (DropDownList)sender;
            TextBox txtAccountCode = ddl.FindControl("txtEdtAccountCode") as TextBox;
            txtAccountCode.Text = _presenter.GetItemAccount(Convert.ToInt32(ddl.SelectedValue)).AccountCode;
            ScriptManager.RegisterStartupScript(this, GetType(), "showDetailModal", "showDetailModal();", true);
        }
        protected void ddlEdtProject_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddl = (DropDownList)sender;
            DropDownList ddlEdtGrant = ddl.FindControl("ddlEdtGrant") as DropDownList;
            BindGrant(ddlEdtGrant, Convert.ToInt32(ddl.SelectedValue));
            ScriptManager.RegisterStartupScript(this, GetType(), "showDetailModal", "showDetailModal();", true);
        }

    }
}
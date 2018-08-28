﻿using System;
using System.Collections.Generic;
using Microsoft.Practices.CompositeWeb;
using Microsoft.Practices.ObjectBuilder;

using Chai.WorkflowManagment.CoreDomain.Users;
using Chai.WorkflowManagment.Shared;
using Chai.WorkflowManagment.CoreDomain.Setting;
using Chai.WorkflowManagment.Shared.MailSender;

namespace Chai.WorkflowManagment.Modules.Admin.Views
{
    public class UserEditPresenter : Presenter<IUserEditView>
    {
        private AdminController _controller;

        private AppUser _user;

        public UserEditPresenter([CreateNew] AdminController controller)
        {
            _controller = controller;

        }

        public override void OnViewLoaded()
        {

        }

        public override void OnViewInitialized()
        {

        }

        public AppUser CurrentUser
        {
            get
            {
                if (_user == null)
                {
                    int id = int.Parse(View.GetUserId);
                    if (id > 0)
                        _user = _controller.GetUser(id);
                    else
                        _user = new AppUser();
                }
                return _user;
            }
        }

        public Role GetRoleById(int roleid)
        {
            return _controller.GetRoleById(roleid);
        }
        public IList<Role> GetRoles()
        {
            return _controller.GetRoles;
        }

        public void SaveOrUpdateUser()
        {
            AppUser user = CurrentUser;

            if (user.Id <= 0)
                user.UserName = View.GetUserName;

            user.FirstName = View.GetFirstName;
            user.LastName = View.GetLastName;
            user.EmployeeNo = View.GetEmployeeNo;
            user.Email = View.GetEmail;
            user.PersonalEmail = View.GetPersonalEmail;
            user.IsActive = View.GetIsActive;
            user.DateModified = DateTime.Now;
            user.EmployeePosition = View.EmployeePosition;
            user.Superviser = View.Superviser;
            if (View.GetPassword.Length > 0)
            {
                try
                {
                    user.Password = AppUser.HashPassword(View.GetPassword);
                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }

            if (user.Id <= 0 && user.Password == null)
                throw new Exception("Password is required");
            //Send Email on their personal email the first time they're registered.
            if (user.Id <= 0)
                EmailSender.Send(user.PersonalEmail, "Welcome to CHAI ERP System", "Hello " + (user.FullName).ToUpper() + " You can access the ERP system by clicking the following link");

            _controller.SaveOrUpdateUser(user);
        }

        public void RemoveUserRoles()
        {
            if (CurrentUser.AppUserRoles.Count > 0)
            {
                AppUserRole[] uroles = new AppUserRole[CurrentUser.AppUserRoles.Count];
                CurrentUser.AppUserRoles.CopyTo(uroles, 0);
                CurrentUser.AppUserRoles.Clear();
                _controller.RemoveListOfObjects<AppUserRole>(uroles);
            }
        }

        public void DeleteUser()
        {
            if (CurrentUser.Id > 0)
                _controller.DeleteEntity<AppUser>(CurrentUser);
        }

        public void CancelPage()
        {
            _controller.Navigate(String.Format("~/Admin/Users.aspx?{0}=0", AppConstants.TABID));
        }
        public void RedirectPage(string url)
        {
            _controller.Navigate(url);

        }
        public IList<AppUser> GetUsers()
        {

            return _controller.GetUsers();

        }
        public AppUser GetUser(int userid)
        {
            return _controller.GetUser(userid);
        }
        public IList<EmployeePosition> GetEmployeePositions()
        {
            return _controller.GetEmployeePositions();
        }
        public EmployeePosition GetEmployeePosition(int EmployeePositionId)
        {
            return _controller.GetEmployeePosition(EmployeePositionId);
        }
        public IList<Project> GetProjects()
        {
            return _controller.GetProjects();
        }
        public Project GetProject(int ProjectId)
        {
            return _controller.GetProject(ProjectId);
        }
    }
}





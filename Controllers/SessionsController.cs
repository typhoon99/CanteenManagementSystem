using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace CanteenManagement.Controllers
{
    public class SessionsController : Controller
    {
        public int UserId
        {
            get
            {
                var userId = Session["UserId"];
                return userId == null ? -1 : int.Parse(userId.ToString());
            }
            set
            {
                Session["UserId"] = value;
            }
        }
        public string UserName
        {
            get
            {
                var userName = Session["UserName"];
                return userName == null ? "" : userName.ToString();
            }
            set
            {
                Session["UserName"] = value;
            }
        }
        public string UserRole
        {
            get
            {
                var userRole = Session["UserRole"];
                return userRole == null ? "" : userRole.ToString();
            }
            set
            {
                Session["UserRole"] = value;
            }
        }
        public bool isUserVerified(string role)
        {
            //var uId = Session["UserId"];
            //var uName = Session["UserName"];
            //var uType = Session["UserType"];
            if (UserId > -1 && UserName != "" && UserRole == role)
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        [HttpGet]
        public ActionResult LogOut()
        {
            Session.Abandon();
            Session.Remove("UserId");
            Session.Remove("UserName");
            Session.Remove("UserType");
            return Redirect("/Home/Index");
        }
    }
}
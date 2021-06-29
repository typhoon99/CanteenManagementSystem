using CanteenManagement.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace CanteenManagement.Controllers
{
    public class HomeController : SessionsController
    {
        public ActionResult Index()
        {
            if (TempData["message"] != null)
            {
                ViewBag.Message = TempData["message"].ToString();
            }
            return View();
        }

        public ActionResult Register()
        {
            if (TempData["message"] != null)
            {
                ViewBag.Message = TempData["message"].ToString();
            }
            return View();
        }
        [HttpPost]
        public ActionResult Register(Users user, string firstName, string lastName, string mobile)
        {
            using (Canteen_ManagementEntities dc = new Canteen_ManagementEntities())
            {
                Users existingUser = dc.Users.Where(a => a.Username.Equals(user.Username)).FirstOrDefault();
                if (existingUser != null)
                {
                    TempData["message"] = "User with this email already exists. Please Login or use different email.";
                    return Redirect("/Home/Register");
                }
                else
                {
                    Users newUser = user;
                    newUser.Role = "Customer";
                    newUser.isActive = true;
                    dc.Users.Add(newUser);
                    UserProfile newProfile = new UserProfile
                    {
                        Users = newUser,
                        //newProfile.UserId = newUser.Id;
                        FName = firstName,
                        LName = lastName,
                        Email = user.Username,
                        MobileNo = mobile
                    };
                    dc.UserProfile.Add(newProfile);
                    dc.SaveChanges();
                    UserId = newUser.Id;
                    UserName = newUser.Username;
                    UserRole = newUser.Role;
                    return RedirectToAction("Index", "Customer");
                }
            }
            //return View();
        }


        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Login(Users loginUser)
        {
            using (Canteen_ManagementEntities dc = new Canteen_ManagementEntities())
            {
                Users user = dc.Users.Where(a => a.Username.Equals(loginUser.Username) && a.Password.Equals(loginUser.Password) && a.isActive == true).FirstOrDefault();
                if (user == null)
                {
                    TempData["message"] = "Wrong Credentials";
                    return Redirect("/Home/Index");
                }
                else
                {
                    UserId = user.Id;
                    UserName = user.Username;
                    UserRole = user.Role;
                    if (user.Role == "Admin")
                    {
                        return RedirectToAction("Index", "Admin");
                    }
                    else if (user.Role == "Staff")
                    {
                        return RedirectToAction("Index", "Staff");
                    }
                    else
                    {
                        return RedirectToAction("Index", "Customer");
                    }
                }
            }
        }
    }
}
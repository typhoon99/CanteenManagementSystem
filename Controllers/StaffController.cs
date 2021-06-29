using CanteenManagement.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace CanteenManagement.Controllers
{
    public class StaffController : SessionsController
    {
        private void SetCurrentUser()
        {
            using (Canteen_ManagementEntities dc = new Canteen_ManagementEntities())
            {
                ViewBag.CurrentUser = dc.UserProfile.Where(a => a.UserId == UserId).FirstOrDefault();
            }
        }
        // GET: Staff
        public ActionResult Index()
        {
            bool status = isUserVerified("Staff");
            if (status == false)
            {
                return Redirect("/Home/Index");
            }
            return RedirectToAction("Orders");
        }
        [HttpGet]
        public ActionResult Orders()
        {
            bool status = isUserVerified("Staff");
            if (status == false)
            {
                return Redirect("/Home/Index");
            }
            using (Canteen_ManagementEntities dc = new Canteen_ManagementEntities())
            {
                List<ProcessOrder> orders = new List<ProcessOrder>();
                List<CustomerOrders> placedOrders = dc.CustomerOrders.Where(a => a.isConfirmed == null).OrderBy(a => a.OrderedOn).ToList();
                foreach (CustomerOrders order in placedOrders)
                {
                    Users User = dc.Users.Where(a => a.Id == order.CustomerId).FirstOrDefault();
                    UserProfile UserProfile = dc.UserProfile.Where(a => a.UserId == User.Id).FirstOrDefault();
                    List<CustomerOrderItems> orderItems = dc.CustomerOrderItems.Where(a => a.OrderId == order.Id).ToList();
                    ProcessOrder processOrder = new ProcessOrder
                    {
                        user = User,
                        userProfile = UserProfile,
                        order = order,
                        orderItems = orderItems
                    };
                    orders.Add(processOrder);
                }
                ViewBag.Orders = orders;
                SetCurrentUser();
            }
            return View();
        }
        [HttpGet]
        public ActionResult AcceptOrder(int id)
        {
            bool status = isUserVerified("Staff");
            if (status == false)
            {
                return Redirect("/Home/Index");
            }
            using (Canteen_ManagementEntities dc = new Canteen_ManagementEntities())
            {
                CustomerOrders order = dc.CustomerOrders.Where(a => a.Id == id).FirstOrDefault();
                if (order != null)
                {
                    order.isConfirmed = true;
                    order.ProcessedBy = UserId;
                    order.ProcessedOn = DateTime.Now;
                    dc.SaveChanges();
                }
                return RedirectToAction("Orders");
            }
        }
        [HttpGet]
        public ActionResult RejectOrder(int id)
        {
            bool status = isUserVerified("Staff");
            if (status == false)
            {
                return Redirect("/Home/Index");
            }
            using (Canteen_ManagementEntities dc = new Canteen_ManagementEntities())
            {
                CustomerOrders order = dc.CustomerOrders.Where(a => a.Id == id).FirstOrDefault();
                if (order != null)
                {
                    order.isConfirmed = false;
                    order.ProcessedBy = UserId;
                    order.ProcessedOn = DateTime.Now;
                    dc.SaveChanges();
                }
                return RedirectToAction("Orders");
            }
        }
        [HttpGet]
        public ActionResult ViewStock()
        {
            bool status = isUserVerified("Staff");
            if (status == false)
            {
                return Redirect("/Home/Index");
            }
            using (Canteen_ManagementEntities dc = new Canteen_ManagementEntities())
            {
                var stock = dc.Stock.OrderBy(a => a.AvailableQty).ToList();
                ViewBag.StockList = stock;
                SetCurrentUser();
                return View();
            }
        }
        [HttpGet]
        public ActionResult ViewBills()
        {
            bool status = isUserVerified("Staff");
            if (status == false)
            {
                return Redirect("/Home/Index");
            }
            using (Canteen_ManagementEntities dc = new Canteen_ManagementEntities())
            {
                var orders = dc.CustomerOrders.Where(a => a.isConfirmed == true && a.ProcessedBy == UserId).OrderBy(a => a.OrderedOn).ToList();
                ViewBag.Bills = orders;
                SetCurrentUser();
                return View();
            }
        }
        [HttpGet]
        public ActionResult Bill(int id)
        {
            bool status = isUserVerified("Staff");
            if (status == false)
            {
                return Redirect("/Home/Index");
            }
            using (Canteen_ManagementEntities dc = new Canteen_ManagementEntities())
            {
                CustomerOrders order = dc.CustomerOrders.Where(a => a.Id == id && a.isConfirmed == true).FirstOrDefault();
                if (order == null)
                {
                    return Redirect("/Admin/Index");
                }
                ViewBag.OrderedItems = dc.CustomerOrderItems.Where(a => a.OrderId == id).ToList();
                ViewBag.Order = order;
                SetCurrentUser();
                return View();
            }
        }
    }
}
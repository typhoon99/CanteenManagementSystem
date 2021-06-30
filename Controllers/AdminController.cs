using CanteenManagement.Models;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace CanteenManagement.Controllers
{
    public class AdminController : SessionsController
    {
        private void SetCurrentUser()
        {
            using(Canteen_ManagementEntities dc = new Canteen_ManagementEntities())
            {
                ViewBag.CurrentUser = dc.UserProfile.Where(a => a.UserId == UserId).FirstOrDefault();
            }
        }
        // GET: Analytics
        private void SetAnalytics()
        {
            using(Canteen_ManagementEntities dc = new Canteen_ManagementEntities())
            {
                var todaysDate = new DateTime(DateTime.Today.Year, DateTime.Today.Month, DateTime.Today.Day);
                var startOfTthisMonth = new DateTime(DateTime.Today.Year, DateTime.Today.Month, 1);
                var firstDay = startOfTthisMonth;
                var lastDay = startOfTthisMonth.AddDays(DateTime.DaysInMonth(DateTime.Today.Year, DateTime.Today.Month));
                double? totalSale = dc.CustomerOrders.Where(a=>a.isConfirmed==true).Sum(a => a.OrderTotal);
                double? dailySale = dc.CustomerOrders.Where(a=>a.OrderedOn>=todaysDate && a.isConfirmed == true).Sum(a => a.OrderTotal);
                double? monthlySale = dc.CustomerOrders.Where(a=>a.OrderedOn>=firstDay&&a.OrderedOn<=lastDay && a.isConfirmed == true).Sum(a => a.OrderTotal);
                int totalUsers = dc.Users.Where(a=>a.isActive==true).Count();
                ViewBag.TotalSale = totalSale==null?0:totalSale;
                ViewBag.DailySale = dailySale == null ? 0 :dailySale;
                ViewBag.MonthlySale = monthlySale == null ? 0 :monthlySale;
                ViewBag.TotalUsers = totalUsers;
            }
        }
        // GET: Admin
        public ActionResult Index()
        {
            bool status = isUserVerified("Admin");
            if (status==false)
            {
                return Redirect("/Home/Index");
            }
            return RedirectToAction("Orders");
        }
        [HttpGet]
        public ActionResult Orders()
        {
            bool status = isUserVerified("Admin");
            if (status == false)
            {
                return Redirect("/Home/Index");
            }
            using (Canteen_ManagementEntities dc = new Canteen_ManagementEntities())
            {
                List<ProcessOrder> orders = new List<ProcessOrder>();
                List<CustomerOrders> placedOrders = dc.CustomerOrders.Where(a => a.isConfirmed == null).OrderBy(a => a.OrderedOn).ToList();
                foreach(CustomerOrders order in placedOrders)
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
            }
            SetCurrentUser();
            SetAnalytics();
            return View();
        }
        // GET: Admin/AddStock
        public ActionResult AddStock()
        {
            bool status = isUserVerified("Admin");
            if (status == false)
            {
                return Redirect("/Home/Index");
            }
            SetCurrentUser();
            SetAnalytics();
            return View();
        }
        // POST: Admin/AddStock
        [HttpPost]
        public ActionResult AddStock(Stock newStock)
        {
            bool status = isUserVerified("Admin");
            if (status == false)
            {
                return Redirect("/Home/Index");
            }
            using (Canteen_ManagementEntities dc = new Canteen_ManagementEntities())
            { 
                newStock.BatchNo = 1;
                newStock.LastOrderdOn = DateTime.Now;
                newStock.LastOrderedQty = newStock.Quantity;
                newStock.AvailableQty = newStock.Quantity;
                if (Request.Files.Count > 0)
                {
                    var file = Request.Files[0];

                    if (file != null && file.ContentLength > 0)
                    {
                        var fileName = newStock.ItemName + Path.GetExtension(file.FileName);
                        var path = Path.Combine(Server.MapPath("~/Content/Images/"), fileName);
                        file.SaveAs(path);
                        newStock.ItemImagePath = "/Images/" + fileName;
                    }
                    dc.Stock.Add(newStock);
                    dc.SaveChanges();
                }
                SetCurrentUser();
                SetAnalytics();
                return RedirectToAction("AddStock");
            }
        }

        // GET: Admin/OrderStock
        [HttpGet]
        public ActionResult OrderStock()
        {
            bool status = isUserVerified("Admin");
            if (status == false)
            {
                return Redirect("/Home/Index");
            }
            using (Canteen_ManagementEntities dc = new Canteen_ManagementEntities())
            {
                var stockItems = new SelectList(dc.Stock.ToList(), "Id", "ItemName");
                ViewData["StockItems"] = stockItems;
                SetCurrentUser();
                SetAnalytics();
                return View();
            }
        }
        // POST: Admin/OrderStock
        [HttpPost]
        public ActionResult OrderStock(List<BatchDetails> orderedItems)
        {
            bool status = isUserVerified("Admin");
            if (status == false)
            {
                return Redirect("/Home/Index");
            }
            string returnStatus = "fail";
            int totQty = 0;
            int totItems = 0;
            double totPrice = 0;
            using (Canteen_ManagementEntities dc = new Canteen_ManagementEntities())
            {
                StockBatch batch = new StockBatch();
                dc.StockBatch.Add(batch);
                foreach (var item in orderedItems)
                {
                    totItems++;
                    BatchDetails orderItem = new BatchDetails();
                    Stock stockItem = dc.Stock.Where(a => a.ItemName == item.ItemName).FirstOrDefault();
                    orderItem.ItemId = stockItem.Id;
                    orderItem.ItemName = item.ItemName;
                    orderItem.ItemQuantity = item.ItemQuantity;
                    stockItem.AvailableQty += item.ItemQuantity;
                    stockItem.LastOrderedQty = item.ItemQuantity;
                    stockItem.LastOrderdOn = DateTime.Now;
                    stockItem.BatchNo = batch.Id;
                    totQty += item.ItemQuantity;
                    orderItem.ItemPrice = item.ItemPrice;
                    totPrice += item.ItemPrice;
                    orderItem.OrderId = batch.Id;
                    orderItem.OrderedOn = DateTime.Now;
                    orderItem.OrderedBy = UserName;
                    dc.BatchDetails.Add(orderItem);
                }
                batch.TotalItems = totItems;
                batch.TotalQuantity = totQty;
                batch.TotalPrice = totPrice;
                batch.isComplete = true;
                dc.SaveChanges();
                returnStatus = "success";
            }
            SetCurrentUser();
            SetAnalytics();
            return new JsonResult { Data = new { status = returnStatus } };
        }
        [HttpGet]
        public ActionResult GetItemPrice(int selectedItem)
        {
            bool status = isUserVerified("Admin");
            if (status == false)
            {
                return Redirect("/Home/Index");
            }
            using (Canteen_ManagementEntities dc = new Canteen_ManagementEntities())
            {
                Stock item = dc.Stock.Where(a => a.Id == selectedItem).FirstOrDefault();
                return new JsonResult { Data = new { price = item.CostPricePerPiece }, JsonRequestBehavior = JsonRequestBehavior.AllowGet };
            }
        }
        [HttpGet]
        public ActionResult ViewStock()
        {
            bool status = isUserVerified("Admin");
            if (status == false)
            {
                return Redirect("/Home/Index");
            }
            using (Canteen_ManagementEntities dc = new Canteen_ManagementEntities())
            {
                var stock = dc.Stock.OrderBy(a => a.AvailableQty).ToList();
                ViewBag.StockList = stock;
                SetCurrentUser();
                SetAnalytics();
                return View();
            }
        }
        [HttpGet]
        public ActionResult ViewBills()
        {
            bool status = isUserVerified("Admin");
            if (status == false)
            {
                return Redirect("/Home/Index");
            }
            using (Canteen_ManagementEntities dc = new Canteen_ManagementEntities())
            {
                var orders = dc.CustomerOrders.Where(a=>a.isConfirmed==true).OrderBy(a => a.OrderedOn).ToList();
                ViewBag.Bills = orders;
                SetCurrentUser();
                SetAnalytics();
                return View();
            }
        }
        [HttpGet]
        public ActionResult Bill(int id)
        {
            bool status = isUserVerified("Admin");
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
                //double totalPrice = 0;
                //foreach(var item in ViewBag.OrderedItems)
                //{
                //    totalPrice += item.Price;
                //}
                //ViewBag.TotalPrice = totalPrice;
                //ViewBag.Order = order.CustomerName;
                ViewBag.Order = order;
                SetCurrentUser();
                SetAnalytics();
                return View();
            }
        }
        [HttpGet]
        public ActionResult AcceptOrder(int id)
        {
            bool status = isUserVerified("Admin");
            if (status == false)
            {
                return Redirect("/Home/Index");
            }
            using (Canteen_ManagementEntities dc = new Canteen_ManagementEntities())
            {
                CustomerOrders order = dc.CustomerOrders.Where(a => a.Id == id).FirstOrDefault();
                if(order!=null)
                {
                    order.isConfirmed = true;
                    dc.SaveChanges();
                }
                return RedirectToAction("Orders");
            }
        }
        [HttpGet]
        public ActionResult RejectOrder(int id)
        {
            bool status = isUserVerified("Admin");
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
                    dc.SaveChanges();
                }
                return RedirectToAction("Orders");
            }
        }
    }
}

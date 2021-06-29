using CanteenManagement.Models;
using System;
using System.Collections.Generic;
using System.Dynamic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;

namespace CanteenManagement.Controllers
{
    public class CheckoutItems
    {
        public int Id { get; set; }
        public string ItemName { get; set; }
        public string ItemImagePath { get; set; }
        public string ItemType { get; set; }
        public int Quantity { get; set; }
        public double Price { get; set; }
        public double SellingPricePerPiece { get; set; }
        public string Description { get; set; }
    }
    public class Category
    {
        public string category { get; set; }
        public int items { get; set; }
    }
    public class CustomerController : SessionsController
    {
        private void SetCurrentUser()
        {
            using (Canteen_ManagementEntities dc = new Canteen_ManagementEntities())
            {
                ViewBag.CurrentUser = dc.UserProfile.Where(a => a.UserId == UserId).FirstOrDefault();
            }
        }
        // GET: Customer
        public ActionResult Index(string category)
        {
            bool status = isUserVerified("Customer");
            if (status == false)
            {
                return Redirect("/Home/Index");
            }
            using (Canteen_ManagementEntities dc = new Canteen_ManagementEntities())
            {
                if (category == null)
                {
                    ViewBag.Products = dc.Stock.Where(a => a.AvailableQty > a.Threshold).ToList();
                }
                else
                {
                    ViewBag.Products = dc.Stock.Where(a => a.ItemType.Equals(category, StringComparison.InvariantCultureIgnoreCase) && a.AvailableQty > a.Threshold).ToList();
                }
                ViewBag.Categories = dc.Stock.Where(a => a.AvailableQty > a.Threshold).GroupBy(a => a.ItemType).Select(r => new Category { category = r.Key, items = r.Count() }).ToList();
                ViewBag.CartItems = GetCartItems();
                ViewBag.Quantity = GetCartItemsNo();
                ViewBag.Price = GetCartTotalPrice();
                SetCurrentUser();
                return View();
            }
        }

        [HttpPost]
        public ActionResult AddToCart(int id, int quantity)
        {
            bool status = isUserVerified("Customer");
            if (status == false)
            {
                return Redirect("/Home/Index");
            }
            using (Canteen_ManagementEntities dc = new Canteen_ManagementEntities())
            {
                Stock item = dc.Stock.Where(a => a.Id == id).FirstOrDefault();
                CartItems existingItem = dc.CartItems.Where(a => a.StockId == id && a.UserId==UserId).FirstOrDefault();
                if (existingItem == null)
                {
                    CartItems cartItem = new CartItems
                    {
                        AddedOn = DateTime.Now,
                        StockId = item.Id,
                        UserId = UserId,
                        UserName = UserName,
                        ItemName = item.ItemName,
                        Quantity = quantity,
                        Price = quantity * item.SellingPricePerPiece
                    };
                    dc.CartItems.Add(cartItem);
                }
                else
                {
                    existingItem.Quantity += quantity;
                    existingItem.Price += quantity * item.SellingPricePerPiece;
                }
                dc.SaveChanges();
                ViewBag.CartItems = GetCartItems();
                ViewBag.Quantity = GetCartItemsNo();
                ViewBag.Price = GetCartTotalPrice();
                SetCurrentUser();
                return new JsonResult { Data = new { status = "success", cartItems = ViewBag.CartItems, quantity = ViewBag.Quantity, price = ViewBag.Price } };
            }
        }
        [HttpDelete]
        public ActionResult RemoveFromCart(int id)
        {
            bool status = isUserVerified("Customer");
            if (status == false)
            {
                return Redirect("/Home/Index");
            }
            using (Canteen_ManagementEntities dc = new Canteen_ManagementEntities())
            {
                CartItems removeItem = dc.CartItems.Where(a => a.StockId == id).FirstOrDefault();
                dc.CartItems.Remove(removeItem);
                dc.SaveChanges();
                ViewBag.CartItems = GetCartItems();
                ViewBag.Quantity = GetCartItemsNo();
                ViewBag.Price = GetCartTotalPrice();
                SetCurrentUser();
                return new JsonResult { Data = new { status = "success", cartItems = ViewBag.CartItems, quantity = ViewBag.Quantity, price = ViewBag.Price } };
            }
        }
        public int GetCartItemsNo()
        {
            using (Canteen_ManagementEntities dc = new Canteen_ManagementEntities())
            {
                int items = dc.CartItems.Where(a => a.UserId == UserId).Select(a => a.StockId).Distinct().Count();
                return items;
            }
        }
        public string GetUserFirstName()
        {
            using (Canteen_ManagementEntities dc = new Canteen_ManagementEntities())
            {
                string name = dc.UserProfile.Where(a => a.UserId == UserId).Select(a => a.FName).FirstOrDefault().ToString();
                return name;
            }
        }
        public float GetCartTotalPrice()
        {
            using (Canteen_ManagementEntities dc = new Canteen_ManagementEntities())
            {
                List<CartItems> items = dc.CartItems.Where(a => a.UserId == UserId).ToList();
                float totalPrice = 0;
                foreach (var item in items)
                {
                    totalPrice += float.Parse(item.Price.ToString());
                }
                return totalPrice;
            }
        }
        public List<CheckoutItems> GetCartItems()
        {
            using (Canteen_ManagementEntities dc = new Canteen_ManagementEntities())
            {
                List<CheckoutItems> products = new List<CheckoutItems>();
                List<CartItems> items = dc.CartItems.Where(a => a.UserId == UserId).ToList();
                foreach (CartItems item in items)
                {
                    Stock stock = dc.Stock.Where(a => a.Id == item.StockId).FirstOrDefault();
                    CheckoutItems checkoutItem = new CheckoutItems
                    {
                        Id = stock.Id,
                        Description = stock.Description,
                        ItemImagePath = stock.ItemImagePath,
                        ItemName = stock.ItemName,
                        ItemType = stock.ItemType,
                        Price = (double)item.Price,
                        SellingPricePerPiece = stock.SellingPricePerPiece,
                        Quantity = int.Parse(item.Quantity.ToString())
                    };
                    products.Add(checkoutItem);
                }
                return products;
            }
        }
        [HttpGet]
        public ActionResult Cart()
        {
            bool status = isUserVerified("Customer");
            if (status == false)
            {
                return Redirect("/Home/Index");
            }
            using (Canteen_ManagementEntities dc = new Canteen_ManagementEntities())
            {
                ViewBag.CartItems = GetCartItems();
                ViewBag.Quantity = GetCartItemsNo();
                ViewBag.Price = GetCartTotalPrice();
                SetCurrentUser();
                return View();
            }
        }
        [HttpPost]
        public ActionResult Checkout()
        {
            bool status = isUserVerified("Customer");
            if (status == false)
            {
                return Redirect("/Home/Index");
            }
            using (Canteen_ManagementEntities dc = new Canteen_ManagementEntities())
            {
                int userId = UserId;
                string userName = UserName;
                int totalItems = 0;
                double totalPrice = 0;
                List<CartItems> cartItems = dc.CartItems.Where(a => a.UserId == userId).ToList();
                CustomerOrders order = new CustomerOrders
                {
                    OrderedOn = DateTime.Now,
                    CustomerId = UserId
                };
                UserProfile currentUser = dc.UserProfile.Where(a => a.UserId == userId).FirstOrDefault();
                order.CustomerName = currentUser != null ? currentUser.FName + " " + currentUser.LName : UserName;
                dc.CustomerOrders.Add(order);
                foreach (var item in cartItems)
                {
                    CustomerOrderItems orderedItem = new CustomerOrderItems
                    {
                        StockId = item.StockId,
                        OrderId = order.Id,
                        UserId = userId,
                        UserName = item.UserName,
                        ItemName = item.ItemName,
                        Price = item.Price
                    };
                    totalPrice += (double)orderedItem.Price;
                    orderedItem.Quantity = item.Quantity;
                    totalItems += (int)orderedItem.Quantity;
                    dc.CustomerOrderItems.Add(orderedItem);
                    dc.CartItems.Remove(item);
                }
                order.OrderTotal = totalPrice;
                order.OrderedItems = totalItems;
                order.isConfirmed = null;
                dc.SaveChanges();
                SetCurrentUser();
                return new JsonResult { Data = new { status = "true", Id = order.Id } };
            }
        }
        [HttpGet]
        public ActionResult Orders()
        {
            bool status = isUserVerified("Customer");
            if (status == false)
            {
                return Redirect("/Home/Index");
            }
            using (Canteen_ManagementEntities dc = new Canteen_ManagementEntities())
            {
                var orders = dc.CustomerOrders.Where(a => a.CustomerId == UserId).OrderByDescending(a => a.OrderedOn).ToList();
                ViewBag.Bills = orders;
                ViewBag.CartItems = GetCartItems();
                ViewBag.Quantity = GetCartItemsNo();
                ViewBag.Price = GetCartTotalPrice();
                SetCurrentUser();
                return View();
            }
        }
        [HttpGet]
        public ActionResult Bill(int id)
        {
            bool status = isUserVerified("Customer");
            if (status == false)
            {
                return Redirect("/Home/Index");
            }
            using (Canteen_ManagementEntities dc =new Canteen_ManagementEntities())
            {
                UserProfile currentUser = dc.UserProfile.Where(a => a.UserId == UserId).FirstOrDefault();
                CustomerOrders order = dc.CustomerOrders.Where(a => a.Id == id && a.isConfirmed==true && a.CustomerId == UserId).FirstOrDefault();
                if(order==null)
                {
                    return Redirect("/Customer/Orders");
                }
                ViewBag.OrderedItems = dc.CustomerOrderItems.Where(a => a.OrderId == id).ToList();
                ViewBag.Order = order;
                ViewBag.CartItems = GetCartItems();
                ViewBag.Quantity = GetCartItemsNo();
                ViewBag.Price = GetCartTotalPrice();
                SetCurrentUser();
                return View();
            }
        }
    }
}
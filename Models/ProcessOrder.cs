using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CanteenManagement.Models
{
    public class ProcessOrder
    {
        public Users user { get; set; }
        public UserProfile userProfile { get; set; }
        public CustomerOrders order { get; set; }
        public List<CustomerOrderItems> orderItems { get; set; }
    }
}
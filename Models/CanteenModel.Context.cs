﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace CanteenManagement.Models
{
    using System;
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;
    
    public partial class Canteen_ManagementEntities : DbContext
    {
        public Canteen_ManagementEntities()
            : base("name=Canteen_ManagementEntities")
        {
        }
    
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();
        }
    
        public virtual DbSet<BatchDetails> BatchDetails { get; set; }
        public virtual DbSet<CartItems> CartItems { get; set; }
        public virtual DbSet<CustomerOrderItems> CustomerOrderItems { get; set; }
        public virtual DbSet<StockBatch> StockBatch { get; set; }
        public virtual DbSet<UserProfile> UserProfile { get; set; }
        public virtual DbSet<Users> Users { get; set; }
        public virtual DbSet<Stock> Stock { get; set; }
        public virtual DbSet<CustomerOrders> CustomerOrders { get; set; }
    }
}

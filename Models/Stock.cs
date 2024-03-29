//------------------------------------------------------------------------------
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
    using System.Collections.Generic;
    
    public partial class Stock
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Stock()
        {
            this.BatchDetails = new HashSet<BatchDetails>();
            this.CartItems = new HashSet<CartItems>();
            this.CustomerOrderItems = new HashSet<CustomerOrderItems>();
        }
    
        public int Id { get; set; }
        public string ItemName { get; set; }
        public string ItemImagePath { get; set; }
        public int Quantity { get; set; }
        public string UnitofMeasurement { get; set; }
        public double CostPricePerPiece { get; set; }
        public System.DateTime MfgDt { get; set; }
        public System.DateTime ExpDt { get; set; }
        public int AvailableQty { get; set; }
        public System.DateTime LastOrderdOn { get; set; }
        public int LastOrderedQty { get; set; }
        public Nullable<int> BatchNo { get; set; }
        public string ItemType { get; set; }
        public string Description { get; set; }
        public int Threshold { get; set; }
        public double SellingPricePerPiece { get; set; }
    
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<BatchDetails> BatchDetails { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<CartItems> CartItems { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<CustomerOrderItems> CustomerOrderItems { get; set; }
        public virtual StockBatch StockBatch { get; set; }
    }
}

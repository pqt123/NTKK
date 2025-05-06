//
//  InvoiceDetail.swift
//  DoAnIOS_Product
//
//  Created by  User on 05.05.2025.
//

import UIKit

class InvoiceDetail {
    
    // MARK: Properties
        var inv_dtl_id:Int?
        var inv_dtl_inv_id:Int
        var inv_dtl_prod_id:Int
        var inv_dtl_qty:Int
        
        // MARK: Constructors
    init?(inv_dtl_id:Int, inv_dtl_inv_id: Int, inv_dtl_prod_id: Int, inv_dtl_qty: Int) {
            // Khong them duoc san pham vao invoice detail
           /* if inv_date.isEmpty {
                return nil
            }*/
      /*  if inv_customer_id.isEmpty {
                return nil
        }*/
            self.inv_dtl_id = inv_dtl_id
            self.inv_dtl_inv_id = inv_dtl_inv_id
            self.inv_dtl_prod_id = inv_dtl_prod_id
            self.inv_dtl_qty = inv_dtl_qty
        }

}

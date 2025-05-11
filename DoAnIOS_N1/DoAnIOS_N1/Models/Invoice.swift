//
//  Invoice.swift
//  DoAnIOS_Product
//
//  Created by  User on 05.05.2025.
//

import UIKit

class Invoice {
    
    // MARK: Properties
        var inv_id:Int?
        var inv_date:String
        var inv_customer_id:Int
        var inv_total:Double
        var customer_name:String?
        var customer_phone:String?
        
        // MARK: Constructors
    init?(inv_id:Int, inv_date: String, inv_customer_id: Int, inv_total:Double, customer_name: String?, customer_phone: String?) {
            // Khong tao duoc invoice
            if inv_date.isEmpty {
                return nil
            }
      /*  if inv_customer_id.isEmpty {
                return nil
        }*/
            self.inv_id = inv_id
            self.inv_date = inv_date
            self.inv_customer_id = inv_customer_id
            self.inv_total = inv_total
            self.customer_name = customer_name
            self.customer_phone = customer_phone
        }

}

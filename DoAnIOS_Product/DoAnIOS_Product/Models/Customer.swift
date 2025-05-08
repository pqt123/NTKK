//
//  Customer.swift
//  DoAnIOS_Product
//
//  Created by  User on 07.05.2025.
//

import UIKit

class Customer {

    // MARK: Properties
        var customer_id:Int
        var customer_name:String
        var customer_phone:String
        
        // MARK: Constructors
    init?(customer_id:Int, customer_name: String, customer_phone: String) {
            // Khong tao duoc mon an
            if customer_name.isEmpty {
                return nil
            }
            if customer_phone.isEmpty {
                return nil
            }
            self.customer_name = customer_name
            self.customer_phone = customer_phone
            self.customer_id = customer_id
        }
}

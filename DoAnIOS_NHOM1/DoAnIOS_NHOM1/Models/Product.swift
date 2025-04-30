//
//  Product.swift
//  DoAnIOS_NHOM1
//
//  Created by  User on 28.04.2025.
//

import UIKit
class Product {

    // MARK: Properties
        var prod_name:String
        var prod_qty:Int
        var prod_price:Double
        var prod_image:UIImage?
        //var ratingValue:Int
        
        // MARK: Constructors
    init?(prod_name: String, prod_qty: Int, prod_price:Double, prod_image: UIImage? = nil) {
            // Khong tao duoc mon an
            if prod_name.isEmpty {
                return nil
            }
           if prod_qty < 0 {
                return nil
            }
            if prod_price < 0 {
                return nil
            }
        /*if ratingValue < 0 || ratingValue > 5 {
                return nil
            }*/
            
            self.prod_name = prod_name
            self.prod_qty = prod_qty
            self.prod_price = prod_price
            self.prod_image = prod_image
            //self.ratingValue = ratingValue
        }

}

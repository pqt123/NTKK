//
//  Meal.swift
//  FoodManagement2024
//
//  Created by  User on 06.05.2024.
//

import UIKit
class Meal {
    // MARK: Properties
    var name:String
    var image:UIImage?
    var ratingValue:Int
    
    // MARK: Constructors
    init?(name: String, image: UIImage? = nil, ratingValue: Int) {
        // Khong tao duoc mon an
        if name.isEmpty {
            return nil
        }
        
        if ratingValue < 0 || ratingValue > 5 {
            return nil
        }
        
        self.name = name
        self.image = image
        self.ratingValue = ratingValue
    }
}

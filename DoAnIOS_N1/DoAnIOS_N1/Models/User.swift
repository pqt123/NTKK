//
//  User.swift
//  DoAnIOS_Product
//
//  Created by  User on 25.04.2025.
//

import UIKit

class User {

    // MARK: Properties
        var user_id:Int?
        var user_nameuser:String
        var user_password:String
        
        // MARK: Constructors
    init?(user_id:Int?, user_nameuser: String, user_password: String) {
            // Khong tao duoc mon an
            if user_nameuser.isEmpty {
                return nil
            }
            if user_password.isEmpty {
                return nil
            }
        
            self.user_id = user_id
            self.user_nameuser = user_nameuser
            self.user_password = user_password
        }
}

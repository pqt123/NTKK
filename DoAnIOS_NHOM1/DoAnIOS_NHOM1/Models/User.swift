//
//  User.swift
//  DoAnIOS_NHOM1
//
//  Created by  User on 28.04.2025.
//

import UIKit

class User {

    // MARK: Properties
        var user_nameuser:String
        var user_password:String
        
        // MARK: Constructors
    init?(user_nameuser: String, user_password: String) {
            // Khong tao duoc mon an
            if user_nameuser.isEmpty {
                return nil
            }
            if user_password.isEmpty {
                return nil
            }
            
            self.user_nameuser = user_nameuser
            self.user_password = user_password
        }
}

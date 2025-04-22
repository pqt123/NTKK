//
//  ViewController.swift
//  DoAnIOS_2
//
//  Created by  User on 22.04.2025.
//

import UIKit

class LoginController: UIViewController {
    
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func digitProcessing(_ sender: UIButton) {
        switch sender {
            case btnLogin:
                print("Login action")
                // Gọi hàm Login
                
            case btnSignUp:
                print("signup action")
                // Gọi main singup
            default:
                break
            }
    }
    
}


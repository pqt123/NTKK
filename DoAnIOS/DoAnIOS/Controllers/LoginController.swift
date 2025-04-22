//
//  ViewController.swift
//  DoAnIOS
//
//  Created by  User on 22.04.2025.
//

import UIKit

class LoginController: UIViewController {
    
    
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassWord: UITextField!
    @IBOutlet weak var btnLogIn: UIButton!
    
    let username = "nhom1"
    let password = "123456"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    //Func Login
    @IBAction func onClickLogIn(_ sender: Any) {
        if username == txtUserName.text! && password == txtPassWord.text! {
           // print("Login success!")
            self.performSegue(withIdentifier: "segue1", sender: self)
        }
        else{
            let alert = UIAlertController(title: "Alert", message: "Log in fail!", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion:  nil)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue1" {
            let mainHome = segue.destination as! HomeController
        }
    }
    
}


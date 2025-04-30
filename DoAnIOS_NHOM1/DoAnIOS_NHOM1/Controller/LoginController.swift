//
//  ViewController.swift
//  DoAnIOS_NHOM1
//
//  Created by  User on 28.04.2025.
//

import UIKit

class LoginController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    
    //Mark
    private var users = [User]()

    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var btnDeleteData: UIButton!
    
    private let signUpID = "SignUpController"
    private let homeViewID = "HomeViewController"
    var homTextUserName = ""
   
    
    // Tao doi tuong truy van CSDL
    private let dao = Database()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Doc du lieu vao mang
        dao.readUsers(users: &users)
        print("Danh sách người dùng:")
        print(users)
        for user in users {
            print("[Username: \(user.user_nameuser), Password: \(user.user_password) ]")
        }
        //An password
        
    }
    @IBAction func funcProcessing(_ sender: UIButton) {
        switch sender {
            case btnLogin:
                print("login !")
                loginProcessing()
        case btnSignUp:
                print("sign up!")
                goToSignUpView()
        case btnDeleteData:
            print("delete data")
            //dao.deleteAllUsers();
            default:
                break
         //
        }
    }
    //Thuc hien login
    func loginProcessing() {
        //khai bao
        var userNameText = ""
        var passwordText = ""
        
        if let username = txtUserName.text, !username.isEmpty{
            userNameText = username
        }else{
            showAlert(message: "Vui long nhap user name")
            return
        }
        if let password = txtPassword.text, !password.isEmpty{
            passwordText = password
        }else{
            showAlert(message: "Vui long nhap password")
            return
        }
        //Kiem tra du lieu trong bang, neu co tai khoan thi dang nhap thanh cong
        if dao.checkLogin(user_username: userNameText, user_password: passwordText) {
            // Đăng nhập thành công, chuyển sang màn hình chính
            showAlert(message: "Dang nhap thanh cong!") {
                self.homTextUserName = userNameText
                self.goToHomeView() // Chuyen den man hinh Home
            }
        } else {
            showAlert(message: "Ten username hoac password khong dung.")
            return
        }
    }
    //func signup view
    func goToSignUpView() {
        let storyboardSignUp = UIStoryboard(name: "Main", bundle: nil)
        let signUpVC = storyboardSignUp.instantiateViewController(withIdentifier: signUpID) as! SignUpController
        //Kiem tra xem co navigationController neu co thi dung UINavigationController, neu khong co thi dung present
       /* if let nav = self.navigationController {
            nav.pushViewController(signUpVC, animated: true)
        } else {
            self.present(signUpVC, animated: true)
        }*/
        present(signUpVC, animated: true)
        
    }
    //func home view
    func goToHomeView() {
        let storyboardHome = UIStoryboard(name: "Main", bundle: nil)
        let homeVC = storyboardHome.instantiateViewController(withIdentifier: homeViewID) as! HomeViewController
        
            homeVC.name = self.homTextUserName
            //Kiem tra xem co navigationController neu co thi dung UINavigationController, neu khong co thi dung present
            if let nav = self.navigationController {
                nav.pushViewController(homeVC, animated: true)
            } else {
                present(homeVC, animated: true)
            }
    }    //show Alert
    // MARK: - Hàm thông báo
    
    func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "Thông báo", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            // Khi người dùng nhấn OK, thực hiện closure nếu có
            completion?()
        }))
        present(alert, animated: true)
    }
     //End
    
}

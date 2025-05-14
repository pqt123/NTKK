//
//  LoginController.swift
//  DoAnIOS_Product
//
//  Created by  User on 25.04.2025.
//

import UIKit

class LoginController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    
    //Mark
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    
    private let signUpID = "SignUpController"
    private let homeViewID = "HomeViewController"
    //Goi Database
    let dao = Database()
    //Doc du lieu tu CSDL
    var users = [User]()
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dao.readUsers(users: &users)
        
    }
    @IBAction func funcProcessing(_ sender: UIButton) {
        switch sender {
            case btnLogin:
                print("login !")
                loginProcessing()
        case btnSignUp:
                print("sign up!")
                goToSignUpView()
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
        if let user =  dao.checkLogin(user_username: userNameText, user_password: passwordText) {
            // Đăng nhập thành công, chuyển sang màn hình chính
            showAlert(message: "Dang nhap thanh cong!") {
                self.goToHomeView(user: user) // Chuyen den man hinh Home
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
        if let nav = self.navigationController {
            nav.pushViewController(signUpVC, animated: true)
        } else {
            signUpVC.modalPresentationStyle = .fullScreen
            self.present(signUpVC, animated: true)
        }
    }
    //func home view
    func goToHomeView(user: User) {
        let storyboardHome = UIStoryboard(name: "Main", bundle: nil)
            let homeVC = storyboardHome.instantiateViewController(withIdentifier: homeViewID) as! HomeViewController
            //Kiem tra xem co navigationController neu co thi dung UINavigationController, neu khong co thi dung present
            if let nav = self.navigationController {
                nav.pushViewController(homeVC, animated: true)
            } else {
                homeVC.userLogin = user //truyen du lieu user qua trang Home
                homeVC.modalPresentationStyle = .fullScreen //dam bao full man hinh
                self.present(homeVC, animated: true)
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

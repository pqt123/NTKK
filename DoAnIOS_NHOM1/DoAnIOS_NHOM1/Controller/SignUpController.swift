//
//  SignUpController.swift
//  DoAnIOS_NHOM1
//
//  Created by  User on 28.04.2025.
//

import UIKit

class SignUpController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    
    //MARK
    
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    
    private let logInID = "LoginController"
    //Goi Database
    let dao = Database()
   // var user:User?
    //Doc du lieu tu CSDL
    var users = [User]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dao.readUsers(users: &users)
        
        //An password va confirm password
        
        // B3: Thuc hien uy quyen cho doi tuong TextField
         txtPassword.delegate = self
        
    }
    // MARK: B2. Dinh nghia cac ham uy quyen cua TextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       // An ban phim
       txtPassword.resignFirstResponder()
       return true
    }

    // Ham ket thuc qua trinh soan thao
    func textFieldDidEndEditing(_ textField: UITextField) {
       print("\(txtPassword.text!)")
    }
    @IBAction func signUpProcessing(_ sender: UIButton) {
        //khai bao
        var userNameText = ""
        var passwordText = ""
        var passwordConfirmText = ""
        
        if let username = txtUserName.text, !username.isEmpty{
            userNameText = username
        }else{
            showAlert(message: "Vui long nhap user name")
            return
        }
        if let password = txtPassword.text, !password.isEmpty{
            //Kiem tra dieu kien pw > 5 so
            let countPw = String(password).count
            if countPw < 5 {
                showAlert(message: "Password phai chua tren 5 so")
                return
                
            }
            passwordText = password
        }else{
            showAlert(message: "Vui long nhap password")
            return
        }
        if let passwordConfirm = txtConfirmPassword.text, !passwordConfirm.isEmpty{
            passwordConfirmText = passwordConfirm
        }else{
            showAlert(message: "Vui long nhap confirm password")
            return
        }
        // Kiem tra password vaf confirmpassword khop nhau khong
           if passwordText != passwordConfirmText {
               showAlert(message: "Password không khớp.")
               return
           }
        //Kiem tra neu ten nguoi dung da ton tai trong CSDL
        if dao.isUsernameExist(user_username: userNameText) {
            showAlert(message: "Ten usernam da ton tai. Vui long chon ten khac")
            return
        }
        
        // Gọi hàm thêm user trong DAO
        // Them user moi vao datasource
        if let user = User(user_nameuser: userNameText, user_password: passwordText) {
            let isSuccess = dao.insertUser(user: user)

            if isSuccess {
                //Hien thi thong tai khoan user da nhap
                print("user: \(user.user_nameuser), password: \(user.user_password)")

                
                showAlert(message: "Dang ky thanh cong!") {
                    //Sau khi dang ky thanh cong, chuyen man hinh ve Login
                    self.goToLogIn()
                }
                
            } else {
                showAlert(message: "Dang ky khong thanh cong.")
            }
        } else {
            showAlert(message: "Thong tin dang ky khong hop le.")
        }

    }
    

    //Thuc hien inser data
    func goToLogIn(){
        
        let storyboardLogin = UIStoryboard(name: "Main", bundle: nil)
       let logInVC = storyboardLogin.instantiateViewController(withIdentifier: logInID) as! LoginController
       //Kiem tra xem co navigationController neu co thi dung UINavigationController, neu khong co thi dung present
       if let nav = self.navigationController {
           nav.pushViewController(logInVC, animated: true)
       } else {
           logInVC.modalPresentationStyle = .fullScreen
           self.present(logInVC, animated: true)
       }
        
    }
    
    // MARK: - Hàm thông báo
    func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "Thông báo", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            // Khi người dùng nhấn OK, thực hiện closure nếu có
            completion?()
        }))
        present(alert, animated: true)
    }
}

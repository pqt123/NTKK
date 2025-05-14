//
//  ChangePasswordController.swift
//  DoAnIOS_N1
//
//  Created by  User on 13.05.2025.
//

import UIKit

class ChangePasswordController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var userLogin:User?
    //Goi Database
    let dao = Database()
    
    private let logInID = "LoginController"
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var currentPassword: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = userLogin{
            userName.text = user.user_nameuser
            print("User ID : \(user.user_id!) - \(user.user_nameuser)")
        }
        //B3. Thuc hien uy quyen cho doi tuong TextField
        currentPassword.delegate = self
        newPassword.delegate = self
        confirmPassword.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    //Mark : B2. dinh nghiacac ham uy quyen cua TextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //An ban phim
        currentPassword.resignFirstResponder()
        newPassword.resignFirstResponder()
        confirmPassword.resignFirstResponder()
        return true
    }
    //Ham ket thuc qua trinh soan thao
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        print("current pw:\(currentPassword.text!), new pw: \(newPassword), confirm pw: \(confirmPassword)")
    }
    
    @IBAction func changePasswordTapped(_ sender: UIButton) {
        //an ban phim
        currentPassword.resignFirstResponder()
        newPassword.resignFirstResponder()
        confirmPassword.resignFirstResponder()
        
        //Kiem tra du lieu, thuc hien chuc nang
        if let user = userLogin {
            //khai bao
            var passwordCurrentText = ""
            var passwordNewText = ""
            var passwordConfirmText = ""
            var userNameText = userName.text ?? ""
            var userID = userLogin?.user_id ?? 0
            
            if let passwordCurrent = currentPassword.text, !passwordCurrent.isEmpty{
                if(passwordCurrent != userLogin?.user_password){
                    showAlert(message: "Password khong dung")
                    return
                }
                passwordCurrentText = passwordCurrent
            }else{
                showAlert(message: "Vui long nhap password")
                return
            }
            
            if let passwordNew = newPassword.text, !passwordNew.isEmpty{
                //them check count
                passwordNewText = passwordNew
            }else{
                showAlert(message: "Vui long nhap new password")
                return
            }
            if let passwordConfirm = confirmPassword.text, !passwordConfirm.isEmpty{
                passwordConfirmText = passwordConfirm
            }else{
                showAlert(message: "Vui long nhap confirm password")
                return
            }
            // Kiem tra password vaf confirmpassword khop nhau khong
               if passwordNewText != passwordConfirmText {
                   showAlert(message: "Password không khớp.")
                   return
               }
            // Goi ham update user trong DAO
            if let user = User(user_id: userID, user_nameuser: userNameText, user_password: passwordNewText) {
                let isSuccess = dao.updateUserPassword(user: user)

                if isSuccess {
                    showAlert(message: "Thay doi mat khau thanh cong ! Vui long dang nhap lai!") {
                        //Sau khi dang ky thanh cong, chuyen man hinh ve Login
                        //print("data : ")
                        //print(user)
                        self.goToLogIn()
                    }
                    
                } else {
                    showAlert(message: "Dang ky khong thanh cong.")
                }
            } else {
                showAlert(message: "Thong tin dang ky khong hop le.")
            }        }
        else {
            showAlert(message: "Khong co du lieu.")
        }
    }
    //Thuc hien change pw
    func goToLogIn(){
        let storyboardLogin = UIStoryboard(name: "Main", bundle: nil)
       let logInVC = storyboardLogin.instantiateViewController(withIdentifier: logInID) as! LoginController
           self.present(logInVC, animated: true)
        
    }
    
    // MARK: - Hàm thông báo
    func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "Thông báo", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        present(alert, animated: true)
    }

    
    // MARK: - Navigation
/*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

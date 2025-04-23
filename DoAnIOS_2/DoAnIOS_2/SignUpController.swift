//
//  SignUpController.swift
//  DoAnIOS_2
//
//  Created by  User on 22.04.2025.
//

import UIKit

struct Users_Credentical: Codable {
    var username: String
    //var email: String
    var password: String
}

enum SignUpError: Error {
    case invalidUserName
   // case invalidEmail
    case invalidPassword
    case invalidPasswordNotMacth
    case noUser
    
    
    var localizedDescription: String {
        switch self {
        case .invalidUserName:
            return "Please enter vaild username"
      /*  case .invalidUserName:
            return "Please enter vaild email"*/
        case .invalidPassword:
            return "Please enter vaild password"
        case .invalidPasswordNotMacth:
            return "Password and confirm password must be same"
        case .noUser:
            return "User not found"
        }
    }
}

class SignUpController: UIViewController {
    
    @IBOutlet weak var txtUserName: UITextField!
   // @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPW: UITextField!
    
  /*  let alertView = UIAlertController(title: "Error", message: "some massage", preferredStyle: .alert)*/
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        /*let closeAction = UIAlertAction(title: "Close", style: .default){
            (action) in
            self.alertView.dismiss(animated: true)
        }
        alertView.addAction(closeAction)*/
    }
    

    @IBAction func btnSignUpProcess(_ sender: UIButton) {
        do {
            try handleSignUp()
        } catch {
            if let signupError = error as? SignUpError {
                //alertView.message = signupError.localizedDescription
                self.showAlert(message: signupError.localizedDescription)
            } else {
                self.showAlert(message: "Đã xảy ra lỗi không xác định.")
                //alertView.message = "Đã xảy ra lỗi không xác định."
            }
            //hien thong bao alert
            //self.present(alertView, animated: true)
        }
    }
    func handleSignUp() throws {
        // khai bao
        var passwordText = ""
        var confirmPasswordText = ""
        var usernameText = ""
        //var emailText = ""
        // check username
        if let username = txtUserName.text, !username.isEmpty {
            usernameText = username
        } else {
            throw SignUpError.invalidUserName
        }

        // check email
       /* if let email = txtEmail.text, !email.isEmpty {
            emailText = email
        } else {
            throw SignUpError.invalidEmail
        }*/

        // check password
        if let password = txtPassword.text, !password.isEmpty {
            passwordText = password
        } else {
            throw SignUpError.invalidPassword
        }

        // check confirm password
        if let confirmPassword = txtConfirmPW.text, !confirmPassword.isEmpty {
            confirmPasswordText = confirmPassword
        } else {
            throw SignUpError.invalidPassword
        }

        // check if password matches
        if passwordText == confirmPasswordText {
            // tiếp tục xử lý
        } else {
            throw SignUpError.invalidPasswordNotMacth
        }

        // store to user defaults
        //Truong hop credentials da co san du lieu truoc do
        if let data = UserDefaults.standard.value(forKey: "user_credenticals") as? Data, let user_credenticals: [Users_Credentical] = try? PropertyListDecoder().decode(Array<Users_Credentical>.self, from: data){
                  var users = user_credenticals
                users.append(Users_Credentical(username: usernameText, password: passwordText))
                  let encodeData = try? PropertyListEncoder().encode(users)
                  UserDefaults.standard.set(encodeData, forKey: "user_credenticals")
                  //Dong man hinh Sign up sau khi dang ky thanh cong va quay ve man hinh Login
                  self.dismiss(animated: true)
                  print("success")
                  print(users)
              }
        //Truong hop credentials chua co du lieu truoc do
            else {
                let user_credentical = Users_Credentical(username: usernameText, password: passwordText)
                let encodeData = try? PropertyListEncoder().encode([user_credentical])
                UserDefaults.standard.set(encodeData, forKey: "user_credenticals")
                //throw SignUpError.noUser
                //Dong man hinh Sign up sau khi dang ky thanh cong va quay ve man hinh Login
                 self.dismiss(animated: true)
                 print("chua co du lieu truoc do thi insert moi")
                 print(user_credentical)
                }

        }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}
//Phan mo rong
/*extension UIViewController {
    func showAlert(title: String = "Error", message: String = "Some message", buttonTitle: String = "Close") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let close = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
        alert.addAction(close)
        self.present(alert, animated: true, completion: nil)
    }
}
*/

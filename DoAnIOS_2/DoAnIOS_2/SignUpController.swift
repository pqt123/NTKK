//
//  SignUpController.swift
//  DoAnIOS_2
//
//  Created by  User on 22.04.2025.
//

import UIKit

struct Credential: Codable {
    var username: String
    var email: String
    var password: String
}

enum SignUpError: Error {
    case invalidUserName
    case invalidEmail
    case invalidPassword
    case invalidPasswordNotMacth
    case noUser
    
    
    var localizedDescription: String {
        switch self {
        case .invalidUserName:
            return "Please enter vaild username"
        case .invalidEmail:
            return "Please enter vaild email"
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
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPW: UITextField!
    
    let alertView = UIAlertController(title: "Error", message: "some massage", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let closeAction = UIAlertAction(title: "Close", style: .default){
            (action) in
            self.alertView.dismiss(animated: true, completion: nil)
        }
        alertView.addAction(closeAction)
    }
    

    @IBAction func btnSignUpProcess(_ sender: UIButton) {
        do {
            try handleSignUp()
        } catch {
            let signupError = error as? SignUpError
            alertView.message = signupError?.localizedDescription
            self.present(alertView, animated: true, completion: nil)
        }
    }
    func handleSignUp() throws {
        // declare password and confirmPassword outside the if-let
        var passwordText = ""
        var confirmPasswordText = ""
        var usernameText = ""
        var emailText = ""
        // check username
        if let username = txtUserName.text, !username.isEmpty {
            usernameText = username
        } else {
            throw SignUpError.invalidUserName
        }

        // check email
        if let email = txtEmail.text, !email.isEmpty {
            emailText = email
        } else {
            throw SignUpError.invalidEmail
        }

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
        if let data = UserDefaults.standard.value(forKey: "credentials") as? Data, let credentials: [Credential]? = try? PropertyListDecoder().decode(Array<Credential>.self, from: data){
                 
                  var users = credentials
                  users?.append(Credential(username: usernameText, email: emailText, password: passwordText))
                  let encodeData = try? PropertyListEncoder().encode(users)
                  UserDefaults.standard.set(encodeData, forKey: "credentials")
                  
                  self.dismiss(animated: true, completion: nil)
                  print("success")
                  print(users)
              }
        //Truong hop credentials chua co du lieu truoc do
            else {
                let credential = Credential(username: usernameText, email: emailText, password: passwordText)
                let encodeData = try? PropertyListEncoder().encode([credential])
                UserDefaults.standard.set(encodeData, forKey: "credentials")
                //throw SignUpError.noUser
                //self.dismiss(animated: true, completion: nil)
                    print("chua co du lieu truoc do thi insert moi")
                    print(credential)
                    
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

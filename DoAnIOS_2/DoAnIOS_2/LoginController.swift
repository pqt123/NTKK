//
//  ViewController.swift
//  DoAnIOS_2
//
//  Created by  User on 22.04.2025.
//

import UIKit

enum LoginError: Error {
    case invalidUserName
    case invalidPassword
    case invalidAccountNoExit
    
    var localizedDescription: String {
        switch self {
        case .invalidUserName:
            return "Please enter valid username"
        case .invalidPassword:
            return "Please enter valid password"
        case .invalidAccountNoExit:
            return "Account no exit!"
        }
    }
}

class LoginController: UIViewController, UINavigationControllerDelegate
{
    
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var btnClearData: UIButton!
    
   /* let alertView = UIAlertController(title: "Error", message: "some massage", preferredStyle: .alert)*/
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
     /*   let closeAction = UIAlertAction(title: "Close", style: .default){
            (action) in
            self.alertView.dismiss(animated: true, completion: nil)
        }
        alertView.addAction(closeAction)*/
        
    }
    
    @IBAction func digitProcessing(_ sender: UIButton) {
        switch sender {
            case btnLogin:
                print("Login action")
                do {
                    try validataUsers()
                } catch {
                    /*let loginError = error as? LoginError
                    alertView.message = loginError?.localizedDescription
                    self.present(alertView, animated: true, completion: nil)
                    */
                    if let loginError = error as? LoginError {
                        //alertView.message = signupError.localizedDescription
                        self.showAlert(message: loginError.localizedDescription)
                    } else {
                        self.showAlert(message: "Đã xảy ra lỗi không xác định.")
                        //alertView.message = "Đã xảy ra lỗi không xác định."
                    }
                    
                    
                }
            
                // Gọi hàm Login
                
            case btnSignUp:
                print("signup action")
                // Gọi main singup
                goToSignUpView()
            case btnClearData:
                UserDefaults.standard.removeObject(forKey: "user_credenticals")
            default:
                break
            }
    }
    func validataUsers() throws {
        var passwordText = ""
        var usernameText = ""
        // check username email
        if let userName = txtUserName.text, !userName.isEmpty {
            usernameText = userName
        } else {
            throw LoginError.invalidUserName
        }
        //check password
        if let password = txtPassword.text, !password.isEmpty {
            passwordText = password
        } else {
            throw LoginError.invalidPassword
        }
        //data
        let data = UserDefaults.standard.value(forKey: "user_credenticals") as! Data
        
        if let users = try? PropertyListDecoder().decode(Array<Users_Credentical>.self, from: data) {
            
            let user_credentical = Users_Credentical (username: usernameText, password: passwordText)
            for user in users {
                
                if user.username == user_credentical.username, user.password == user_credentical.password {
                    goToHomeView()
                    break
                } else {
                    throw LoginError.invalidAccountNoExit
                }
                print(user)
            }
        }
        
         
        //end
    }
    func goToHomeView() {
        /*let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let newVC = storyboard.instantiateViewController(withIdentifier: "HomeViewControllerID") as? HomeViewController {
            self.present(newVC, animated: true, completion: nil)
            }*/
        let storyboardHome = UIStoryboard(name: "Main", bundle: nil)
            let homeVC = storyboardHome.instantiateViewController(withIdentifier: "HomeViewControllerID") as! HomeViewController
            //Kiem tra xem co navigationController neu co thi dung UINavigationController, neu khong co thi dung present
            if let nav = self.navigationController {
                nav.pushViewController(homeVC, animated: true)
            } else {
                homeVC.modalPresentationStyle = .fullScreen //dam bao full man hinh
                self.present(homeVC, animated: true)
            }
    }
    func goToSignUpView(){
        let storyboardSignUp = UIStoryboard(name: "Main", bundle: nil)
            let signUpVC = storyboardSignUp.instantiateViewController(withIdentifier: "SignUpControllerID") as! SignUpController
            //Kiem tra xem co navigationController neu co thi dung UINavigationController, neu khong co thi dung present
            if let nav = self.navigationController {
                nav.pushViewController(signUpVC, animated: true)
            } else {
                signUpVC.modalPresentationStyle = .fullScreen
                self.present(signUpVC, animated: true)
            }
    }
    //
}
//Phan mo rong
extension UIViewController {
    func showAlert(title: String = "Error", message: String = "Some message", buttonTitle: String = "Close") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let close = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
        alert.addAction(close)
        self.present(alert, animated: true)
    }
}

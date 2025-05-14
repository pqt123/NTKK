//
//  HomeViewController.swift
//  DoAnIOS_Product
//
//  Created by  User on 25.04.2025.
//

import UIKit

class HomeViewController: UIViewController {

    //Kieu du lieu class User
    var userLogin:User?
    
    @IBOutlet weak var userInfo: UILabel!
    
    private let ChangePasswordID = "ChangePasswordController"
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = userLogin{
            userInfo.text = user.user_nameuser
            print("User ID : \(user.user_id!) - \(user.user_nameuser)")
        }
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func goToChangePW(_ sender: UIButton) {
        let storyboardHome = UIStoryboard(name: "Main", bundle: nil)
        let changPasswordVC = storyboardHome.instantiateViewController(withIdentifier: ChangePasswordID) as! ChangePasswordController
        //Kiem tra xem co navigationController neu co thi dung UINavigationController, neu khong co thi dung present
            changPasswordVC.userLogin = userLogin //truyen du lieu user qua trang change Password
            self.present(changPasswordVC, animated: true)
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

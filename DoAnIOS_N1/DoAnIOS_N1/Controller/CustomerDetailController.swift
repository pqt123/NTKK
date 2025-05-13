//
//  CustomerDetailController.swift
//  DoAnIOS_N1
//
//  Created by  User on 13.05.2025.
//

import UIKit

class CustomerDetailController: UIViewController, UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    // MARK: Properties
    @IBOutlet weak var customerName: UITextField!
    @IBOutlet weak var customerPhone: UITextField!
    
    @IBOutlet weak var navigation: UINavigationItem!
    
    var txtcustomer_id:Int?
    // Dinh nghia bien customer dung de truyen tham so giua 2 man hinh A va B
    var customer:Customer?

    override func viewDidLoad() {
       super.viewDidLoad()
       // B3: Thuc hien uy quyen cho doi tuong TextField
        customerName.delegate = self
        customerPhone.delegate = self
       
       // Lay du lieu truyen sang tu man hinh TableView (Neu co)
       if let customer = customer {
           
           txtcustomer_id = customer.customer_id
           //check _id
           print("check ID : \(txtcustomer_id!)")
           navigation.title = customer.customer_name
           customerName.text = customer.customer_name
           customerPhone.text  = String(customer.customer_phone)
       }
       
    }

    // MARK: B2. Dinh nghia cac ham uy quyen cua TextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       // An ban phim
       customerName.resignFirstResponder()
       customerPhone.resignFirstResponder()
       return true
    }

    // Ham ket thuc qua trinh soan thao
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("\(customerName.text!) - sdt: \(customerPhone.text!)")
        //khai bao
        if let customername = customerName.text, customername.isEmpty{
            showAlert(message: "Vui long nhap ten khach hang")
        }
       /* var cust_phone = customerPhone.text?.trimmingCharacters(in: .whitespaces) ?? "" //Kiem tra khoang trong
        if !isValidVietnamesePhone(cust_phone){
            showAlert(message: "So dien thoai khong hop le")
        }*/

    }
    //Kiem tra so dien thoai Viet Nam hop le
    func isValidVietnamesePhone(_ phone: String) -> Bool {
        let phoneRegex = "^(0[3|5|7|8|9])+([0-9]{8})$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phone)
    }
    
    // MARK: Navigaion
    
      @IBAction func cancel(_ sender: UIBarButtonItem) {
       dismiss(animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //print("Tu dong goi truoc khi chuyen man hinh ve A")
        
        let customer_id = txtcustomer_id ?? 0
        let customer_name = customerName.text ?? ""
        let customer_phone = customerPhone.text ?? ""
        print("check cust_id : \(customer_id)")
        customer = Customer(customer_id: customer_id, customer_name: customer_name, customer_phone: customer_phone)
    }
    // MARK: - Hàm thông báo
    func showAlert(message: String) {
        if self.presentedViewController is UIAlertController {
            return // hoặc bạn có thể dismiss alert hiện tại trước
        }

        let alert = UIAlertController(title: "Thông báo", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }

    //End
    
}

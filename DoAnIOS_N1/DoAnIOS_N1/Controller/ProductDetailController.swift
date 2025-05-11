//
//  ViewController.swift
//  DoAnIOS_Product
//
//  Created by  User on 23.04.2025.
//

import UIKit


class ProductDetailController: UIViewController, UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    // MARK: Properties
    @IBOutlet weak var productName: UITextField!
    @IBOutlet weak var productQty: UITextField!
    @IBOutlet weak var productPrice: UITextField!
    @IBOutlet weak var productImageView: UIImageView!
    var txtProd_id:Int?
    // Dinh nghia bien product dung de truyen tham so giua 2 man hinh A va B
    var product:Product?

    override func viewDidLoad() {
       super.viewDidLoad()
       // B3: Thuc hien uy quyen cho doi tuong TextField
        productName.delegate = self
       
       // Lay du lieu truyen sang tu man hinh TableView (Neu co)
       if let product = product {
           
           txtProd_id = product.prod_id
           //check _id
           print("check ID : \(txtProd_id)")
          // navigation.title = product.prod_name
           productName.text = product.prod_name
           productQty.text  = String(product.prod_qty)
           productPrice.text = String(format: "%.2f", product.prod_price)
           productImageView.image = product.prod_image
       }
       
    }

    // MARK: B2. Dinh nghia cac ham uy quyen cua TextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       // An ban phim
       productName.resignFirstResponder()
       return true
    }

    // Ham ket thuc qua trinh soan thao
    func textFieldDidEndEditing(_ textField: UITextField) {
       print("\(productName.text!)")
    }

    // MARK: ImagePickerController
    // View ko co Action => bat su kien Action cho View
    @IBAction func imagePicker(_ sender: UITapGestureRecognizer) {
       // An ban phim
       productName.resignFirstResponder()
       
       // Khai bao 1 doi tuong UIImagePickerController
       let imagePicker = UIImagePickerController()
       
       // Cau hinh cho doi tuong imagePicker
       imagePicker.sourceType = .photoLibrary
       
       // Thuc hien uy quyen cho doi tuong ImagePickerController
       imagePicker.delegate = self
       
       // Chuyen man hinh
       present(imagePicker, animated: true)
    }

    // MARK: Dinh nghia ham uy quyen cua ImagePickerController
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
       dismiss(animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       // Lay anh tra ve tu ImagePicker
       if let image = info[.originalImage] {
           productImageView.image = image as? UIImage
       }
       
       // Quay lai man hinh truoc
       dismiss(animated: true)
    }

    // MARK: Navigaion
    
      @IBAction func cancel(_ sender: UIBarButtonItem) {
       dismiss(animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       //print("Tu dong goi truoc khi chuyen man hinh ve A")
        let prod_id = txtProd_id ?? 0
        let prod_name = productName.text ?? ""
        let prod_qty = Int(productQty.text ?? "0") ?? 0
        let prod_price = Double(productPrice.text ?? "0") ?? 0.0

        product = Product(prod_id:prod_id, prod_name: prod_name, prod_qty: prod_qty, prod_price: prod_price,  prod_image: productImageView.image)
    }
}

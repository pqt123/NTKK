//
//  ViewController.swift
//  FoodManagement2024
//
//  Created by  User on 15.04.2024.
//

import UIKit

// B1. Khai bao lop Delegate cho doi tuong
class MealDetailController: UIViewController, UITextFieldDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    // MARK: Properties
    @IBOutlet weak var mealName: UITextField!
    @IBOutlet weak var mealImageView: UIImageView!
    @IBOutlet weak var mealRating: UIRating!
    @IBOutlet weak var navigation: UINavigationItem!
    
    // Dinh nghia bien meal dung de truyen tham so giua 2 man hinh A va B
    var meal:Meal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // B3: Thuc hien uy quyen cho doi tuong TextField
        mealName.delegate = self
        
        // Lay du lieu truyen sang tu man hinh TableView (Neu co)
        if let meal = meal {
            navigation.title = meal.name
            mealName.text = meal.name
            mealImageView.image = meal.image
            mealRating.rating = meal.ratingValue
        }
        
    }

    // MARK: B2. Dinh nghia cac ham uy quyen cua TextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // An ban phim
        mealName.resignFirstResponder()
        return true
    }
    
    // Ham ket thuc qua trinh soan thao
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("\(mealName.text!)")
    }
    
    // MARK: ImagePickerController
    // View ko co Action => bat su kien Action cho View
    @IBAction func imagePicker(_ sender: UITapGestureRecognizer) {
        // An ban phim
        mealName.resignFirstResponder()
        
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
    /*func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }*/
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Lay anh tra ve tu ImagePicker
        if let image = info[.originalImage] {
            mealImageView.image = image as? UIImage
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
        let name = mealName.text ?? ""
        meal = Meal(name: name,  image: mealImageView.image ,ratingValue: mealRating.rating)
    }
}


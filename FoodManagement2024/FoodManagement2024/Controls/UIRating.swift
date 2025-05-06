//
//  UIRating.swift
//  FoodManagement2024
//
//  Created by  User on 20.04.2024.
//

import UIKit

class UIRating: UIStackView {
    // MARK: Properties
    private var ratingValue = 0
    private var ratingButtons = [UIButton]() // Array
    
    // Tao bien tinh toan
    var rating:Int {
        get {
            return ratingValue
        }
        
        set {
            ratingValue = newValue
            updateButtonState()
        }
    }
    
    // Dua thuoc tinh vao properties Control
    @IBInspectable private var numStarts:Int = 5 {
        // Apply value properties
        didSet {
            // Goi lai ham tao button
            ratingSetup()
        }
    }
    
    @IBInspectable private var btnSize:CGSize = CGSize(width: 44.0, height: 44.0) {
        // Apply value properties
        didSet {
            // Goi lai ham tao button
            ratingSetup()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        ratingSetup()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        ratingSetup()
    }
    
    // MARK: Xay dung ham doi tuong UIRating
    private func ratingSetup(){
        // Xoa nhung button da co
        // Vong lap for xoa tat ca rang buoc button
        for btn in ratingButtons {
            btn.removeFromSuperview() // Xoa rang buoc StackView (Root)
            removeArrangedSubview(btn) // Xoa rang buoc button
        }
        // Xoa cac ptu cua mang
        ratingButtons.removeAll()
        
        // Load anh tu file vao bien
        let normal = UIImage(named: "normal")
        
        let pressed = UIImage(named: "pressed")
        
        let selected = UIImage(named: "selected")
        
        // Xay dung 5 button
        for _ in 0..<numStarts {
           
            
            // Tao button
            let btnRating = UIButton()
            
            // Set Width, Height
            btnRating.heightAnchor.constraint(equalToConstant: btnSize.height).isActive = true
            btnRating.widthAnchor.constraint(equalToConstant: btnSize.width).isActive = true
            
            // Set Background => Dua anh vao btnRating
            //btnRating.backgroundColor = UIColor.red
            
            // Set Image
            btnRating.setImage(normal, for: .normal)
            btnRating.setImage(pressed, for: .highlighted)
            btnRating.setImage(selected, for: .selected)
        
            // Dua cac button vao trong mang ratingButtons
            // Cach 1: Dung append (noi 1 ptu)
            ratingButtons.append(btnRating)
            
            // Cach 2: Dung noi mang (noi cung luc nhieu ptu)
            //ratingButtons += [btnRating]
            
            // Bat su kien cho tung btnRating
            btnRating.addAction(UIAction(handler: {action in
                // Lay btn dang bam
                if let btn = action.sender as? UIButton {
                    // Lay so thu tu btn trong mang
                    let index = self.ratingButtons.firstIndex(of: btn)
                    //print("So thu tu: \(index!)")
                    
                    let newValue = index! + 1
                    
                    self.ratingValue = newValue == self.ratingValue ? newValue - 1 : newValue
                    
                    //print("Gia tri ratingValue: \(self.ratingValue)")
                    
                    // Cap nhat trang thai
                    self.updateButtonState()
                }
                
                
                
            }), for: .touchUpInside)
            
            // Dua cac button vao trong doi tuong StackView
            addArrangedSubview(btnRating) // Them cac button theo thu tu 0-4
        }
        
        // Cap Nhat Trang Thai
        updateButtonState()
    }
    
    // MARK: Ham cap nhat trang thai btn cho ratingButtons
    private func updateButtonState() {
        for (index, btn) in ratingButtons.enumerated() {
            btn.isSelected = index < ratingValue ? true:false
        }
    }
}

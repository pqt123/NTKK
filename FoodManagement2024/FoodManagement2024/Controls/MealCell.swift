//
//  MealCell.swift
//  FoodManagement2024
//
//  Created by  User on 06.05.2024.
//

import UIKit

class MealCell: UITableViewCell {
    
    // MARK: Properties
    @IBOutlet weak var mealImage: UIImageView!
    @IBOutlet weak var mealName: UILabel!
    @IBOutlet weak var rating: UIRating!
    
    
    // Bat su kien cho cell theo cach 1
    var onTap:UITapGestureRecognizer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if onTap != nil {
            onTap!.delegate = self
        }

        // Configure the view for the selected state
    }
   override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return (touch.view == self.contentView)
    }

}

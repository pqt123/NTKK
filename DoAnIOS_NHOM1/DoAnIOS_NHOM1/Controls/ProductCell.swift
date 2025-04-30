//
//  ProductCell.swift
//  DoAnIOS_NHOM1
//
//  Created by  User on 28.04.2025.
//

import UIKit

class ProductCell: UITableViewCell {
    // MARK: Properties
    
    @IBOutlet weak var productName: UITextField!
    @IBOutlet weak var productQty: UITextField!
    @IBOutlet weak var productPrice: UITextField!
    @IBOutlet weak var productImage: UIImageView!
    // Bat su kien cho cell theo cach 1
    
    var onTap:UITapGestureRecognizer?
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return (touch.view == self.contentView)
    }
}

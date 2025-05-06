//
//  ProductCell.swift
//  DoAnIOS_Product
//
//  Created by  User on 23.04.2025.
//

import UIKit

class ProductCell: UITableViewCell {
    
    // MARK: Properties
    //doi lai thanh UILabel
    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productQty: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    //storyboard InvoiceDetailController
    @IBOutlet weak var InvProductName: UILabel!
    
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

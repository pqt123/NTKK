//
//  CustomerCell.swift
//  DoAnIOS_Product
//
//  Created by  User on 07.05.2025.
//

import UIKit

class CustomerCell: UITableViewCell {

    
    @IBOutlet weak var customerInfo: UILabel!
    @IBOutlet weak var txtCustomerName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

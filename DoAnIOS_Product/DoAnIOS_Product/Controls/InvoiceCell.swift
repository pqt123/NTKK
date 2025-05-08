//
//  InvoiceCell.swift
//  DoAnIOS_Product
//
//  Created by  User on 07.05.2025.
//

import UIKit

class InvoiceCell: UITableViewCell {

    
    @IBOutlet weak var invDate: UILabel!
    @IBOutlet weak var invCustomer: UILabel!
    @IBOutlet weak var invTotal: UILabel!
    //storyboard InvoiceDetailController
    @IBOutlet weak var InvProductName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

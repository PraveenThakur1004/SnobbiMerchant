//
//  OrderDetailCell.swift
//  SnobbiMerchantSide
//
//  Created by jatin-pc on 9/12/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit

class OrderDetailCell: UITableViewCell {
//MARK- IBOutlet
    @IBOutlet weak var lbl_ItemName:UILabel!
    @IBOutlet weak var lbl_itemPrice:UILabel!
    @IBOutlet weak var lbl_itemQuantity:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func prepareForReuse() {
        lbl_ItemName.text = ""
        lbl_itemPrice.text = ""
        lbl_itemQuantity.text = ""
    }

}

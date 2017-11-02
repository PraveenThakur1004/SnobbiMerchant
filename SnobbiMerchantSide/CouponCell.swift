//
//  CouponCell.swift
//  SnobbiMerchantSide
//
//  Created by MAC on 12/10/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit

class CouponCell: UITableViewCell {
//MARK- IBOutlets
    @IBOutlet weak var lbl_CouponId: UILabel!
    @IBOutlet weak var  imageView_Stamp: UIImageView!
    @IBOutlet weak var lbl_CouponValidity: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  OrderCell.swift
//  SnobbiMerchantSide
//
//  Created by jatin-pc on 9/12/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit

class OrderCell: UITableViewCell {
    ////MARK:- IBOutlet
     @IBOutlet weak var  thumbnailImageView: UIImageView!
     @IBOutlet weak var  userEmailLabel: UILabel!
     @IBOutlet weak var  orderAddressLabel: UILabel!
     @IBOutlet weak var  numberOfItermLabel: UILabel!
     @IBOutlet weak var  pickUpTimeLabel: UILabel!
     @IBOutlet weak var  orderCostLable: UILabel!
     @IBOutlet weak var backgrounView: UIView!
    ////MARK:- IBInspectable
    @IBInspectable var userImage: UIImage? {
        didSet {
            thumbnailImageView.image = userImage
        }
    }
    @IBInspectable var email: String?
        {
        didSet{
        userEmailLabel.text = email
        }
    }
    @IBInspectable var address: String?
        {
        didSet{
            orderAddressLabel.text = address
        }
    }
    @IBInspectable var numberOfItems: String?
        {
        didSet{
            numberOfItermLabel.text = numberOfItems
        }
    }
    @IBInspectable var pickUpTime: String?
        {
        didSet{
            pickUpTimeLabel.text = pickUpTime
        }
    }
    @IBInspectable var cost: String?
        {
        didSet{
            orderCostLable.text = cost
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgrounView.layer.shadowOpacity = 0.7
        backgrounView.layer.shadowOffset = CGSize(width: 3, height: 3)
        backgrounView.layer.shadowRadius = 15.0
        backgrounView.layer.shadowColor = UIColor.darkGray.cgColor
        backgrounView.layer.cornerRadius = 8.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func prepareForReuse() {
        thumbnailImageView.image = nil
        userEmailLabel.text = ""
        orderCostLable.text = ""
        numberOfItermLabel.text = ""
        pickUpTimeLabel.text = ""
        
        
    }
}

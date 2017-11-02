//
//  ManageMenuCell.swift
//  SnobbiMerchantSide
//
//  Created by MAC on 05/10/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit

class ManageMenuCell: UITableViewCell {

    ////MARK:- IBOutlet
    @IBOutlet weak var  thumbnailImageView: UIImageView!
    @IBOutlet weak var  lbl_ItemPrice: UILabel!
    @IBOutlet weak var  lbl_ItemName: UILabel!
    @IBOutlet weak var  btn_Edit: SectionButton!
    @IBOutlet weak var  shadowView: UIView!
    ////MARK:- IBInspectable
    @IBInspectable var userImage: UIImage? {
        didSet {
            thumbnailImageView.image = userImage
        }
    }
    @IBInspectable var name: String?
        {
        didSet{
            lbl_ItemName.text = name
        }
    }
    @IBInspectable var price: String?
        {
        didSet{
            lbl_ItemPrice.text = price
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        shadowView.layer.shadowOpacity = 0.3
        shadowView.layer.shadowOffset = CGSize(width: 3, height: 3)
        shadowView.layer.shadowRadius = 10.0
        shadowView.layer.shadowColor = UIColor.lightGray.cgColor
        shadowView.layer.cornerRadius = 4.0
        btn_Edit.layer.cornerRadius = 8;
        btn_Edit.clipsToBounds = true;
        btn_Edit.layer.borderWidth = 1
        btn_Edit.layer.borderColor = UIColor.red.cgColor
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    override func prepareForReuse() {
      //  thumbnailImageView.image = nil
       // timeLabel.text = ""
      //  feedbackLabel.text = ""
       // userNameLabel.text = ""
    }
}

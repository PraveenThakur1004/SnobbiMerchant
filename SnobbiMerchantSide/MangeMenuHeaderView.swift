//
//  MangeMenuHeaderView.swift
//  SnobbiMerchantSide
//
//  Created by MAC on 05/10/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit
protocol MangaeMenuHeaderViewDelegate{
    func toggleSection(_ header: MangeMenuHeaderView, section: Int)
}
class MangeMenuHeaderView: UITableViewHeaderFooterView {
    var delegate: MangaeMenuHeaderViewDelegate?
    var section: Int = 0
    let titleLabel = UILabel()
    let arrowLabel = UILabel()
    let addButton = UIButton()
    let deleteButton = UIButton()
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        // Content View
        contentView.backgroundColor = UIColor.white
        let marginGuide = contentView.layoutMarginsGuide
        // Arrow label
        contentView.addSubview(arrowLabel)
        arrowLabel.textColor = UIColor.black
        arrowLabel.translatesAutoresizingMaskIntoConstraints = false
        arrowLabel.widthAnchor.constraint(equalToConstant: 12).isActive = true
        arrowLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        arrowLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        arrowLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        
        // Title label
        contentView.addSubview(titleLabel)
        titleLabel.textColor = UIColor.black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        
        //
        contentView.addSubview(addButton)
        addButton.setImage(UIImage(named:"addItem"), for: .normal)
       // addButton.backgroundColor = UIColor.black
        addButton.translatesAutoresizingMaskIntoConstraints = false
        let btnTrailing = NSLayoutConstraint.init(item: addButton, attribute: .trailing, relatedBy: .equal, toItem: arrowLabel, attribute: .leading, multiplier: 1, constant: 0)
        
        let centerYConstraint = NSLayoutConstraint.init(item: addButton, attribute: .centerY, relatedBy: .equal, toItem: arrowLabel, attribute: .centerY, multiplier: 1, constant: 0)
        //        let centerXConstraint = NSLayoutConstraint.init(item: label, attribute: .centerX, relatedBy: .equal, toItem: label.superview, attribute: .centerX, multiplier: 1, constant: -22)
        contentView.addConstraints([ centerYConstraint, btnTrailing])
        
        
        addButton.addConstraint(NSLayoutConstraint(item: addButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 44))
        addButton.addConstraint(NSLayoutConstraint(item: addButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 44))
        
        //
 
        contentView.addSubview(deleteButton)
        deleteButton.setImage(UIImage(named:"deletecategory"), for: .normal)
        // addButton.backgroundColor = UIColor.black
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        let deleteTrailing = NSLayoutConstraint.init(item: deleteButton, attribute: .trailing, relatedBy: .equal, toItem: addButton, attribute: .leading, multiplier: 1, constant: 0)
        
        let deletecenterYConstraint = NSLayoutConstraint.init(item: deleteButton, attribute: .centerY, relatedBy: .equal, toItem: addButton, attribute: .centerY, multiplier: 1, constant: 0)
       contentView.addConstraints([ deletecenterYConstraint, deleteTrailing])
        
        
        deleteButton.addConstraint(NSLayoutConstraint(item: deleteButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 44))
        deleteButton.addConstraint(NSLayoutConstraint(item: deleteButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 44))
        
        // Call tapHeader when tapping on this header
        //
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MangeMenuHeaderView.tapHeader(_:))))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //
    // Trigger toggle section when tapping on the header
    //
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: addButton))!{
            return false
        }
        if (touch.view?.isDescendant(of: deleteButton))!{
            return false
        }
        return true
    }
    func tapHeader(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let cell = gestureRecognizer.view as? MangeMenuHeaderView else {
            return
        }
        delegate?.toggleSection(self, section: cell.section)
    }
    
    func setCollapsed(_ collapsed: Bool) {
        //
        // Animate the arrow rotation (see Extensions.swf)
        //
        arrowLabel.rotate(collapsed ? 0.0 : .pi / 2)
    }
    
}




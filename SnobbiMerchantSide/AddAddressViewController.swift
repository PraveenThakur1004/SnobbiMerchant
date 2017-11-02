//
//  AddAddressViewController.swift
//  Snobbi
//
//  Created by MAC on 02/10/17.
//  Copyright © 2017 OSX. All rights reserved.
//

import UIKit
//Protocol to Updated address
protocol AddressAddedDelegate {
    func updateTable()
}
class AddAddressViewController: UIViewController {
    //MARK- IBOutlet
    @IBOutlet weak var scrollContentWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var country_TF: UITextField!
    @IBOutlet weak var state_TF: UITextField!
    @IBOutlet weak var city_TF: UITextField!
    @IBOutlet weak var address_TF: UITextField!
    @IBOutlet weak var street_TF: UITextField!
    @IBOutlet weak var zip_TF: UITextField!
    //MARK- ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollContentWidthConstraint.constant = view.frame.width
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Setup Navigation Bar
        self.navigationItem.setRightBarButton(nil, animated: true)
         self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.SetBackBarButtonCustom()
    }
    //MARK- Navigation Back Button
    func SetBackBarButtonCustom()
    {
       //Back buttion
        let btnLeftMenu: UIButton = UIButton()
        btnLeftMenu.setImage(UIImage(named: "leftback"), for: UIControlState())
        btnLeftMenu.addTarget(self, action: #selector(self.onClcikBack), for: UIControlEvents.touchUpInside)
        btnLeftMenu.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        let barButton = UIBarButtonItem(customView: btnLeftMenu)
        self.navigationItem.leftBarButtonItem = barButton
    }
    //Navigation back button action
    func onClcikBack()
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func Add(_ sender: UIButton) {
        
        if country_TF.text?.characters.count == 0 ||
            state_TF.text?.characters.count == 0 ||
            city_TF.text?.characters.count == 0 ||
            address_TF.text?.characters.count == 0 ||
            street_TF.text?.characters.count == 0 ||
            zip_TF.text?.characters.count == 0 {
            
        } else {
            
            if let country = country_TF.text,
                let state = state_TF.text,
                let city = city_TF.text,
                let address = address_TF.text,
                let street = street_TF.text,
                let zip = zip_TF.text {
                let params = ["user_id": "", "country": country, "state": state, "city": city, "address": address, "street_block": street, "zip_code": zip] as [String : Any]
                
                
            }
        }
    }
    @IBAction func Back(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}

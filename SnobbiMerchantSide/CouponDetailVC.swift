//
//  CouponDetailVC.swift
//  SnobbiMerchantSide
//
//  Created by MAC on 12/10/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit
import  FTIndicator
class CouponDetailVC: UIViewController {
    //MARK- IBoutlet
    @IBOutlet weak var  lbl_Name: UILabel!
    @IBOutlet weak var  lbl_Tax: UILabel!
    @IBOutlet weak var  tableView:UITableView!
    @IBOutlet weak var  btn_Redeem: UIButton!
    @IBOutlet weak var  lbl_CouponId: UILabel!
    @IBOutlet weak var  lbl_ValidUpto: UILabel!
    @IBOutlet weak var  lbl_NumberOfItems: UILabel!
    @IBOutlet weak var  lbl_Email: UILabel!
    @IBOutlet weak var  lbl_TotalCost: UILabel!
    var itemDict:NSDictionary?
    var fromSegment:String?
    var itemlist = [NSDictionary]()
    let wsManager = WebserviceManager()
    let kCellReuseIdentifier = "OrderDetailCell"
    //MARK- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    func setUpView(){
       let user = itemDict?.object(forKey: "Friend") as! NSDictionary
        let orderData = itemDict?.object(forKey: "Order") as? NSDictionary
        
        if let values = orderData?.object(forKey: "items_data") as? [NSDictionary]{
            itemlist = values
            if itemlist.count>0{
                print("the item list is \(itemlist)")
                self.tableView.reloadData()
            }
        }
        
        lbl_Name.text = user.object(forKey: "name") as? String
        lbl_CouponId.text = orderData?.object(forKey: "coupon_code") as? String
        lbl_Email.text = user.object(forKey: "email") as? String
        lbl_NumberOfItems.text = user.object(forKey: "address") as! String 
        lbl_ValidUpto.text = "Valid upto: \(Utils.numberOfDaysLeft(oldDate: orderData?.object(forKey: "created") as! String)) days"
        lbl_TotalCost.text = "$\(String(describing: orderData?.object(forKey: "total_amount") as! String))"
        let resturant = itemDict?.object(forKey: "Restaurant") as? NSDictionary
        var tax = ""
        if let value = resturant?.object(forKey: "tax")
            as? String{
            tax = value
           }
         lbl_Tax.text = tax
    
    
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated);
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //MARK:- Setting Up view for recent order detail
        //Set as recent order detail
        if fromSegment == "Redeemed"{
            btn_Redeem.isUserInteractionEnabled = false
            btn_Redeem.setTitle("REDEEMED", for: .normal)
            btn_Redeem.alpha = 0.8
            self.navigationItem.setRightBarButton(nil, animated: true)
            tableView.allowsSelection = false
        }
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
    
    @IBAction func redeemCoupon(_ sender: UIButton){
        FTIndicator.showProgress(withMessage: "loading..")
        let orderData = itemDict?.object(forKey: "Order") as? NSDictionary
        print("this is my order\(itemDict)")
        let  orderId =  orderData?.object(forKey: "id") as? String
        wsManager.changeCouponStatus(order_id: orderId!, completionHandler:{(sucess,message)-> Void in
            if sucess{
                FTIndicator.dismissProgress()
                FTIndicator.showToastMessage(message)
                self.onClcikBack()
                
                }
            else{
                FTIndicator.dismissProgress()
                FTIndicator.showToastMessage(message)
            }
        })
        FTIndicator.dismissProgress()
    }
    
@IBAction func actionCall(_ sender: UIButton) {
    let user = itemDict?.object(forKey: "Friend") as! NSDictionary
    if let phone = user.object(forKey: "phone") as? String{
        makeCall(urlString:phone)
    }
    }
    func makeCall(urlString: String){
        guard let url = URL(string: "telprompt://" + urlString) else {
            FTIndicator.showToastMessage("Unable to make call")
            return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    }


/*
 Extention
 */


extension CouponDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellReuseIdentifier, for: indexPath) as! OrderDetailCell
        let itemData = itemlist[(indexPath as NSIndexPath).row]
        print("the item data is \(itemData)")
        let item = itemData.object(forKey: "Item") as? NSDictionary
        print ("the item is \(item)" )
        cell.lbl_ItemName.text = item?.object(forKey: "name") as? String
        print(item?.object(forKey: "price") as? String ?? "")
       cell.lbl_itemPrice.text = "$\(String(describing: item?.object(forKey: "price") as! String))"
        cell.lbl_itemQuantity.text = item?.object(forKey: "quantity") as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        
    }
}

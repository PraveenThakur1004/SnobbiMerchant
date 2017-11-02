//
//  ManageCoupon_VC.swift
//  SnobbiMerchantSide
//
//  Created by MAC on 12/10/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit
import InteractiveSideMenu
import  FTIndicator
class ManageCoupon_VC: UIViewController,SideMenuItemContent {
    //MARK- IBOutlet
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var view_NoData:UIView!
    @IBOutlet weak var tableView: UITableView!
    var itemArray = [NSDictionary]()
    var selectedItemDict = NSDictionary()
    let wsManager = WebserviceManager()
    var selectedIndex = "0"
    let kCellReuseIdentifier = "CouponCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view_NoData.frame = CGRect(x: 0, y:104, width: self.view.frame.size.width, height: self.view.frame.size.height-104)
            self.view.addSubview(self.view_NoData)
        self.view.bringSubview(toFront: self.view_NoData)

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // select the first segment
        segmentControl.selectedSegmentIndex = 0;
        self.action_SegmentChanged(segmentControl)
        self.navigationController?.setNavigationBarHidden(true, animated: animated);
    }
    func getallCoupons(_ withCoupon_Id:String){
        FTIndicator.showProgress(withMessage: "loading..")
        wsManager.getAllCoupons(counpon_Status: withCoupon_Id, completionHandler:{(sucess,items,message)-> Void in
            if sucess{
                FTIndicator.dismissProgress()
                if (items.isEmpty){
                    self.view.addSubview(self.view_NoData)
                                    // FTIndicator.showToastMessage("No data found")
                }
                else{
                    self.view_NoData.removeFromSuperview()
                    self.itemArray = items.reversed()
                    self.tableView.reloadData()
                }
            }
            else{
                FTIndicator.dismissProgress()
                self.view.addSubview(self.view_NoData)
               // FTIndicator.showToastMessage(message)
            }
        })
        FTIndicator.dismissProgress()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK- Action
    @IBAction func openMenu(_ sender: UIButton) {
        showSideMenu()
    }
       @IBAction func action_SegmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
             selectedIndex = "0"
             itemArray = [NSDictionary]()
            self.tableView.reloadData()
             getallCoupons("2")
        case 1:
             selectedIndex = "1"
             itemArray = [NSDictionary]()
             self.tableView.reloadData()
            getallCoupons("1")
        default:
            break
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueShowDetail" {
            let vc = segue.destination as! CouponDetailVC
            vc.itemDict = selectedItemDict
           if selectedIndex == "1"{
                vc.fromSegment = "Redeemed"
            }
           
        }
    }
}
extension ManageCoupon_VC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellReuseIdentifier, for: indexPath) as! CouponCell
        let item = itemArray[(indexPath as NSIndexPath).row]
        let orderData = item.object(forKey: "Order") as? NSDictionary
        
        cell.lbl_CouponId.text = orderData?.object(forKey: "coupon_code") as? String
        if selectedIndex == "0"{
        cell.lbl_CouponValidity.text = "Time remaining to redeem: \(Utils.numberOfDaysLeft(oldDate: orderData?.object(forKey: "created") as! String)) days"
        cell.imageView_Stamp.image = UIImage(named: "stampprivate")
        cell.lbl_CouponValidity.textColor = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1)
        }
        else{
            cell.lbl_CouponValidity.text = "Redeemed"
            cell.imageView_Stamp.image = UIImage(named: "stampredeemed")
            cell.lbl_CouponValidity.textColor = UIColor.red
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
       let item = itemArray[(indexPath as NSIndexPath).row]
        selectedItemDict = item as NSDictionary
        print("the selected item is \(item)")
        print ("the selectd item is \(selectedItemDict)")
        self.performSegue(withIdentifier: "segueShowDetail", sender: self)
    
    }
}

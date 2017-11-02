//
//  SubsettingVC.swift
//  SnobbiMerchantSide
//
//  Created by MAC on 15/09/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import  UIKit
import  FTIndicator
class SubsettingVC: UIViewController {
    //MARK - IBOutlet
    @IBOutlet weak var textView: UITextView!
    //MARK- Constant and Variables
    var wsManger = WebserviceManager()
    //MARK- ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
       }
    
override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated);
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.SetBackBarButtonCustom()
        //getData
        if self.title == "About Us"{
            self.title = "About Us"
            self.aboutUs()
        }else{
            self.privacyPolicy()
            self.title = "Privacy Policy"
        }
        
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
    //Get Data from Server
    func  aboutUs(){
        FTIndicator.showProgress(withMessage: "loading..")
        wsManger.aboutUs(completionHandler: {(sucess,data,message)->
            Void in
             FTIndicator.dismissProgress()
             if sucess{
               self.textView.text = data.object(forKey: "info") as! String
            }
            else{
                FTIndicator.showError(withMessage: message)
            }
        
        })
    }
    //Get Data from Server
    func  privacyPolicy(){
        FTIndicator.showProgress(withMessage: "loading..")
        wsManger.getprivacy(completionHandler: {(sucess,data,message)->
            Void in
            FTIndicator.dismissProgress()
            if sucess{
                self.textView.text = data.object(forKey: "info") as! String
            }
            else{
                FTIndicator.showError(withMessage: message)
            }
            
        })
    }
    
}

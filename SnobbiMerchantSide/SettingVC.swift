//
//  SettingVC.swift
//  SnobbiMerchantSide
//
//  Created by jatin-pc on 9/12/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit
import AARatingBar
import InteractiveSideMenu
import FTIndicator
import MessageUI
class SettingVC: UIViewController,SideMenuItemContent {
    //MARK:-IBOutlet
  //SupportView
    @IBOutlet weak var textViewSupport:UITextView!
    @IBOutlet weak var supportDecendentView: UIView!
    @IBOutlet weak var supportView: UIView!
    var activeTextView: UITextView?
    var wsManager = WebserviceManager()
    let composeVC = MFMailComposeViewController()
    var emailAdmin:String?
    var phoneNumberAdmin:String?
    //MARK:- ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerForKeyboardNotifications()
      
        
       }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.deregisterFromKeyboardNotifications()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated);
        self.getHelp()
        
    }
    //MARK- Keyboard Notifications
    func registerForKeyboardNotifications(){
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deregisterFromKeyboardNotifications(){
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    func keyboardWasShown(notification: NSNotification){
        let keyboardSize = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        var aRect : CGRect = self.view.frame
       if let activeTextview = self.activeTextView{
            
            aRect.size.height -= (keyboardSize.height + (activeTextview.frame.size.height))
            let frame = activeTextview.frame.origin
            if (!aRect.contains(frame)){
                self.view.frame.origin.y -= (activeTextview.frame.origin.y - aRect.size.height)
                
            }
            
            
        }
    }
    
    func keyboardWillBeHidden(notification: NSNotification){
        //Once keyboard disappears, restore original positions
        self.view.frame.origin.y = 0
        self.view.endEditing(true)
        
    }
    func getHelp(){
        wsManager.getHelp(completionHandler: {(sucess,data,message) -> Void in
            if sucess {
                self.emailAdmin = ""
                self.phoneNumberAdmin = ""
                if let email = data?.object(forKey: "email") as? String{
                    self.emailAdmin = email
                }
                if let phone = data?.object(forKey: "phone") as? String{
                  self.phoneNumberAdmin = phone
               }
            }
        })
    }
    //Setup properties next viewcontroller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueAboutUs" {
            if let viewController = segue.destination as? SubsettingVC {
                viewController.title = "About Us"
            }
        }
        else if segue.identifier == "seguePrivacyPolicy"{
            if let viewController = segue.destination as? SubsettingVC{
                viewController.title = "Privacy Policy"
            }
        }
    }
    /* Show side menu on menu button click
     */
    @IBAction func openMenu(_ sender: UIButton) {
        showSideMenu()
    }
    //MARK:- Actions
    //Show different view's base on selection
    @IBAction func action_Btn(_ sender: UIButton) {
        
        switch sender.tag {
        case 100:
            self.showSupportView()
       case 102:
            performSegue(withIdentifier: "seguePrivacyPolicy", sender: self)
        case 103:
            performSegue(withIdentifier: "segueAboutUs", sender: self)
       
        default:
            print("default")
        }
    }
    //Hide support view
    @IBAction func hideSupportView(_ sender: UITapGestureRecognizer) {
        self.supportView.removeFromSuperview()
    }
    //Action of support view
    @IBAction func actionSupport(_ sender: UIButton) {
        switch sender.tag {
        case 101:
            if textViewSupport.text.isEmpty{
            FTIndicator.showToastMessage("Please type your message first")
                return
            
            }
            if emailAdmin != "" || emailAdmin  != nil {
                if !MFMailComposeViewController.canSendMail() {
                    print("Mail services are not available")
                    return
                }
                sendEmail()            }
            else{
                FTIndicator.showToastMessage("Unable to send mail")
            }
            self.supportView.removeFromSuperview()
        case 102:
            if phoneNumberAdmin != "" || phoneNumberAdmin != nil {
                self.makeCall(urlString:phoneNumberAdmin! )
            }
            else{
                FTIndicator.showToastMessage("Unable to connect")
            }
            
        default:
            print("default")
        }
        self.supportView.removeFromSuperview()
    }
    
   
    
}
/*
 Extention
 */
//MARK:- UIGestureViewDelegates
extension SettingVC: UIGestureRecognizerDelegate
{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
      if (touch.view?.isDescendant(of: supportDecendentView))!{
            return false
        }
        return true
    }
}

//
//  ChangePasswordVC.swift
//  SnobbiMerchantSide
//
//  Created by MAC on 18/09/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit
import FTIndicator
class ChangePasswordVC: UIViewController {
    //MARK- IBOutlet's
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    //MARK- Variable and Constants
    var textFields: NSArray!
    var iconPassClick : Bool!
    var iconOldPassword : Bool!
    var iconConfirmPassClick : Bool!
    let wsManager = WebserviceManager()
    var activeField: UITextField?
    //MARK- ViewLifeCyle
    override func viewDidLoad() {
        super.viewDidLoad()
        //Boolen for textField secure entry
        iconPassClick = false
        iconOldPassword = false
        iconConfirmPassClick = false
        //TextField's array
        self.textFields = [self.oldPasswordTextField, self.newPasswordTextField, self.confirmPasswordTextField];
        self.registerForKeyboardNotifications()
    }
  override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    //Hide NavigationBar
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.deregisterFromKeyboardNotifications()
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
        
if let activeField = self.activeField {
             aRect.size.height -= (keyboardSize.height + (activeField.superview?.frame.size.height)!)
            let frame = self.view.convert(activeField.frame.origin, from: activeField.superview)
            if (!aRect.contains(frame)){
                self.view.frame.origin.y -= (activeField.frame.size.height)
                
            }
        }
    }
    
    func keyboardWillBeHidden(notification: NSNotification){
        //Once keyboard disappears, restore original positions
        self.view.frame.origin.y = 0
        self.view.endEditing(true)
        
    }
    //MARK- IBAction's
    //TextField set secure and unsecure text entry
    @IBAction func checkAction(_ sender: UIButton) {
        // Instead of specifying each button we are just using the sender (button that invoked) the method
        switch sender.tag {
        case 100:
            if ( iconOldPassword == false)
            {
                sender.setImage(UIImage(named: "eyeopned"), for: .normal)
                iconOldPassword = true
                oldPasswordTextField.isSecureTextEntry = false
            }
            else
            {
                sender.setImage(UIImage(named: "eyeclosed"), for: .normal)
                iconOldPassword = false
                oldPasswordTextField.isSecureTextEntry = true
            }
        case 101:
            if ( iconPassClick == false)
            {
                sender.setImage(UIImage(named: "eyeopned"), for: .normal)
                iconPassClick = true
                newPasswordTextField.isSecureTextEntry = false
            }
            else
            {
                sender.setImage(UIImage(named: "eyeclosed"), for: .normal)
                iconPassClick = false
                newPasswordTextField.isSecureTextEntry = true
            }
        case 102:
            if ( iconConfirmPassClick == false)
            {
                sender.setImage(UIImage(named: "eyeopned"), for: .normal)
                iconConfirmPassClick = true
                confirmPasswordTextField.isSecureTextEntry = false
            }
            else
            {
                sender.setImage(UIImage(named: "eyeclosed"), for: .normal)
                iconConfirmPassClick = false
                confirmPasswordTextField.isSecureTextEntry = true
            }
        default:
            break
        }
    }
    //Change Password
    @IBAction func actionChangePassword(_ sender: UIButton){
        for textField in self.textFields as! [UITextField]
        {
            
            if(textField == self.oldPasswordTextField){
                if (oldPasswordTextField.text?.isEmpty)! {
                    FTIndicator.showToastMessage("Please Enter  old password")
                    return
                }
            }
            if(textField == self.newPasswordTextField){
                if (newPasswordTextField.text?.isEmpty)! {
                    FTIndicator.showToastMessage("Please Enter  new password")
                    return
                }
                    
                else{
                    if((textField.text?.characters.count)! < 6){
                        FTIndicator.showToastMessage("Password is not long enough")
                        return
                    }
                }
            }
            if(textField == self.confirmPasswordTextField){
                if(self.newPasswordTextField.text != self.confirmPasswordTextField.text){
                    FTIndicator.showToastMessage("Confirm password mismatch")
                    return
                }
            }
            
        }
        self.changePassword(oldPassword: self.oldPasswordTextField.text, newPassword: self.newPasswordTextField.text)
        
    }
    func changePassword(oldPassword:String?, newPassword:String?){
        FTIndicator.showProgress(withMessage: "Requesting..")
        wsManager.changePassword(oldPassword!,newPassword!, completionHandler:{(sucess,message)-> Void in
            if sucess{
                FTIndicator.dismissProgress()
                self.dismiss(animated: false, completion: nil)
                FTIndicator.showToastMessage(message)
                
            }
            else{
                FTIndicator.dismissProgress()
                FTIndicator.showToastMessage(message)
            }
        })
    }
    
    //MARK- Delegate
    //Text
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if self.view.frame.origin.y<0{
            self.view.frame.origin.y = 0}
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        activeField = nil
    }
    func textFieldShouldEndEditing(_ _textField: UITextField) -> Bool
    {
        return true;
    }
    func textFieldShouldReturn(_ _textField: UITextField) -> Bool {
        let index = self.textFields.index(of: _textField)
        if (self.textFields.count > index+1) {
            let nextField = self.textFields.object(at: index+1) as! UITextField;
            nextField.becomeFirstResponder();
        }else{
            self.navigationItem.rightBarButtonItem = nil;
            _textField.resignFirstResponder();
        }
        return true;
    }
    func textField(_ _textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true;
    }
    
    
    @IBAction func actionDismissPresent(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
        
    }
}

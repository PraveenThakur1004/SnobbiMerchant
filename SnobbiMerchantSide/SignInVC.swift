//
//  SignInVC.swift
//  SnobbiMerchantSide
//
//  Created by jatin-pc on 9/12/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit
import FTIndicator
class SignInVC: UIViewController {
    //IBoutlet
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    //MARK:- Variables and Constants
    let wsManager = WebserviceManager()
    let textValidationManager = TextFieldValidationsManager()
    let alertControlerManager = AlertControllerManager()
    var activeField: UITextField?
    //MARK- ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO:-Delete
        self.userNameTextField.text = "nrj201@yopmail.com"
        self.passwordTextField.text = "123456"
        //Keyboard notifications
        self.registerForKeyboardNotifications()
      
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    
    
    //MARK- IBAction
    @IBAction func loginToSnobbi(_ sender: UIButton) {
        let userTexFieldState = textValidationManager.isContentValid(userNameTextField.text!)
        let passwordTexFieldState = textValidationManager.isContentValid(passwordTextField.text!)
        if userTexFieldState == TextFieldValidationResult.ok && passwordTexFieldState == TextFieldValidationResult.ok {
            FTIndicator.showProgress(withMessage: "loading...")
            wsManager.login(userNameTextField.text!, password: passwordTextField.text!) { (user, success, message: String?) -> Void in
                
                if success {
                    FTIndicator.dismissProgress()
                    Singleton.sharedInstance.user = nil
                    Singleton.sharedInstance.user = user
                    UserDefaults.standard.set(self.userNameTextField.text, forKey: "user_email")
                    
                    let dictUser = user?.asDictionary()
                    UserDefaults.standard.set(dictUser, forKey: "user")
                    UserDefaults.standard.synchronize()
                    DispatchQueue.main.async(execute: { () -> Void in
                        //MARK MARK MARK
                        self.performSegue(withIdentifier: "showMenuViews", sender: nil);
                        
                        
                    });
                } else {
                    FTIndicator.dismissProgress()
                    DispatchQueue.main.async(execute: { () -> Void in
                        var msg: String
                        if let message = message {
                            msg = message
                            self.present(self.alertControlerManager.alertForServerError("Login info", errorMessage: msg), animated: true, completion: nil)
                        } else {
                            self.present(self.alertControlerManager.alertForServerError("Login info", errorMessage: "Something went wrong. Please try again"), animated: true, completion: nil)
                        }
                    });
                }
            }
            
            
        } else {
            let requiredMessage : String = Constants.errorMessages.upRequired
            if userTexFieldState == TextFieldValidationResult.empty {
                self.present(alertControlerManager.alertForEmptyTextField(requiredMessage), animated: true, completion: nil)
                return;
            }
            if passwordTexFieldState == TextFieldValidationResult.empty {
                self.present(alertControlerManager.alertForEmptyTextField(requiredMessage), animated: true, completion: nil)
                return;
            }
            if userTexFieldState == TextFieldValidationResult.not_MINIMUM {
                self.present(alertControlerManager.alertForLessThanMinCharacters(Constants.errorMessages.shortName), animated: true, completion: nil)
                return;
            }
            if passwordTexFieldState == TextFieldValidationResult.not_MINIMUM {
                self.present(alertControlerManager.alertForLessThanMinCharacters(Constants.errorMessages.shortPassword), animated: true, completion: nil)
                return;
            }
            if userTexFieldState == TextFieldValidationResult.not_MAXIMUM {
                self.present(alertControlerManager.alertForMaxCharacters(Constants.errorMessages.longName), animated: true, completion: nil)
                return;
            }
            if passwordTexFieldState == TextFieldValidationResult.not_MAXIMUM {
                self.present(alertControlerManager.alertForMaxCharacters(Constants.errorMessages.longPassword), animated: true, completion: nil)
                return;
            }
        }
    }
    
}
//MARK:- textField Delegates
extension SignInVC: UITextFieldDelegate {
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == userNameTextField){
            passwordTextField.becomeFirstResponder();
        }else{
            textField.resignFirstResponder();
       }
        textField.borderStyle = UITextBorderStyle.none
        return true
    }
}

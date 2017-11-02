//
//  ForgetPasswordVC.swift
//  SnobbiMerchantSide
//
//  Created by jatin-pc on 9/12/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit
import FTIndicator
class ForgetPasswordVC: UIViewController {
    //IBoutlet
    @IBOutlet weak var emailTextField:UITextField!
    //MARK:- Variables and Constants
    let wsManager = WebserviceManager()
    let textValidationManager = TextFieldValidationsManager()
    let alertControlerManager = AlertControllerManager()
    //MARK- ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //SetUp NavigationBar
     
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Hide NavigationBar
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.navigationBar.tintColor = UIColor.red
        self.navigationController?.navigationBar.topItem?.title = "FORGET PASSWORD"
        //Set NavigationBar transparent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        //navigationBar title color
        let textAttributes = [NSForegroundColorAttributeName:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.SetBackBarButtonCustom()
    }
    //MARK- Navigation Back Button
    func SetBackBarButtonCustom()
    {
        //Back buttion
        let btnLeftMenu: UIButton = UIButton()
        btnLeftMenu.setImage(UIImage(named: "whiteback"), for: UIControlState())
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
    //MARK- IBAction
    @IBAction func actionFogotPassword(_ sender: Any) {
        let forgotPasswordEmailString = emailTextField.text!
        
        if self.textValidationManager.isContentValid(forgotPasswordEmailString) == .ok {
            if self.textValidationManager.isValidEmail(forgotPasswordEmailString) == true {
                FTIndicator.showProgress(withMessage: "loading....")
                 self.wsManager.forgotPassword(forgotPasswordEmailString, completionHandler: { (success, message: String?) -> Void in
                    if success {
                        FTIndicator.dismissProgress()
                        DispatchQueue.main.async(execute: { () -> Void in
                            self.present(self.alertControlerManager.alertForServerError("Forgot password info", errorMessage: message!), animated: true, completion: nil)
                        })
                    } else {
                        FTIndicator.dismissProgress()
                        DispatchQueue.main.async(execute: { () -> Void in
                            if let message = message {
                                self.present(self.alertControlerManager.alertForServerError("Forgot password info", errorMessage: message), animated: true, completion: nil)
                            } else {
                                self.present(self.alertControlerManager.alertForServerError("Forgot password info", errorMessage: "Something went wrong. Please try again"), animated: true, completion: nil)
                            }
                        });
                    }
                })
                
            } else {
                let alert =  self.alertControlerManager.alertForCustomMessage("Forgot password info", errorMessage: "Please enter your email in the format someone@example.com", handler: { (AA:UIAlertAction!) -> Void in
                    
                })
                self.present( alert, animated: true, completion:nil)
            }
        } else {
            var errorMessageString = " "
            if self.textValidationManager.isContentValid(forgotPasswordEmailString) == .empty {
                errorMessageString = self.textValidationManager.errorMessageForIssueInTextField("empty",texfieldName:"Forgot password info")
            } else if self.textValidationManager.isContentValid(forgotPasswordEmailString) == .not_MINIMUM {
                errorMessageString = self.textValidationManager.errorMessageForIssueInTextField("minlength",texfieldName:"Forgot password info")
            } else if self.textValidationManager.isContentValid(forgotPasswordEmailString) == .not_MAXIMUM {
                errorMessageString = self.textValidationManager.errorMessageForIssueInTextField("maxlength",texfieldName:"Forgot password info")
            }
            let alert =  self.alertControlerManager.alertForCustomMessage("", errorMessage: errorMessageString, handler: { (AA:UIAlertAction!) -> Void in
                
            })
            self.present( alert, animated: true, completion:nil)
        }
        
    }
}
//MARK:- textField and almofire parameter endcoding
extension ForgetPasswordVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        textField.borderStyle = UITextBorderStyle.none
        return true
    }
}


//
//  ProfileVC.swift
//  SnobbiMerchantSide
//
//  Created by jatin-pc on 9/12/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import  UIKit
import  AVFoundation
import  Photos
import  FTIndicator
import  InteractiveSideMenu
import  Kingfisher
import MapKit

class ProfileVC: UIViewController, SideMenuItemContent {
    //MARK:- IBoutlet
   
    @IBOutlet weak var view_Blurr:UIView!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var imageView_Large:UIImageView!
    @IBOutlet weak var txtField_Name: UITextField!
    @IBOutlet weak var txtField_PhoneNumber: UITextField!
    @IBOutlet weak var txtField_Adress: UITextField!
    @IBOutlet weak var textView_Description:UITextView!
    @IBOutlet weak var searchResultsTableView:UITableView!
    //MARK- Variables
    let wsManager = WebserviceManager()
    var searchString:String?
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    var picker:UIImagePickerController?=UIImagePickerController()
    var user:Restaurant!
    var textFields  : NSArray!
    var boolEditStatus: Bool = false
    var boolEdit: Bool = false
    var selectedImage:UIImage?
    var boolEditImage: Bool = false
    var activeField:UITextField?
    var activeTextView: UITextView?
    var lat:String?
    var longi:String?
    //MARK:- ViewLifeCyle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lat = Singleton.sharedInstance.user.lat
        self.longi = Singleton.sharedInstance.user.longi
        searchResultsTableView.layer.borderWidth = 2.0
        searchResultsTableView.layer.borderColor = UIColor.black.cgColor
        searchCompleter.delegate = self
        self.textFields = [self.txtField_PhoneNumber, self.txtField_Name];
       self.txtField_Name.setLeftPaddingPoints(10)
       self.txtField_PhoneNumber.setLeftPaddingPoints(10)
       self.txtField_Adress.setLeftPaddingPoints(10)
        view_Blurr.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        self.unEditableView()
        self.registerForKeyboardNotifications()
        // Do any additional setup after loading the view.
    }
   override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: animated);
          searchResultsTableView.isHidden = true
        
    }
    override func viewWillDisappear(_ animated: Bool) {
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
            aRect.size.height -= (keyboardSize.height + (activeField.frame.size.height))
            let frame = activeField.frame.origin
            if (!aRect.contains(frame)){
                self.view.frame.origin.y -= (activeField.frame.origin.y - aRect.size.height)
                if activeField == txtField_Adress
                {
                self.searchResultsTableView.frame.origin.y = ((activeField.frame.origin.y + 20)  - aRect.size.height)
                    self.searchResultsTableView.frame.size.height -= 20
                
                }
                
            }
        }
        
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
   //setUpSimpleView
    func unEditableView(){
        boolEditStatus = false
        self.btnEdit.setImage(UIImage(named: "navEdit"), for: .normal)
        
        self.txtField_Name.text = Singleton.sharedInstance.user.firstName
        self.textView_Description.text = Singleton.sharedInstance.user.descriptionApp
        self.txtField_Adress.text = Singleton.sharedInstance.user.address
        self.txtField_PhoneNumber.text = Singleton.sharedInstance.user.phoneNumber
        let largeImageUrl = URL(string:Singleton.sharedInstance.user.imageurlStr!)
       self.imageView_Large.kf.setImage(with:largeImageUrl, placeholder: UIImage(named:"placeholderImage"), options: nil, progressBlock: nil,  completionHandler: { image, error, cacheType, imageURL in
        if error == nil{
            self.selectedImage = image
        }
        else{
            self.selectedImage = UIImage(named:"placeholderImage")
        }
       })
       //Intraction of views
        txtField_PhoneNumber.layer.borderWidth = 0.0
        txtField_Name.layer.borderWidth = 0.0
        textView_Description.layer.borderWidth = 0.0
        txtField_Adress.layer.borderWidth = 0.0
        txtField_Name.backgroundColor = UIColor.clear
        txtField_PhoneNumber.backgroundColor = UIColor.clear
        imageView_Large.isUserInteractionEnabled = false
         txtField_Name.isEnabled = false
        textView_Description.isEditable = false
        textView_Description.isSelectable = false
        txtField_PhoneNumber.isEnabled = false
        txtField_Adress.isEnabled = false
        
        
        
    }
    //setUpEditableView
    func editableView(){
        //Intraction of views
        self.btnEdit.setImage(UIImage(named: "editprofile"), for: .normal)
        let myColor = UIColor.white
        let blackColor = UIColor.black
        txtField_Name.layer.borderColor = myColor.cgColor
        txtField_PhoneNumber.layer.borderColor = myColor.cgColor
        txtField_Adress.layer.borderColor = blackColor.cgColor
        textView_Description.layer.borderColor = blackColor.cgColor
        txtField_Name.layer.borderWidth = 1.0
        txtField_PhoneNumber.layer.borderWidth = 1.0
        txtField_Adress.layer.borderWidth = 1.0
        textView_Description.layer.borderWidth = 1.0
        
        imageView_Large.isUserInteractionEnabled = true
        txtField_Name.isSelected = true
        txtField_Name.isEnabled = true
        txtField_PhoneNumber.isEnabled = true
        txtField_Adress.isEnabled = true
        textView_Description.isSelectable = true
        textView_Description.isEditable = true
    }
    //MARK- IBActions
    @IBAction func action_EditProfile(_ sender: UIButton) {
      searchResultsTableView.isHidden = true
        if ( boolEditStatus == false)
        {   //If didn't edit anything
            self.editableView()
            boolEditStatus = true
            
        }
        else
        {
            //Image is edited
            if boolEdit || boolEditImage{
                let alert = UIAlertController(title: "Are You Sure", message:"Want to update changes?", preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "No", style: UIAlertActionStyle.default){
                    UIAlertAction in
                    self.unEditableView()
                    self.boolEditStatus = false
                    self.boolEdit = false
                    self.boolEditImage = false
                    
                }
                let cancelAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    self.update()
                }
                // Add the actions
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                // Present the controller
                self.present(alert, animated: true, completion: nil) }
            else{
                self.unEditableView()
                self.boolEditStatus = false
            }
        }
    }
    //Update Api's
    func update(){
        for textField in self.textFields as! [UITextField]
        {
            if(textField == self.txtField_Name){
                if (textField.text?.isEmpty)! {
                    FTIndicator.showToastMessage("Please Enter Display Name")
                    return
                }
                if(textField == self.txtField_PhoneNumber){
                if (txtField_PhoneNumber.text?.isEmpty)! {
                    FTIndicator.showToastMessage("Please Enter phone number")
                    return
                }
            }
        }
        
            FTIndicator.showProgress(withMessage: "Updating..")
           
            wsManager.updateRestaurantWithImage(["rest_id":Singleton.sharedInstance.user.id!,"name": self.txtField_Name.text!,"phone": txtField_PhoneNumber.text!,"address": txtField_Adress.text!,"description":textView_Description.text,"latitude":lat!,"longitude":longi!], image: selectedImage!, completionHandler: { (success, message) -> Void in
                DispatchQueue.main.async(execute: { () -> Void in
                    if success {
                        FTIndicator.dismissProgress()
                        self.unEditableView()
                        FTIndicator.showToastMessage(message)
                        self.boolEdit = false
                        self.boolEditStatus = false
                        self.boolEditImage = false
                        
                    } else {
                        FTIndicator.dismissProgress()
                        FTIndicator.showToastMessage(message)
                    }
                })
            })
        }
        //Edit profile without image
    }
    //MARK- IBAction's
    //Edit Small Profile Image
    @IBAction func actionGestureSmallImage(_ sender: Any) {
        self.showActionSheet()
        
    }
    //Edit Large Profile Image
    @IBAction func actionGestureLargeImage(_ sender: Any) {
        searchResultsTableView.isHidden = true
        self.showActionSheet()
    }
    //Call
    @IBAction func actionGestureMakeCall(_ sender: Any) {
        searchResultsTableView.isHidden = true
        makeCall(urlString: "123456789")
    }
    /* Show side menu on menu button click
     */
    @IBAction func openMenu(_ sender: UIButton) {
        searchResultsTableView.isHidden = true
        showSideMenu()
    }
    //MARK:- Methods
    //MARK- Phone Call
    func makeCall(urlString: String){
        guard let url = URL(string: "telprompt://" + urlString) else {
            FTIndicator.showToastMessage("Unable to make call")
            return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    //Check username validation
    func isValidInput(Input:String) -> Bool {
        let RegEx = "\\A\\w{5,18}\\z"
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return Test.evaluate(with: Input)
    }
    
}








//
//  EditMenuVC.swift
//  SnobbiMerchantSide
//
//  Created by MAC on 06/10/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit
import Kingfisher
import FTIndicator

class EditMenuVC: UIViewController {
    //MARK- IBoutlet
    @IBOutlet weak var txtFld_EnterPrice: UITextField!
    @IBOutlet weak var btn_SelectImage: UIButton!
    @IBOutlet weak var txtFld_EnterName: UITextField!
    var editItem:Item?
    var menuId:String?
    var selectedImage:UIImage?
    var wsManager = WebserviceManager()
    var boolImageSelectd = false
    var picker:UIImagePickerController?=UIImagePickerController()
    //MARK- ViewLifeCylce
    override func viewDidLoad() {
        super.viewDidLoad()
      if self.title == "Edit Item"{
            menuId = editItem?.menu_id
            self.setUpView()
        }
        self.addToolBar(textField : self.txtFld_EnterPrice)
   }
    
    func addToolBar(textField: UITextField){
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action:  #selector(donePressed))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.items = [spaceButton, doneButton]
        toolBar.sizeToFit()
        textField.delegate = self
        textField.inputAccessoryView = toolBar
    }
    func donePressed(){
        view.endEditing(true)
    }
    func cancelPressed(){
        view.endEditing(true) // or do something
    }
    
    
    func setUpView(){
       txtFld_EnterName.text = editItem?.name
        txtFld_EnterPrice.text = editItem?.price
        if let imageUrl = URL(string:(editItem?.image)!){
        KingfisherManager.shared.retrieveImage(with: imageUrl, options: nil, progressBlock: nil, completionHandler: { image, error, cacheType, imageURL in
            if error == nil{
            self.btn_SelectImage.setBackgroundImage(image, for: .normal)
              self.selectedImage = image
              self.boolImageSelectd = true
            }
           
        })
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: animated);
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
    //MARK- IBAction
    @IBAction func action_PickImage(_ sender: Any) {
        showActionSheet()
        
    }
    @IBAction func action_Save(_ sender: Any) {
        var price = ""
        if (txtFld_EnterName.text?.isEmpty)!{
            
            FTIndicator.showToastMessage("Please enter item name")
            return
        }
      if (txtFld_EnterPrice.text?.isEmpty)!{
           
          FTIndicator.showToastMessage("Please enter item price")
            return
        }
        
       if !((txtFld_EnterPrice.text?.isEmpty)!){
            price = String(describing: Double(txtFld_EnterPrice.text!)!)
            
        if price == "0.0"{
         FTIndicator.showToastMessage("Please enter item price")
             return
        }
        else {
            txtFld_EnterPrice.text = price
            }
            
        }
    if boolImageSelectd == false{
            FTIndicator.showToastMessage("Please select item image")
            return
            }
          //let selectedImage = btn_SelectImage.backgroundImage(for: .normal)
        if self.title == "Edit Item"{
            self.updateItem()
        }
        else{
            self.addItem()
        }
    }
    func updateItem(){
        FTIndicator.showProgress(withMessage: "Updating..")
        wsManager.updteItem((editItem?.id)!, name: txtFld_EnterName.text!, price: txtFld_EnterPrice.text!, image: selectedImage!, completionHandler: { (success, message) -> Void in
            DispatchQueue.main.async(execute: { () -> Void in
                if success {
                    FTIndicator.dismissProgress()
                    self.onClcikBack()
                    FTIndicator.showToastMessage(message)
                    
                } else {
                    FTIndicator.dismissProgress()
                    FTIndicator.showToastMessage(message)
                    
                }
            });
        })
    
}
    func addItem(){
        FTIndicator.showToastMessage("Adding..")
        wsManager.addItem(menu_id: menuId!, name: txtFld_EnterName.text!, price: txtFld_EnterPrice.text!, image: selectedImage!, completionHandler: { (success, message) -> Void in
            DispatchQueue.main.async(execute: { () -> Void in
                if success {
                    FTIndicator.dismissProgress()
                    self.txtFld_EnterName.text = ""
                    self.txtFld_EnterPrice.text = ""
                    self.btn_SelectImage.setBackgroundImage(UIImage(named:"placeholderImage"), for: .normal)
                    FTIndicator.showToastMessage(message)
                } else {
                    FTIndicator.dismissProgress()
                    FTIndicator.showToastMessage(message)
                }
            });
        })
    }
    
}

    


//
//  MenuAddMoreCategoryVC.swift
//  SnobbiMerchantSide
//
//  Created by MAC on 05/10/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit
import FTIndicator
class MenuAddMoreCategoryVC: UIViewController {
    //MARK- IBOutlet
    @IBOutlet weak var txtFld_EnterItemCategory: UITextField!
    @IBOutlet weak var txtFld_ItemName: UITextField!
    @IBOutlet weak var txtFld_EnterPrice: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var view_ItemandPrice: UIView!
    @IBOutlet weak var view_ItemName: UIView!
    @IBOutlet weak var view_itemPrice: UIView!
    @IBOutlet weak var lbl_HeadingAddImage: UILabel!
    @IBOutlet weak var lbl_HeadingPrice: UILabel!
    @IBOutlet weak var lbl_HeadinItem: UILabel!
    @IBOutlet weak var btn_SelectImage: UIButton!
    //MARK- Constant and Variables
    let kCellReusableIdentifier = "MenuAddItem"
    var itemArray = [NSDictionary]()
    var itemDict = NSDictionary()
    var imageArray = [UIImage]()
    var selectedImage:UIImage?
    let wsManager = WebserviceManager()
    var boolImageSelectd = false
    var picker:UIImagePickerController?=UIImagePickerController()
    //MARK- ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
     
        txtFld_ItemName.delegate = self
        txtFld_EnterPrice.delegate = self
        txtFld_EnterItemCategory.delegate = self
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: animated);
           self.title = "Add Items"
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
        var price : String = ""
        if (txtFld_EnterItemCategory.text?.isEmpty)!{
        FTIndicator.showToastMessage("Please enter menu name")
            return
        }
        if (txtFld_ItemName.text?.isEmpty)!{
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
    if boolImageSelectd == false
        {
            FTIndicator.showToastMessage("Please select item image")
            return
            
        }
        FTIndicator.showProgress(withMessage: "Requesting..")
self.wsManager.createMenu(menuname: txtFld_EnterItemCategory.text!, itemName: txtFld_ItemName.text!, itemPrice: txtFld_EnterPrice.text!, itemImage: selectedImage!, completionHandler:{ (success, message) -> Void in
            DispatchQueue.main.async(execute: { () -> Void in
                if success {
                    FTIndicator.dismissProgress()
                    FTIndicator.showToastMessage(message)
                    self.onClcikBack()
                } else {
                    FTIndicator.dismissProgress()
                   
                     FTIndicator.showToastMessage(message)
                }
            });
        })
    }
    
    func notPrettyString(from object: Any) -> String? {
        if let objectData = try? JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions(rawValue: 0)) {
            let objectString = String(data: objectData, encoding: .utf8)
           
            return objectString
        }
        return nil
    }
    @IBOutlet weak var btn_AddItem: UIButton!
    @IBAction func addItemToTable(_ sender: UIButton){
        if (txtFld_ItemName.text?.isEmpty)!{
            FTIndicator.showToastMessage("Please enter item name")
            return
        }
        else  if (txtFld_EnterPrice.text?.isEmpty)!{
            FTIndicator.showToastMessage("Please enter item price")
            return
        }
        else if !boolImageSelectd{
            FTIndicator.showToastMessage("Please select item image")
            return

        }
        
        let selectedImage = btn_SelectImage.backgroundImage(for: .normal)
        itemDict = ["name":txtFld_ItemName.text ?? "","price":txtFld_EnterPrice.text ?? "","image":"image\(imageArray.count-1).jpg"]
        imageArray.append(selectedImage!)
        itemArray.append(itemDict)
        txtFld_ItemName.text = ""
        txtFld_EnterPrice.text = ""
        boolImageSelectd = false
        btn_SelectImage.setBackgroundImage(UIImage(named:"placeholderImage"), for: .normal)
        print(itemArray)
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: itemArray.count-1, section: 0)], with: .automatic)
        tableView.endUpdates()
    }
}
//MARK - Extension's
extension MenuAddMoreCategoryVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellReusableIdentifier, for: indexPath) as? MenuAddItem ??
            MenuAddItem(style: .default, reuseIdentifier: "kCellReusableIdentifier")
        
        let dict = itemArray[indexPath.row] as NSDictionary
        cell.lbl_ItemName.text = dict.object(forKey: "name") as? String
        cell.lbl_ItemPrice.text = dict.object(forKey: "price") as? String
        cell.thumbnailImageView.image = imageArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        DispatchQueue.main.async(){
        //
        //            self.performSegue(withIdentifier: "segueAdditionalChargeVC", sender: self)
        //
        //        }
        //        guard let menuContainerViewController = self.menuContainerViewController else {
        //            return
        //        }
        //
        //        menuContainerViewController.selectContentViewController(menuContainerViewController.contentViewControllers[indexPath.row])
        //        menuContainerViewController.hideSideMenu()
    }
}


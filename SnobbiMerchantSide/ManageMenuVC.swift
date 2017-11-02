//
//  ManageMenuVC.swift
//  SnobbiMerchantSide
//
//  Created by MAC on 18/09/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit
import InteractiveSideMenu
import FTIndicator
class ManageMenuVC: UIViewController,SideMenuItemContent {
    //MARK- IBOutlet
    @IBOutlet weak var view_NoData:UIView!
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var btn_Edit:UIButton!
    //MARK - Variable and Constants
    var sections = [Section]()
    var selectedItem:Item?
    var selectedMenu:String?
    let wsManager = WebserviceManager()
   
    //MARK - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Auto resizing the height of the cell
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        self.title = "Menu"
        self.view_NoData.frame = CGRect(x: 0, y:104, width: self.view.frame.size.width, height: self.view.frame.size.height-104)
        self.view.addSubview(self.view_NoData)
        self.view.bringSubview(toFront: self.view_NoData)
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.getallMenu()
    }
    func getallMenu(){
        FTIndicator.showProgress(withMessage: "loading..")
        wsManager.getAllMenu( completionHandler:{(sucess,items,message)-> Void in
            if sucess{
                FTIndicator.dismissProgress()
                if (items.isEmpty){
                   self.view.addSubview(self.view_NoData)
                    }
                else{
                   self.view_NoData.removeFromSuperview()
                    self.sections = items
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
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueAddItem" {
            let vc = segue.destination as! EditMenuVC
            vc.title = "Add Item"
            vc.menuId = selectedMenu
            }
       else if segue.identifier == "segueEditItem" {
            let vc = segue.destination as! EditMenuVC
            vc.title = "Edit Item"
            vc.editItem = self.selectedItem
        }
    }
   //MARK- IBAction
    @IBAction func openMenu(_ sender: UIButton) {
        showSideMenu()
    }
    @IBAction  func showEditing(sender: UIBarButtonItem)
    {
        if(self.tableView.isEditing == true)
        {
            self.tableView.isEditing = false
            self.btn_Edit.setImage(UIImage(named: "navEdit"), for: .normal)
            self.navigationItem.rightBarButtonItem?.title = "Done"
            tableView.reloadData()
        }
        else
        {
            self.tableView.isEditing = true
            self.btn_Edit.setImage(UIImage(named: "editprofile"), for: .normal)
            self.navigationItem.rightBarButtonItem?.title = "Edit"
            tableView.reloadData()
        }
    }
}

//
// MARK: - View Controller DataSource and Delegate
//


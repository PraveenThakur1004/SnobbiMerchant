//
//  ManageMenu+Extension.swift
//  SnobbiMerchantSide
//
//  Created by MAC on 16/10/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import  UIKit
import  FTIndicator
extension ManageMenuVC{
    func deleteItem(itemID:String?, index:IndexPath){
        FTIndicator.showProgress(withMessage: "loading..")
        wsManager.deleteItem(itemID!,  completionHandler:{(sucess,message)-> Void in
            if sucess{
                FTIndicator.dismissProgress()
                self.sections[index.section].items.remove(at: index.row)
            FTIndicator.showToastMessage(message)
                self.tableView.reloadData()
            }
            else{
                FTIndicator.dismissProgress()
                FTIndicator.showToastMessage(message)
            }
        })
    }
    func prepareDelete(_ menuId:String,atSection:Int){
        let alert = UIAlertController(title: "Are You Sure", message:"Want to delete this menu", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil)
        let cancelAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.deleteMenu(menuId: menuId, atSection: atSection)
        }
        // Add the actions
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        // Present the controller
        self.present(alert, animated: true, completion: nil)
    }
    func deleteMenu(menuId:String?, atSection:Int){
        FTIndicator.showProgress(withMessage: "loading..")
        wsManager.deleteMenu(menuId!,  completionHandler:{(sucess,message)-> Void in
            if sucess{
                FTIndicator.dismissProgress()
                self.sections.remove(at: atSection)
                FTIndicator.showToastMessage(message)
                self.tableView.reloadData()
            }
            else{
                FTIndicator.dismissProgress()
                FTIndicator.showToastMessage(message)
            }
        })
    }
func action_EditItem(_ sender:SectionButton){
        let data = sections[sender.section].items[sender.tag]
      self.selectedItem = data
      self.performSegue(withIdentifier: "segueEditItem", sender: self)
        
    }
}
extension ManageMenuVC:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].collapsed ? 0 : sections[section].items.count
    }
    // Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ManageMenuCell = tableView.dequeueReusableCell(withIdentifier: "ManageMenuCell") as? ManageMenuCell ??
            ManageMenuCell(style: .default, reuseIdentifier: "ManageMenuCell")
        let item: Item = sections[indexPath.section].items[indexPath.row]
        cell.lbl_ItemName.text  = item.name
        cell.lbl_ItemPrice.text = "$\(item.price)"
        let imageUrl = URL(string:item.image)
            cell.thumbnailImageView.kf.setImage(with:imageUrl, placeholder: UIImage(named:"placeholderImage"), options: nil, progressBlock: nil,  completionHandler: { image, error, cacheType, imageURL in
                if  image != nil{
                cell.thumbnailImageView.image = image!.resizeImageWith(newSize: CGSize(width:65, height: 65))
                }
            })
      
          cell.btn_Edit.addTarget(self, action: #selector(action_EditItem), for: .touchUpInside)
         cell.btn_Edit.tag = indexPath.row
         cell.btn_Edit.section = indexPath.section
        // cell.detailLabel.text = item.detail
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            let item: Item = sections[indexPath.section].items[indexPath.row]
           self.deleteItem(itemID: item.id, index: indexPath)
           }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // Header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? MangeMenuHeaderView ?? MangeMenuHeaderView(reuseIdentifier: "header")
        
        header.titleLabel.text = sections[section].name
        header.arrowLabel.text = ">"
        header.addButton.addTarget(self, action: #selector(action_AddItem), for: .touchUpInside)
        if(self.tableView.isEditing == true) {
            header.deleteButton.isHidden = false
            header.deleteButton.addTarget(self, action: #selector(action_DeletMenu), for: .touchUpInside)
            header.deleteButton.tag = section
        
        }else{
         header.deleteButton.isHidden = true
        
        }
       
        header.addButton.tag = section
        header.setCollapsed(sections[section].collapsed)
        header.section = section
        header.delegate = self
        return header
    }
    func action_DeletMenu(_ sender:UIButton){
        let data = sections[sender.tag]
        print(data)
       self.prepareDelete(data.id, atSection: sender.tag)
        }
    func action_AddItem(_ sender:UIButton){
        let data = sections[sender.tag]
        print(data)
        selectedMenu = data.id
        self.performSegue(withIdentifier: "segueAddItem", sender: self)
        }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    
}

//
// MARK: - Section Header Delegate
//
extension ManageMenuVC: MangaeMenuHeaderViewDelegate {
    
    func toggleSection(_ header: MangeMenuHeaderView, section: Int) {
        let collapsed = !sections[section].collapsed
        // Toggle collapse
        sections[section].collapsed = collapsed
        header.setCollapsed(collapsed)
        tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
    }
    
}

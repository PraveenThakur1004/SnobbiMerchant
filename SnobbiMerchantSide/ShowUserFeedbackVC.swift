//
//  ShowUserFeedbackVC.swift
//  SnobbiMerchantSide
//
//  Created by MAC on 19/09/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit
import FTIndicator
import Kingfisher
class ShowUserFeedbackVC: UIViewController {
    //MARK- IBOutlet
    @IBOutlet weak var tableView: UITableView!
    //MARK- Variable
     var itemArray = [NSDictionary]()
    let wsManager = WebserviceManager()
    let kCellReuseIdentifier = "userFeedback"
    //MARK- ViewLifeCyle
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView Dynamic heigh and intraction
        tableView.allowsSelection = false
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 102
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.getallFeedback()
    }
    func getallFeedback(){
        FTIndicator.showProgress(withMessage: "loading..")
        wsManager.getAllReview(completionHandler: {(sucess,items,message)-> Void in
            if sucess{
                FTIndicator.dismissProgress()
                if (items.isEmpty){
                   // self.view.addSubview(self.view_NoData)
                    FTIndicator.showToastMessage("No data found")
                }
                else{
                  //  self.view_NoData.removeFromSuperview()
                    self.itemArray = items.reversed()
                    self.tableView.reloadData()
                }
            }
            else{
                FTIndicator.dismissProgress()
              //  self.view.addSubview(self.view_NoData)
                 FTIndicator.showToastMessage(message)
            }
        })
        FTIndicator.dismissProgress()
    }
    //MARK- IBAction's
    @IBAction func actionDismissPresent(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        }
}
//MARK- Extensions
extension ShowUserFeedbackVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellReuseIdentifier, for: indexPath) as! UserFeedbackCellTableViewCell
        cell.layer.backgroundColor = UIColor.clear.cgColor
        let item = itemArray[(indexPath as NSIndexPath).row]
        let reviewDict = item.object(forKey: "Review") as? NSDictionary
        let userDict = item.object(forKey: "User") as? NSDictionary
        var reviewMessageStr = ""
        var imageUrlStr = ""
        var userNameStr = ""
        if let username = userDict?.object(forKey: "image") as? String{
            userNameStr = username
        }
         cell.userNameLabel.text = userNameStr
        if let message = reviewDict?.object(forKey: "message") as? String {
            reviewMessageStr = message
        }
        cell.feedbackLabel.text = reviewMessageStr

        if let imageUrlString  = userDict?.object(forKey: "image") as? String {
            imageUrlStr = imageUrlString
            }
        let imageUrl = URL(string:imageUrlStr)
        cell.thumbnailImageView.kf.setImage(with:imageUrl, placeholder: UIImage(named:"placeholderImage"), options: nil, progressBlock: nil,  completionHandler: { image, error, cacheType, imageURL in})
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        //        guard let menuContainerViewController = self.menuContainerViewController else {
        //            return
        //        }
        //
        //        menuContainerViewController.selectContentViewController(menuContainerViewController.contentViewControllers[indexPath.row])
        //        menuContainerViewController.hideSideMenu()
    }
}


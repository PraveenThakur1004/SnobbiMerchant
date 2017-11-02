//
// NavigationMenuViewController.swift
//
// Copyright 2017 Handsome LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import UIKit
import InteractiveSideMenu
import FTIndicator
import  Kingfisher
/*
 Menu controller is responsible for creating its content and showing/hiding menu using 'menuContainerViewController' property.
 */
class NavigationMenuViewController: MenuViewController {
    //MARK:- IBoutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lbl_Name: UILabel!
     @IBOutlet weak var imageView: UIImageView!
    //MARK:-Variable and contants
    let kCellReuseIdentifier = "MenuCell"
    let menuItems = ["Coupons","Manage Menu","Settings","Logout"]
    let menuImages = ["coupon","menu","setting","logout"]
    fileprivate var isLogout = false
    fileprivate let wsManager = WebserviceManager()
    override var prefersStatusBarHidden: Bool {
        return false
    }
    //MARK- ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Select the initial row
        if let devicetoken = Singleton.sharedInstance.deviceToken{        if devicetoken != ""{
            wsManager.updateToken(devicetoken, completionHandler: {(sucess)-> Void in
                if sucess{
                }
            })}}
        
        tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: UITableViewScrollPosition.none)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lbl_Name.text = Singleton.sharedInstance.user.firstName
        let largeImageUrl = URL(string:Singleton.sharedInstance.user.imageurlStr!)
        self.imageView.kf.setImage(with:largeImageUrl, placeholder: UIImage(named:"placeholderImage"), options: nil, progressBlock: nil,  completionHandler: { image, error, cacheType, imageURL in
            if  image != nil{
               self.imageView.image = image!.resizeImageWith(newSize: CGSize(width:90, height: 90))
            }
        })
        
    }
    //MARK- IBAction 
    //Show Profile
    @IBAction func actionViewProfile(_ sender: UIButton) {
        guard let menuContainerViewController = self.menuContainerViewController else {
            return
        }
        menuContainerViewController.selectContentViewController(menuContainerViewController.contentViewControllers[3])
        menuContainerViewController.hideSideMenu()
    }
}
/*
 Extention of `NavigationMenuViewController` class, implements table view delegates methods.
 */
extension NavigationMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellReuseIdentifier, for: indexPath)
        cell.textLabel?.text = menuItems[indexPath.row]
        cell.imageView?.image = UIImage(named:menuImages[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Logout From Application
        if    (indexPath.row == 3){
            self.logout()
        }
        else{
            guard let menuContainerViewController = self.menuContainerViewController else {
                return
            }
            menuContainerViewController.selectContentViewController(menuContainerViewController.contentViewControllers[indexPath.row])
            menuContainerViewController.hideSideMenu()
        }
    }
    //MARK:- Logout
    func logout(){
        let alert = UIAlertController(title: "Are You Sure", message:"Want to logout?", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil)
        let cancelAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.prepareLogout()
        }
        // Add the actions
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        // Present the controller
        self.present(alert, animated: true, completion: nil)
    }
    //Api for logout
    func prepareLogout(){
        FTIndicator.showProgress(withMessage: "Requesting..")
        self.wsManager.logout(completionHandler: { (success, message) -> Void in
            DispatchQueue.main.async(execute: { () -> Void in
                if success {
                    FTIndicator.dismissProgress()
                    //Set current user instace nil
                    Singleton.sharedInstance.user = nil
                    //Delete all userDefaults
                    let domain = Bundle.main.bundleIdentifier!
                    UserDefaults.standard.removePersistentDomain(forName: domain)
                    UserDefaults.standard.synchronize()
                    //LoginFlow
                    self.pushToLoginScreen()
                } else {
                    FTIndicator.dismissProgress()
                    let alert = UIAlertController(title: "Unknown Error!", message:"Unable to logout.", preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                    // Add the actions
                    alert.addAction(okAction)
                    // Present the controller
                    self.present(alert, animated: true, completion: nil)
                    
                }
            });
        })
    }
    //Navigte to login Screen
    func pushToLoginScreen(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "navMainBase") as! UINavigationController
        let app : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        app.window?.rootViewController = initialViewController
        app.window?.makeKeyAndVisible()
    }
}

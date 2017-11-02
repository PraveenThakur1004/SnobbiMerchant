//
//  AppDelegate.swift
//  SnobbiMerchantSide
//
//  Created by jatin-pc on 9/12/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit

import UserNotifications

import FTIndicator
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {
    var window: UIWindow?
    var wsManger = WebserviceManager()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //MARK- Indicator and Keyboard intialization
        FTIndicator.setIndicatorStyle(.dark)
        
        //Registering for push notification
        Singleton.sharedInstance.deviceToken = ""
        UNUserNotificationCenter.current().delegate = self
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            application.registerForRemoteNotifications()
        }
        //Autologin
        if (UserDefaults.standard.object(forKey: "user_email") as? String) != nil{
            let dict = UserDefaults.standard.object(forKey: "user")
            Singleton.sharedInstance.user = getUser(dict as! [String : AnyObject])
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Menu", bundle: nil)
            let exampleViewController: HostViewController = mainStoryboard.instantiateViewController(withIdentifier: "ID_HostViewController") as! HostViewController
            let navigationController = UINavigationController(rootViewController: exampleViewController);
            self.window?.rootViewController = navigationController
            self.window?.makeKeyAndVisible()
        }
        
        return true
    }
    //MARK- UserNotificationDelegates
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([UNNotificationPresentationOptions.alert,UNNotificationPresentationOptions.sound,UNNotificationPresentationOptions.badge])
    }
    // Called when APNs has assigned the device a unique token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Convert token to string
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        // Print it to console
        print("APNs device token: \(deviceTokenString)")
        Singleton.sharedInstance.deviceToken = deviceTokenString
        if (UserDefaults.standard.object(forKey: "user_email") as? String) != nil{
            wsManger.updateToken(deviceTokenString, completionHandler: {(sucess)-> Void in
                if sucess{
                }
            })}
        // Persist it in your backend in case it's new
    }
    //GetUser
    fileprivate func getUser(_ dict: [String: AnyObject]) -> Restaurant {
        let user = Restaurant(id: dict["id"] as? String ?? "", firstName: dict["name"] as? String ?? "", email: dict["email"] as? String ?? "", imageurlStr: dict["image_icon"] as? String ?? "", phone: dict["phone"] as? String ?? "", address: dict["streetAddress"] as? String ?? "", descriptionApp: dict["description"] as? String ?? "", userId: dict["userId"] as? String ?? "", latt:dict["latitude"] as? String ?? "", longi: dict["longitude"] as? String ?? "" );
        
        return user
    }
}



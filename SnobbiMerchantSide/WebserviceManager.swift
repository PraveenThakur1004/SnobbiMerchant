//
//  WebserviceManager.swift


import UIKit
import Foundation
import Alamofire
import FTIndicator
class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}

//MARK:-BaseUrls
let baseUrl = "http://ec2-54-85-165-139.compute-1.amazonaws.com/api/apis/"
class WebserviceManager: NSObject{
    //MARK:- Constant BaseUrl+taskUrl
    //New
    fileprivate let failedURLMessage = "cannot access server's URL"
    //Basic
    let userLoginURL = baseUrl + "login?"
    let changePasswordURL = baseUrl + "updatePassword?"
    let updateDevice = baseUrl + "updateToken?"
    let logoutURL = baseUrl + "logout?"
    //let userPasswordURL = baseUrl + "about"
    let forGotPasswordURL = baseUrl + "forgetPassword?"
    //SlideMenu
    let updateRestaurantInfoURL = baseUrl + "updateRestaurant?"
    let restaurantFeedbackURL = baseUrl + "fetchReview?"
    let allCouponsUrl = baseUrl + "restaurantCoupan?"
    let changeCoponStatusURL = baseUrl + "redeemCoupan?"
    let createMenuUrl = baseUrl + "restaurantItems?"
    let geAllMenuURL  = baseUrl + "listMenu?"
    let addItemURL    = baseUrl + "addItem?"
    //Settings
    let privacyPolicyUrl = baseUrl + "privacy"
    let aboutUsUrl = baseUrl + "about"
    let getHelpURL = baseUrl + "help"
    
    //Others
    //update
    let updateMenuURL = baseUrl + "updateMenu?"
    let updateItemURL = baseUrl + "itemAction?"
    //delete
    let deleteItemURL = baseUrl + "deleteItem?"
    let deleteMenuURL = baseUrl + "deleteMenu?"
    //MARK:-Almofire post request
    //Multipart
    //singleImage
    func uploadTaskFor(URLString : String , parameters : [String : String] , forImage : UIImage , imageKey:String, completion: @escaping (_ success: [String : AnyObject]) -> Void){
        if Connectivity.isConnectedToInternet{
            Alamofire.upload(
                multipartFormData: { MultipartFormData in
                    for (key, value) in parameters {
                        MultipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                    }
                   
                    if  let imageData = UIImageJPEGRepresentation(forImage , 0.6) {
                        
                                                    MultipartFormData.append(imageData, withName: imageKey, fileName: "image.jpeg", mimeType: "image/jpeg")
                    }
            }, to: URLString) { (result) in
                switch(result) {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        if response.result.value != nil{
                            let json = response.result.value
                            completion(json as! [String : AnyObject])
                        }
                    }
                    break;
                case .failure(_):
                    FTIndicator.showError(withMessage:"Unable to find the result")
                    break;
                }
            }
        }else{
            FTIndicator.showError(withMessage:"Network not available")
        }
        
    }
    //Multiple images under key
    func uploadMultipleImage(URLString : String , filesArray : [UIImage] ,forKey:String, completion: @escaping (_ success: [String : AnyObject]) -> Void){
        if Connectivity.isConnectedToInternet{
            
            Alamofire.upload(
                multipartFormData: { MultipartFormData in

            
                    //TODO: - Uncomment when image is to be edit
                    var i = 0
                    for (image) in filesArray {
                        if  let imageData = UIImageJPEGRepresentation(image , 0.6) {
                            MultipartFormData.append(imageData, withName: "image", fileName: "image.jpeg", mimeType: "image\(i).jpg")
                        }
                        i += 1
                    }
            }, to: URLString) { (result) in
                print(result)
                switch(result) {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        if response.result.value != nil{
                            let json = response.result.value
                            completion(json as! [String : AnyObject])
                        }
                    }
                    break;
                case .failure(_):
                    FTIndicator.showError(withMessage:"Unable to find the result")
                    break;
                }
            }
        }else{
            FTIndicator.showError(withMessage:"Network not available")
        }

        
    }
   // http://nimbyisttechnologies.com/himanshu/spnoopi/api/apis/restaurantItems?restaurant_id=1&menuname=Check&itemData=[{"name":"wooo","price":"30","image":"image-1.jpg"},{"name":"now","price":"20","image":"image0.jpg"}]
    
   // nimbyisttechnologies.com/himanshu/spnoopi/api/apis/restaurantItems?restaurant_id=1&menuname=Rice&itemData="[{\"name\":\"Hello \",\"price\":\"10\",\"image\":\"image0.jpg\"},{\"name\":\"test2\",\"price\":\"$40\",\"image\":\"image1.jpg\"}]"
    //PostRequest
    func alamofirePost(parameter : NSDictionary , urlString : String, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        if Connectivity.isConnectedToInternet{
            Alamofire.request(urlString, method: .post, parameters: nil, encoding: JSONEncoding.default , headers: nil).responseJSON { (response:DataResponse<Any>) in
                print(response.result)
                switch(response.result) {
                case .success(_):
                    if response.result.value != nil{
                        let dict  =  response.result.value as! NSDictionary
                        completionHandler(dict, nil)
                        print(dict)
                        }
                    break
                case .failure(_):
                     FTIndicator.showError(withMessage:"Unable to find the result")
                    break
                }
            }
        }
        else{
            FTIndicator.showError(withMessage:"Network not available")
        }
    }
    //GetRequest
    func alamofireGet(urlString:String,completionHandler:@escaping(AnyObject)-> ()){
        if Connectivity.isConnectedToInternet{
            Alamofire.request(urlString).responseJSON{ response in // method defaults to `.get`
                debugPrint(response)
                print(response)
                switch(response.result){
                case .success(_):
                    if let JSON = response.result.value {
                        completionHandler(JSON as AnyObject)
                    }
                    break
                case .failure(_):
                    FTIndicator.showError(withMessage:"Unable to find the result")
                    break
                }
            }}
        else{
            FTIndicator.showError(withMessage:"Network no available")
        }
    }
    //MARK:- Api's
    //login
    func login(_ email: String, password: String, completionHandler closure: @escaping (_ user: Restaurant?, _ success: Bool, _ message: String?) -> Void) {
        if URL(string: userLoginURL) != nil {
            let email = Utils.encodeString(email);
            let password = Utils.encodeString(password);
            let queryString = userLoginURL + "&email=\(email)" + "&pass=\(password)" + "&type=\("1")"  ;
            print(queryString)
            self.alamofirePost(parameter: [:], urlString:  queryString, completionHandler: { (result, error) -> Void in
                var success = false
                var message: String?
                var user: Restaurant?
                let status = result?["response"] as! String
                if  status == "1" {
                    success = true
                    let dict  = result?["data"] as? [String: AnyObject]
                    let restadict = dict?["Restaurant"] as? [String:AnyObject]
                    let value = dict?["User"] as? [String:AnyObject]
                   user = self.getUser(restadict!, email: value?["email"] as? String ?? "", userId: value?["id"] as? String ?? "")
                    message = "User logged in successfully";
                }
                else {
                    let status = result?["response"] as! String
                    print(status )
                    message = result?["mesg"] as? String;
                }
                closure( user, success ,message);
            })
        }
    }
    //ForgotPassword
   
    func forgotPassword(_ email: String, completionHandler closure: @escaping (_ success: Bool, _ message: String?) -> Void) {
        if URL(string: forGotPasswordURL) != nil {
            let queryString = forGotPasswordURL  +  "&email=\(email)" + "&type=\("1")" ;
            self.alamofirePost(parameter: [:], urlString:  queryString, completionHandler: { (result, error) -> Void in
                var success = false
                var message: String?
                let status = result?["response"] as! String
                if  status == "1" {
                    success = true
                    message = result?["mesg"] as? String
                } else {
                    message = result?["mesg"] as? String
                }
                closure(success, message)
            })
        } else {
            closure(false, failedURLMessage)
        }
    }
    //Logot
    func logout(completionHandler closure: @escaping (_ success: Bool, _ message: String?) -> Void) {
        if URL(string: logoutURL) != nil {
            let userid = Singleton.sharedInstance.user.userId
            let queryString = logoutURL + "user_id=\(String(describing: userid!))"
            print("here is the query string\(queryString)")
             self.alamofirePost(parameter: [:], urlString:  queryString, completionHandler: { (result, error) -> Void in
                var success = false;
                var message: String?;
                let status = result?["response"] as? String
                if  status == "1" {
                    success = true;
                    message = result?["mesg"] as? String
                } else {
                    message = result?["mesg"] as? String
                }
                closure(success, message)
            })
        } else {
            closure(false, failedURLMessage)
        }
    }
    //UpdateToken
func updateToken(_ devicetoken: String, completionHandler closure: @escaping ( _ success: Bool) -> Void) {
        if URL(string: updateDevice) != nil {
            let userId = Singleton.sharedInstance.user.userId
            let queryString = updateDevice + "user_id=\(userId!)"  + "&token=\(String(describing: Singleton.sharedInstance.deviceToken!))" ;
            print(queryString)
            self.alamofirePost(parameter: [:], urlString:  queryString, completionHandler: { (result, error) -> Void in
                var success = false
                let status = result?["response"] as! String
                if  status == "1" {
                    success = true
                    
                }
                else {
                    success = false
                }
                closure(success );
            })
        }
    }
    //http://nimbyisttechnologies.com/himanshu/spnoopi/api/apis/listMenu?restaurant_id=1
    //Get Full Menu
    func getAllMenu( completionHandler closure: @escaping ( _ success: Bool,_ data:[Section], _ message:String) -> Void) {
        if URL(string: geAllMenuURL) != nil {
            let restaurant_id = Singleton.sharedInstance.user.id!
            let queryString = geAllMenuURL + "restaurant_id=\(String(describing: restaurant_id))"
            print(queryString)
            self.alamofirePost(parameter: [:], urlString:  queryString, completionHandler: { (result, error) -> Void in
                var success = false
                var message: String?
                var sectionData = [Section]()
                
                print(result)
                var data =  [NSDictionary]()
                let status = result?["response"] as? String
                if  status == "1" {
                    success = true
                    data = (result?["data"] as? [NSDictionary])!
                    
                        sectionData = self.getSection(data)
                    
                    message = result?["mesg"] as? String;
                    // message = "User logged in successfully";
                }
                else {
                    
                    message = result?["mesg"] as? String;
                }
                closure( success,sectionData ,message!);
            })
        }
    }
    //http://nimbyisttechnologies.com/himanshu/spnoopi/api/apis/fetchReview?rest_id=9
    //Get Review
    func getAllReview( completionHandler closure: @escaping ( _ success: Bool,_ data:[NSDictionary], _ message:String) -> Void) {
        if URL(string: restaurantFeedbackURL) != nil {
            let restaurant_id = Singleton.sharedInstance.user.id!
            let queryString = restaurantFeedbackURL + "rest_id=\(String(describing: restaurant_id))"
            print(queryString)
            self.alamofirePost(parameter: [:], urlString:  queryString, completionHandler: { (result, error) -> Void in
                var success = false
                var message: String?
                print(result)
                var data =  [NSDictionary]()
                let status = result?["response"] as? String
                if  status == "1" {
                    success = true
                    data = (result?["data"] as? [NSDictionary])!
                    message = result?["mesg"] as? String;
                    // message = "User logged in successfully";
                }
                else {
                    
                    message = result?["mesg"] as? String;
                }
                closure( success,data ,message!);
            })
        }
    }
    //AllCoupons
    func getAllCoupons(counpon_Status:String, completionHandler closure: @escaping ( _ success: Bool,_ data:[NSDictionary], _ message:String) -> Void) {
        if URL(string: allCouponsUrl) != nil {
            let restaurant_id = Singleton.sharedInstance.user.id!
            let queryString = allCouponsUrl + "restaurant_id=\(String(describing: restaurant_id))"  + "&redeem=\(counpon_Status)"  ;
            print(queryString)
            self.alamofirePost(parameter: [:], urlString:  queryString, completionHandler: { (result, error) -> Void in
                var success = false
                var message: String?
                print(result)
                var data =  [NSDictionary]()
                let status = result?["response"] as? String
                if  status == "1" {
                    success = true
                    data = (result?["data"] as? [NSDictionary])!
                    message = result?["mesg"] as? String;
                    // message = "User logged in successfully";
                }
                else {
                    
                    message = result?["mesg"] as? String;
                }
                closure( success,data ,message!);
            })
        }
    }
    
    //changeCoupon status
    func changeCouponStatus(order_id:String, completionHandler closure: @escaping (_ success: Bool, _ message: String?) -> Void) {
        if URL(string: changeCoponStatusURL) != nil {
           let queryString = changeCoponStatusURL + "order_id=\(order_id)"
            print(queryString)
            self.alamofirePost(parameter: [:], urlString:  queryString, completionHandler: { (result, error) -> Void in
                var success = false;
                var message: String?;
                let status = result?["response"] as? String
                if  status == "1" {
                    success = true;
                    message = result?["mesg"] as? String
                } else {
                    message = result?["mesg"] as? String
                }
                closure(success, message)
            })
        } else {
            closure(false, failedURLMessage)
        }
    }
    //UpdatePassword
    func changePassword(_ oldPassword:String,_ newPassword: String,  completionHandler closure: @escaping (_ success: Bool, _ message: String?) -> Void) {
        if URL(string: changePasswordURL) != nil {
            let userid = Singleton.sharedInstance.user.userId
            let queryString = changePasswordURL + "user_id=\(String(describing: userid!))" + "&oldPass=\(oldPassword)" + "&newPass=\(newPassword)"
             self.alamofirePost(parameter: [:], urlString:  queryString, completionHandler: { (result, error) -> Void in
                var success = false;
                var message: String?;
                let status = result?["response"] as? String
                if  status == "1" {
                    success = true;
                    message = result?["mesg"] as? String
                } else {
                    message = result?["mesg"] as? String
                }
                closure(success, message)
            })
        } else {
            closure(false, failedURLMessage)
        }
    }
    //UpdateProfile
    func updateRestaurantWithImage(_ dict:[String: String],image:UIImage, completionHandler closure: @escaping (_ success: Bool, _ message: String?) -> Void)  {
        self.uploadTaskFor(URLString: updateRestaurantInfoURL, parameters: dict, forImage: image, imageKey:"image_icon" , completion:  { (result) -> Void in
            var success = false
            var message: String?
            var user: Restaurant?
            let status = result["response"] as? String
            if  status == "1" {
                success = true
                let dict  = result["data"] as? [String: AnyObject]
                Singleton.sharedInstance.user = nil
                UserDefaults.standard.removeObject(forKey: "user")
               
                let restadict = dict?["Restaurant"] as? [String:AnyObject]
                let value = dict?["User"] as? [String:AnyObject]
                user = self.getUser(restadict!, email: value?["email"] as? String ?? "", userId: value?["id"] as? String ?? "")
                Singleton.sharedInstance.user = user
                let dictUser = user?.asDictionary()
                UserDefaults.standard.set(dictUser, forKey: "user")
                UserDefaults.standard.synchronize()
                message = result["mesg"] as? String;
            }
            else {
                message = result["mesg"] as? String;
            }
            closure(success,message);
        })
        
    }
    // http://nimbyisttechnologies.com/himanshu/spnoopi/api/apis/updateRestaurant?rest_id=logoUrl&image_icon&name&address&description&phone
    //Update Profile without Image
    func updateRestaurantWithoutImage(_ name:String, _ phone: String, _ adress:String,_ description:String, completionHandler closure: @escaping (_ success: Bool, _ message: String?) -> Void) {
        if URL(string: updateRestaurantInfoURL) != nil {
            guard let id = Singleton.sharedInstance.user.id else {
                FTIndicator.showProgress(withMessage: "Invalid user")
                return }
            let queryString = updateRestaurantInfoURL + "rest_id=\(id)" + "&address=\(adress)"  + "&name=\(name)" + "&phone=\(phone)" + "&description=\(description)" ;
            print(queryString)
             self.alamofirePost(parameter: [:], urlString:  queryString, completionHandler: { (result, error) -> Void in
                var success = false;
                var message: String?;
                var user: Restaurant?
                let status = result?["response"] as? String
                if  status == "1" {
                    success = true;
                    let dict  = result?["data"] as? [String: AnyObject]
                    Singleton.sharedInstance.user = nil
                    UserDefaults.standard.removeObject(forKey: "user")
                   let restadict = dict?["Restaurant"] as? [String:AnyObject]
                    let value = dict?["User"] as? [String:AnyObject]
                    user = self.getUser(restadict!, email:value?["email"] as? String ?? "" , userId:value?["id"] as? String ?? "" )
                    Singleton.sharedInstance.user = user
                    let dictUser = user?.asDictionary()
                    UserDefaults.standard.set(dictUser, forKey: "user")
                    UserDefaults.standard.synchronize()
                    message = result?["mesg"] as? String
                } else {
                    message = result?["mesg"] as? String
                }
                closure(success, message)
            })
        } else {
            closure(false, failedURLMessage)
        }
    }
  // nimbyisttechnologies.com/himanshu/spnoopi/api/apis/restaurantItems?restaurant_id=17&menuname=Chees Brusht&i_price=34&i_name=cx
    func createMenu(menuname:String,itemName:String,itemPrice:String, itemImage:UIImage,  completionHandler closure: @escaping (_ success: Bool, _ message: String?) -> Void) {
        if URL(string:createMenuUrl) != nil {
            let dict = ["restaurant_id":Singleton.sharedInstance.user.id!,"menuname":menuname,"i_price":itemPrice,"i_name":itemName]
            print(dict)
            self.uploadTaskFor(URLString: createMenuUrl, parameters: dict , forImage: itemImage, imageKey: "image", completion:  { (result) -> Void in
                var success = false
                var message: String?
                let status = result["response"] as? String
                if  status == "1" {
                    success = true
                    message = result["mesg"] as? String;
                }
                else {
                    message = result["mesg"] as? String;
                }
                closure(success,message);
            })
        }
    }
//    func createMenu(_ menuname:String, itemData:Array<Any> ,imageArray:[UIImage] , completionHandler closure: @escaping (_ success: Bool, _ message: String?) -> Void)  {
//        var ssss: String = ""
//        
//        do {
//            let jsonData = try JSONSerialization.data(withJSONObject: itemData, options: JSONSerialization.WritingOptions.prettyPrinted)
//            
//            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
//                print(JSONString)
//                ssss = JSONString
//            }
//            
//        } catch {
//            print(error.localizedDescription)
//        }
//  
//        let id = Singleton.sharedInstance.user.id!
//        let dict = ["restaurant_id": id,"menuname":menuname, "itemData": ssss]
//        print (dict)
////        let queryString = createMenuUrl + "restaurant_id=\(String(describing: id))" + "&menuname=\(menuname)"  + "&itemData=\(String(describing: arraysting))"
//        Alamofire.request(createMenuUrl, method: .post, parameters: dict).responseJSON { response in
//            
//            if response.result.isSuccess {
//                
//                if let json = response.result.value {
//                    
//                   // success(json as! Dictionary<String, AnyObject>)
//                }
//            }
//            
//            if response.result.isFailure {
//                
//                let error : Error = response.result.error!
//               // failure(error)
//                print(error.localizedDescription)
//            }
//            
//           
//        }
//        
////        Alamofire.request(createMenuUrl, method: .post, parameters: nil, encoding: JSONEncoding.default , headers: nil).responseJSON { (response:DataResponse<Any>) in
////            print(response.result)
////            switch(response.result) {
////            case .success(_):
////                if response.result.value != nil{
////                    let dict  =  response.result.value as! NSDictionary
////                    completionHandler(dict, nil)
////                    print(dict)
////                }
////                break
////            case .failure(_):
////                FTIndicator.showError(withMessage:"Unable to find the result")
////                break
////            }
////        }
////        
////        
////        
////        self.alamofirePost(parameter: dict, urlString:  createMenuUrl, completionHandler: { (result, error) -> Void in
////            var success = false
////            var message: String?
////            let status = result?["response"] as! String
////            if  status == "1" {
////                success = true
////                message = result?["mesg"] as? String
////                self.uploadMultipleImage(URLString: self.createMenuUrl, filesArray: imageArray, forKey: "image", completion: { (result) -> Void in})
////            } else {
////                message = result?["mesg"] as? String
////            }
////            closure(success, message)
////        })
//        
//        
////        self.uploadMultipleImage(URLString: createMenuUrl, parameters: dict, filesArray: imageArray, completion: { (result) -> Void in
////            var success = false
////            var message: String?
////            let status = result["response"] as? String
////            if  status == "1" {
////                success = true
////                message = result["mesg"] as? String;
////            }
////            else {
////                message = result["mesg"] as? String;
////            }
////            closure(success,message);
////        })
////        
//    }
    func notPrettyString(from object: Any) -> String? {
        if let objectData = try? JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions(rawValue: 0)) {
            let objectString = String(data: objectData, encoding: .utf8)
            
            return objectString
        }
        return nil
    }
    
    
//    func createMenu(_ dict:[String: String],imageArray:[UIImage] , completionHandler closure: @escaping (_ success: Bool, _ message: String?) -> Void)  {
//        
//        
//        self.uploadTaskFor(URLString: createMenuUrl, parameters: dict , forImage: UIImage(named:"placeholder")!, imageKey: "image", completion:  { (result) -> Void in
//            var success = false
//            var message: String?
//            let status = result["response"] as? String
//            if  status == "1" {
//                success = true
//               message = result["mesg"] as? String;
//            }
//            else {
//                message = result["mesg"] as? String;
//            }
//            closure(success,message);
//        })
//        
//    }
    //MARK - Update
    //nimbyisttechnologies.com/himanshu/spnoopi/api/apis/updateMenu?menu_id&name
    func updteMenu(_ menu_id:String, menuname:String,  completionHandler closure: @escaping (_ success: Bool, _ message: String?) -> Void) {
        if URL(string:deleteMenuURL) != nil {
            let queryString = deleteMenuURL + "menu_id=\(menu_id)" + "&name=\(menuname)"
            self.alamofirePost(parameter: [:], urlString:  queryString, completionHandler: { (result, error) -> Void in
                var success = false;
                var message: String?;
                let status = result?["response"] as? String
                if  status == "1" {
                    success = true;
                    message = result?["mesg"] as? String
                } else {
                    message = result?["mesg"] as? String
                }
                closure(success, message)
            })
        } else {
            closure(false, failedURLMessage)
        }
    }
    func addItem(menu_id:String,name:String,price:String, image:UIImage,  completionHandler closure: @escaping (_ success: Bool, _ message: String?) -> Void) {
        if URL(string:addItemURL) != nil {
            let dict = ["menu_id":menu_id,"name":name,"price":price]
            self.uploadTaskFor(URLString: addItemURL, parameters: dict , forImage: image, imageKey: "image", completion:  { (result) -> Void in
                var success = false
                var message: String?
                let status = result["response"] as? String
                if  status == "1" {
                    success = true
                    message = result["mesg"] as? String;
                }
                else {
                    message = result["mesg"] as? String;
                }
                closure(success,message);
            })
        }
    }
    func updteItem(_ item_id:String,name:String,price:String, image:UIImage,  completionHandler closure: @escaping (_ success: Bool, _ message: String?) -> Void) {
        if URL(string:updateItemURL) != nil {
            let dict = ["id":item_id,"name":name,"price":price]
            self.uploadTaskFor(URLString: updateItemURL, parameters: dict , forImage: image, imageKey: "image", completion:  { (result) -> Void in
                var success = false
                var message: String?
                let status = result["response"] as? String
                if  status == "1" {
                    success = true
                    message = result["mesg"] as? String;
                }
                else {
                    message = result["mesg"] as? String;
                }
                closure(success,message);
            })
        }
    }
    func getHelp(completionHandler closure: @escaping (_ success: Bool, _ data:NSDictionary?, _ message: String?) -> Void) {
        if URL(string: getHelpURL) != nil {
         
            self.alamofirePost(parameter: [:], urlString:  getHelpURL, completionHandler: { (result, error) -> Void in
                var success = false;
                var message: String?;
                var data = NSDictionary()
                let status = result?["response"] as? String
                if  status == "1" {
                    success = true;
                    message = result?["mesg"] as? String
                    data  = (result?["data"] as? NSDictionary)!
                } else {
                    message = result?["mesg"] as? String
                }
                closure(success, data, message)
            })
        }
    }
    //MARK- Delete
    //Menu
    func deleteMenu(_ menu_id:String,  completionHandler closure: @escaping (_ success: Bool, _ message: String?) -> Void) {
        if URL(string:deleteMenuURL) != nil {
          let queryString = deleteMenuURL + "menu_id=\(menu_id)"
            self.alamofirePost(parameter: [:], urlString:  queryString, completionHandler: { (result, error) -> Void in
                var success = false;
                var message: String?;
                let status = result?["response"] as? String
                if  status == "1" {
                    success = true;
                    message = result?["mesg"] as? String
                } else {
                    message = result?["mesg"] as? String
                }
                closure(success, message)
            })
        } else {
            closure(false, failedURLMessage)
        }
    }
    //Item
    func deleteItem(_ item_id:String,  completionHandler closure: @escaping (_ success: Bool, _ message: String?) -> Void) {
        if URL(string:deleteItemURL) != nil {
            let queryString = deleteItemURL + "item_id=\(item_id)"
            self.alamofirePost(parameter: [:], urlString:  queryString, completionHandler: { (result, error) -> Void in
                var success = false;
                var message: String?;
                let status = result?["response"] as? String
                if  status == "1" {
                    success = true;
                    message = result?["mesg"] as? String
                } else {
                    message = result?["mesg"] as? String
                }
                closure(success, message)
            })
        } else {
            closure(false, failedURLMessage)
        }
    }
    //MARK- Setting Api's
    //Aboutus
    func aboutUs( completionHandler closure:@escaping (_ sucess:Bool, _ data:NSDictionary, _ message:String? ) -> Void){
            
            if URL(string: aboutUsUrl) != nil {
                self.alamofireGet(urlString: aboutUsUrl, completionHandler: { result in
                    var success = false
                    var message: String?
                    var data = NSDictionary()
                    let status = result["response"] as? String
                    if  status == "1" {
                        success = true
                         data  = (result["data"] as? NSDictionary)!
                        message = result["mesg"] as? String;
                    }
                    else {
                       
                          message = result["mesg"] as? String;
                    }
                    closure( success, data, message)
                })
            }
        }
    //Privacy 
    func getprivacy( completionHandler closure:@escaping (_ sucess:Bool, _ data:NSDictionary, _ message:String? ) -> Void){
        
        if URL(string: privacyPolicyUrl) != nil {
            self.alamofireGet(urlString: privacyPolicyUrl, completionHandler: { result in
                var success = false
                var message: String?
                var data = NSDictionary()
                let status = result["response"] as? String
                if  status == "1" {
                    success = true
                    data  = (result["data"] as? NSDictionary)!
                    message = result["mesg"] as? String;
                }
                else {
                    
                    message = result["mesg"] as? String;
                }
                closure( success, data, message)
            })
        }
    }
    //Private
   //GetUser
    fileprivate func getUser(_ dict: [String: AnyObject],email:String, userId:String) -> Restaurant {
        let user = Restaurant(id: dict["id"] as? String ?? "", firstName: dict["name"] as? String ?? "", email: email, imageurlStr: dict["image_icon"] as? String ?? "", phone: dict["phone"] as? String ?? "", address: dict["streetAddress"] as? String ?? "", descriptionApp: dict["description"] as? String ?? "", userId: userId,latt:dict["latitude"] as? String ?? "", longi: dict["longitude"] as? String ?? "");
        
        return user
    }
    //GetSection
    fileprivate func getSection(_ array: [NSDictionary]) -> [Section] {
        var sections = [Section]()
        for item in array{
            let Menu = item.object(forKey: "Menu") as! NSDictionary
            let items = item.object(forKey: "Item") as! [NSDictionary]
            let section = Section(name: Menu["name"] as? String ?? "", id:Menu["id"] as? String ?? "", items:getItems(items
            ))
        sections += [section]
            
        }
        return sections
    }
    //getItemunderSection
    fileprivate func getItems(_ array: [NSDictionary]) -> [Item] {
        var items = [Item]()
        for item in array{
            let item = Item(name:item["name"] as? String ?? "", price:item["price"] as? String ?? "", id:item["id"] as? String ?? "", menu_id: item["menu_id"] as? String ?? "", image: item["image"] as? String ?? "")
                items += [item]
            }
        return items
    }
    
}

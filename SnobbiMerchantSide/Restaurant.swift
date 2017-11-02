//
//  User.swift

//

import Foundation
class Restaurant: NSObject {
    //MARK:-Variable and Constant
    var id: String?;
    var firstName: String?;
    var email: String?;
    var userId: String?
    var phoneNumber: String?;
    var imageurlStr : String?
    var address:String?;
    var lat:String?
    var longi:String?
    var descriptionApp:String?
    //MARK:- Initialization
    init(id:String,firstName: String, email: String,imageurlStr:String,phone:String,address:String,descriptionApp:String,userId:String,latt:String,longi:String) {
        self.id = id
        self.imageurlStr = imageurlStr
        self.firstName = firstName;
        self.email = email;
        self.phoneNumber = phone
        self.address = address
        self.descriptionApp = descriptionApp
        self.userId = userId
        self.lat = latt
        self.longi = longi
        
    }
    func asDictionary() -> [String: String] {
       return ["name": firstName!, "email": email!, "image_icon": imageurlStr!,  "phone": phoneNumber!,"id":id!,"streetAddress":address!,"description":descriptionApp!,"userId":userId!];
    }
    
}
        

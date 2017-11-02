//
//  Utils.swift

//

import Foundation
import UIKit
let sharedUtils : Utils = Utils()
class Utils:NSObject
{
    //MARK:-Initialization
   override init()
    {
        super.init();
    }
    class var sharedInstance : Utils {
        return sharedUtils
    }
    
    //String encoding UTF8
    class func encodeString(_ str: String) -> String
    {
        let parsedStr = CFURLCreateStringByAddingPercentEscapes(
            nil,
            str as CFString!,
            nil,
            "!*'();:@&=+$,/?%#[]" as CFString!, //you can add another special characters
            CFStringBuiltInEncodings.UTF8.rawValue
        );
        return parsedStr as! String;
    }
    //MARK:- Validations
    //Check email vaildity
    class func isValidEmail(_ testStr:String) -> Bool {
       let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
   class func numberOfDaysLeft(oldDate: String) -> Int {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let couponCreatedDate: Date = dateFormatter.date(from: oldDate)!
        let currentDateStr: String = dateFormatter.string(from: Date())
        let currentDate: Date = dateFormatter.date(from: currentDateStr)!
        
        let calendar = NSCalendar.current
        let date1 = calendar.startOfDay(for: couponCreatedDate)
        let date2 = calendar.startOfDay(for: currentDate)
        
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        print(components.day!)
        
        return 30 - components.day!
        
    }
    //Check username validation
    func isValidInput(Input:String) -> Bool {
        let RegEx = "\\A\\w{7,18}\\z"
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return Test.evaluate(with: Input)
    }
    
}

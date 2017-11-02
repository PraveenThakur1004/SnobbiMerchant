//
//  TextFieldValidationsManager.swift

//

import UIKit
enum TextFieldValidationResult: Int {
    case ok
    case empty
    case not_MINIMUM
    case not_MAXIMUM
}
class TextFieldValidationsManager: NSObject {
    //MARK:-Constant
    let maxLength = 64
    let minLength = 6
    let minNameLength = 1
    //MARK:- String Validation
    func removeWhiteSpacesInString(_ string: String) -> String {
        let components = string.components(separatedBy: CharacterSet.whitespacesAndNewlines).filter({!$0.characters.isEmpty})
        return components.joined(separator: "")
    }
    func isContentValid (_ textField: String ) -> TextFieldValidationResult {
        var auxTextField = ""
        auxTextField = removeWhiteSpacesInString(textField)
        if auxTextField.isEmpty {
            return TextFieldValidationResult.empty
        } else if auxTextField.characters.count < minLength {
            return TextFieldValidationResult.not_MINIMUM
        } else if auxTextField.characters.count > maxLength {
            return TextFieldValidationResult.not_MAXIMUM
        } else {
            return TextFieldValidationResult.ok
        }
    }
    func isContentValidForNamesAndSurnames (_ textField: String ) -> TextFieldValidationResult {
        var auxTextField = ""
        auxTextField = removeWhiteSpacesInString(textField)
        if auxTextField.isEmpty {
            return TextFieldValidationResult.empty
        } else if auxTextField.characters.count < minNameLength {
            return TextFieldValidationResult.not_MINIMUM
        } else if auxTextField.characters.count > maxLength {
            return TextFieldValidationResult.not_MAXIMUM
        } else {
            return TextFieldValidationResult.ok
        }
    }
    func isValidEmail(_ testString:String) -> Bool {
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testString)
    }
    func isOnlyAlphabetic(_ textField: UITextField) -> Bool {
        let digits = CharacterSet.decimalDigits
        for tempUnicodeChar in textField.text!.unicodeScalars {
            if digits.contains(UnicodeScalar(tempUnicodeChar.value)!) {
                return false
            }
        }
        return true
    }
    func detectSpecialCharacters(_ testString:String) -> Bool {
        let regex = try! NSRegularExpression(pattern: ".*[^A-Za-z0-9].*", options: [])
        if regex.firstMatch(in: testString, options: [], range: NSMakeRange(0, testString.characters.count)) != nil {
            return true
            } else {
            return false
        }
    }
    func detectWhiteSpaces(_ testString : String)->Bool  {
        let whitespace = CharacterSet.whitespaces
        let phrase = "Test case"
        let range = phrase.rangeOfCharacter(from: whitespace)
        if let _ = range {
            return true
        }
        else {
            return false
        }
    }
    func isSameContent(_ firstTextField: UITextField, secondTextField: UITextField) -> Bool {
        if firstTextField.text == secondTextField.text {
            return true
        } else {
            return false
        }
    }
    //MARK:-Error Message
    func errorMessageForIssueInTextField (_ kindOfIssue: String, texfieldName: String) -> String {
        var errorMessageString = ""
        if kindOfIssue == "notsamestring" {
            errorMessageString = "Password must be the same in both fields"
        } else if kindOfIssue == "minNamelength" {
            errorMessageString = "\(texfieldName) is too short(minimum is \(minNameLength) characters)"
        } else if kindOfIssue == "minlength" {
            errorMessageString = "\(texfieldName) is too short (minimum is \(minLength) characters)"
        } else if kindOfIssue == "maxlength" {
            errorMessageString = "\(texfieldName) is too long (maximum is \(maxLength) characters)"
        } else if kindOfIssue == "empty" {
            errorMessageString = "\(texfieldName) is required and can't be empty"
        } else if kindOfIssue == "stringhasnumbers" {
            errorMessageString = "\(texfieldName) must only contain alphabetic characters"
        } else if kindOfIssue == "email"{
            errorMessageString = "Please enter your email in the format someone@example.com"
        } else if kindOfIssue == "special"{
            errorMessageString = "Please do not use special characters (example:$%&?!@)"
        } else if kindOfIssue == "space"{
            errorMessageString = "Please do not use white spaces"
        }
        return errorMessageString
    }
    
}

//
//  Profile+Extension.swift
//  SnobbiMerchantSide
//
//  Created by MAC on 06/10/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import Foundation
import  UIKit
import FTIndicator
import MapKit
extension ProfileVC{
    //MARK- Pick Image
    func showActionSheet(){
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openCamera()
            
        }
        let gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        {
            UIAlertAction in
            
        }
        // Add the actions
        picker?.allowsEditing = true
        picker?.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        // Present the controller
        if UIDevice.current.userInterfaceIdiom == .phone
        {
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    //Open Camera
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            picker!.sourceType = UIImagePickerControllerSourceType.camera
            self .present(picker!, animated: true, completion: nil)
        }
        else
        {
            //If camera not available open gallery
            openGallary()
        }
    }
    //Open Gallery
    func openGallary()
    {
        picker!.sourceType = UIImagePickerControllerSourceType.photoLibrary
        if UIDevice.current.userInterfaceIdiom == .phone
        {
            self.present(picker!, animated: true, completion: nil)
        }
        
    }
    //Convert Selected to data
    func converToData(_ image:UIImage) -> Data{
        let imageData:NSData = UIImagePNGRepresentation(image)! as NSData
        return imageData as Data
    }
}
//MARK- Extension
extension ProfileVC : UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIPopoverControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        if let chosenImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            boolEditImage = true
          
            imageView_Large.image =   chosenImage.resizeImageWith(newSize: CGSize(width:self.view.frame.size.width, height: 249))
            self.selectedImage = chosenImage
           } else{
            self.selectedImage = UIImage(named:"placeholderImage")
            print("Something went wrong")
        }
        dismiss(animated:true, completion: nil) //5
    }
    //What to do if the image picker cancels.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
//TextField Delegate
extension ProfileVC : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if self.view.frame.origin.y<0{
            self.view.frame.origin.y = 0}
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        activeField = nil
    }
    func textFieldShouldEndEditing(_ _textField: UITextField) -> Bool
    {
        searchResultsTableView.isHidden = true
        return true;
    }
    func textFieldShouldReturn(_ _textField: UITextField) -> Bool {
           searchResultsTableView.isHidden = true
            _textField.resignFirstResponder();
        
        return true;
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        boolEdit = true
         if textField == txtField_Adress{
            
            searchResultsTableView.isHidden = false
        if let text = textField.text as NSString? {
            let txtAfterUpdate = text.replacingCharacters(in: range, with: string)
            print(txtAfterUpdate)
           searchCompleter.queryFragment = txtAfterUpdate
            }
         }else{
            searchResultsTableView.isHidden = true
        }
        return true
    }
}
//    func textField(_ _textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        boolEdit = true
//        if _textField == txtField_Adress{
//            searchResultsTableView.isHidden = false
//            if string.isEmpty
//            {
//                searchString = String(describing: searchString?.characters.dropLast())
//               
//            }
//            else
//            {
//                searchString = _textField.text!+string
//            }
//         print(searchString)
//            searchCompleter.queryFragment = searchString!
//        }
//        else{
//             searchResultsTableView.isHidden = true
//        }
//        return true;
//            }
//    
//    }

//TextViewDelegate
extension ProfileVC:UITextViewDelegate{
    func textViewDidEndEditing(_ textView: UITextView) {
        activeTextView = nil
    }
    
   func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
     activeTextView = textView
     if self.view.frame.origin.y<0{
        self.view.frame.origin.y = 0}
         searchResultsTableView.isHidden = true
         return true
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        boolEdit = true
        return true
    }
    
}
//LocationManagerDelegate
extension ProfileVC: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        searchResultsTableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // handle error
    }
}
//MARK- Extensions
extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
            let searchResult = searchResults[indexPath.row]
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
            cell.textLabel?.text = searchResult.title
            cell.detailTextLabel?.text = searchResult.subtitle
            return cell
    }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let completion = searchResults[indexPath.row]
    txtField_Adress.text = completion.title + "," + completion.subtitle
    searchResultsTableView.isHidden = true
        self.view.endEditing(true)
    let searchRequest = MKLocalSearchRequest(completion: completion)
    let search = MKLocalSearch(request: searchRequest)
    search.start { (response, error) in
        let coordinate = response?.mapItems[0].placemark.coordinate
        print(coordinate!)
        
        
       self.lat =      String((coordinate?.latitude)!)
       self.longi =  String((coordinate?.longitude)!)
        

    
}
    
    }
    
}


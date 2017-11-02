//
//  MenuAddCategory +Extension.swift
//  SnobbiMerchantSide
//
//  Created by MAC on 06/10/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit
extension MenuAddMoreCategoryVC{
    //Select gallery or camera
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
            //camera not available open gallery
            openGallary()
        }
    }
    //open gallery
    func openGallary()
    {
        picker!.sourceType = UIImagePickerControllerSourceType.photoLibrary
        if UIDevice.current.userInterfaceIdiom == .phone
        {
            self.present(picker!, animated: true, completion: nil)
        }
        
    }
    //Convert image to data
    func converToData(_ image:UIImage) -> Data{
        let imageData:NSData = UIImagePNGRepresentation(image)! as NSData
        return imageData as Data
    }
}
//Extension imagepicker
extension MenuAddMoreCategoryVC : UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIPopoverControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        if let chosenImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            btn_SelectImage.setBackgroundImage(chosenImage.resizeImageWith(newSize: CGSize(width: 80, height: 80)), for: .normal)
            self.selectedImage = chosenImage
            boolImageSelectd = true
            
        } else{
            print("Something went wrong")
        }
        dismiss(animated:true, completion: nil) //5
    }
    //What to do if the image picker cancels.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
//textField delegates
extension MenuAddMoreCategoryVC:UITextFieldDelegate{
    func textFieldShouldReturn(_ _textField: UITextField) -> Bool {
        _textField.resignFirstResponder()
        return true;
    }
    
}


//
//  SettingVC+Extension.swift
//  SnobbiMerchantSide
//
//  Created by MAC on 19/09/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit
import MessageUI
import FTIndicator

extension SettingVC{
    //Support
    func showSupportView(){
        supportView.frame = self.view.bounds
        textViewSupport.placeholder = "Type your message here.."
        textViewSupport.delegate = self
        self.view.addSubview(supportView)
        // timeSetupView.fadeIn()
        self.supportView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.supportView.isOpaque = true
        
    }
    func makeCall(urlString: String){
        guard let url = URL(string: "telprompt://" + urlString) else {
            FTIndicator.showToastMessage("Unable to make call")
            return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    func sendEmail() {
        
        composeVC.mailComposeDelegate = self
        // Configure the fields of the interface.
        composeVC.setToRecipients([emailAdmin!])
        composeVC.setSubject("Help")
        composeVC.setMessageBody(textViewSupport.text, isHTML: false)
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
    }
}
extension SettingVC:MFMailComposeViewControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        switch result {
        case .cancelled:
            break
        case .saved:
            break
        case .sent:
            break
        case .failed:
            break
            
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
}
//TextViewDelegate
extension SettingVC:UITextViewDelegate{
    func textViewDidEndEditing(_ textView: UITextView) {
        activeTextView = nil
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        activeTextView = textView
        if self.view.frame.origin.y<0{
            self.view.frame.origin.y = 0}
       
        return true
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
    
}

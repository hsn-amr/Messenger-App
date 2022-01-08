//
//  Extensions.swift
//  Messenger App
//
//  Created by TURKI ALFAISAL on 01/06/1443 AH.
//

import UIKit

extension UIImageView{
    
    func makeCircle(){
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}

extension UIViewController {
    func dismissKeyboardWhenTappedAround(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    //https://stackoverflow.com/questions/24126678/close-ios-keyboard-by-touching-anywhere-using-swift
}



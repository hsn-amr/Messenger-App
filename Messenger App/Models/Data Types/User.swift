//
//  User.swift
//  Messenger App
//
//  Created by TURKI ALFAISAL on 02/06/1443 AH.
//

import Foundation
import UIKit

struct User {
    var uid: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var age: String = ""
    var gender: String = ""
    var image: UIImage?
    var imagePath: String = ""
    var email: String = ""
    var password: String = ""
    
    func getImageUrl() -> String {
        return "gs://messenger-d7cb7.appspot.com/\(self.imagePath)"
    }
}

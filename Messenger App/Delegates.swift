//
//  Delegates.swift
//  Messenger App
//
//  Created by TURKI ALFAISAL on 30/05/1443 AH.
//

import Foundation

protocol UserDelegate{
    func getUserInfo() -> User
    
    func getOtherUser(at index: Int) -> User
}

// to make optional methods 
extension UserDelegate{
    func getUserInfo() -> User {
        return User()
    }
    
    func getOtherUser(at index: Int) -> User {
        return User()
    }
}

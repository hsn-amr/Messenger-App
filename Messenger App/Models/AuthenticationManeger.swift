//
//  AuthenticationManeger.swift
//  Messenger App
//
//  Created by TURKI ALFAISAL on 29/05/1443 AH.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import UIKit


final class AuthManeger{
    
    static func login(user: User, completion: @escaping (Result<String,Error>)->Void ){
        Auth.auth().signIn(withEmail: user.email, password: user.password){
            authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let authUser = authResult{
                if authUser.user.isEmailVerified {
                    completion(.success(authUser.user.uid))
                }else{
                    completion(.success("notVerified"))
                }
            }
        }
    }
    
    static func signup(user: User, completion: @escaping (Result<User,Error>)->Void){
        
        Auth.auth().createUser(withEmail: user.email, password: user.password){
            authResult, error in
            
            if let error = error{
                completion(.failure(error))
                return
            }
            if let authUser = authResult{
                DatabaseManeger.createNewUser(user: user, uid: authUser.user.uid){
                    result in
                    switch result{
                    case .success(let user):
                        self.sendVerificationMail()
                        completion(.success(user))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    static func sendVerificationMail(){
        let user = Auth.auth().currentUser
        if user != nil && !user!.isEmailVerified {
            user!.sendEmailVerification(completion: nil)
        }
    }
    
    static func didHeVerify() -> Bool{
        guard let user = Auth.auth().currentUser else {return false}
        return !user.isEmailVerified
    }
    
    static func getUid() -> String{
        guard let user = Auth.auth().currentUser else {return ""}
        return user.uid
    }
    
    static func getEmail() -> String{
        guard let user = Auth.auth().currentUser else {return ""}
        return user.email!
    }
    
    static func logout() -> Bool{
        var out = false
        do{
            try Auth.auth().signOut()
            out = true
        }catch {
            print("log out error - ", error.localizedDescription)
        }
        return out
    }
    
    static func didHeLoggedin()->Bool{
        if Auth.auth().currentUser != nil {
            return true
        }else{
            return false
        }
    }
}

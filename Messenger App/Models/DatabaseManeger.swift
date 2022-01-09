//
//  DatabaseManeger.swift
//  Messenger App
//
//  Created by TURKI ALFAISAL on 29/05/1443 AH.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import UIKit
import MessageKit

final class DatabaseManeger{
    
    private static let db = Firestore.firestore()
    
    static func createNewUser(user: User, uid: String, completion: @escaping (Result<User,Error>) -> Void){
        
        let path = "\(uid).png"
            let fireStorageRef = Storage.storage().reference().child(path)
            if let uploadData = user.image?.jpegData(compressionQuality: 0.5){
                fireStorageRef.putData(uploadData, metadata: nil) {
                    metadata, error in
                    if error != nil {
                        print("upload image error : " , error!)
                        return
                    }
                }
            }
            
        db.collection(Database.users.rawValue).document(uid).setData([
                Users.firstName.rawValue: user.firstName,
                Users.lastName.rawValue: user.lastName,
                Users.age.rawValue: user.age,
                Users.gender.rawValue: user.gender,
                Users.imagePath.rawValue: path]){
                    error in
                    if let error = error {
                        completion(.failure(error))
                    }else{
                        updateContacts(user: user, uid: uid, imagePath: path){
                            result in
                            switch result{
                            case .success(let user):
                                completion(.success(user))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    }
                }
        
    }
    
    static func getUserData(uid: String, completion: @escaping (Result<User, Error>)->Void ){
        
        db.collection(Database.users.rawValue).document(uid).addSnapshotListener{
            documentSnapshot, error in
            
            guard let data = documentSnapshot?.data() else {
                completion(.failure(error!))
                return
            }
            
            var user = User()
            user.uid = uid
            user.email = AuthManeger.getEmail()
            user.firstName = data[Users.firstName.rawValue] as? String ?? ""
            user.lastName = data[Users.lastName.rawValue] as? String ?? ""
            user.gender = data[Users.gender.rawValue] as? String ?? ""
            user.age = data[Users.age.rawValue] as? String ?? ""
            user.imagePath = data[Users.imagePath.rawValue] as? String ?? ""
            
            downloadImage(user.getImageUrl()){
                result in
                switch result{
                case .success(let image):
                    user.image = image
                    completion(.success(user))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        
    }
    
    static func downloadImage( _ imageUrl: String, completion: @escaping (Result<UIImage,Error>) -> Void){
        Storage.storage().reference(forURL: imageUrl).downloadURL{
            url, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let url = url {
                do{
                    let data = try Data(contentsOf: url)
                    completion(.success(UIImage(data: data)!))
                } catch {
                    completion(.failure(error))
                    return
                }
            }
        }
    }
    
    static func updateUserInfo(user: User, completion: @escaping (Result<User,Error>) -> Void){
        let storageRef = Storage.storage()
        
        let fireStorageRef = storageRef.reference().child(user.imagePath)
        if let uploadData = user.image?.jpegData(compressionQuality: 0.5){
            fireStorageRef.putData(uploadData, metadata: nil) {
                metadata, error in
                if error != nil {
                    print("upload image error : " , error!)
                    completion(.failure(error!))
                    return
                }
            }
        }
        
        db.collection(Database.users.rawValue).document(user.uid).setData([
                Users.firstName.rawValue: user.firstName,
                Users.lastName.rawValue: user.lastName,
                Users.age.rawValue: user.age,
                Users.gender.rawValue: user.gender,
                Users.imagePath.rawValue: user.imagePath]){
                    error in
                    if let error = error {
                        completion(.failure(error))
                    }else{
                        updateContacts(user: user, uid: user.uid, imagePath: user.imagePath){
                            result in
                            switch result{
                            case .success(let user):
                                completion(.success(user))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                        updateUserInfoInChat(user: user, uid: user.uid, imagePath: user.imagePath){
                            result in
                            switch result{
                            case .success(let user):
                                completion(.success(user))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    }
                }
    }
    
    static func updateContacts(user: User, uid: String, imagePath: String, completion: @escaping (Result<User,Error>) -> Void){
        
        db.collection(Database.contatcs.rawValue).document(uid).setData([
            Users.firstName.rawValue: user.firstName,
            Users.lastName.rawValue: user.lastName,
            Users.imagePath.rawValue: imagePath
        ]){
            error in
            if let error = error {
                completion(.failure(error))
            }else{
                completion(.success(user))
            }
        }
        
    }
    
    static func updateUserInfoInChat(user: User, uid: String, imagePath: String, completion: @escaping (Result<User,Error>) -> Void){
        db.collection(Database.chats.rawValue).getDocuments{
            documents, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let chats = documents?.documents else {
                completion(.failure(error!))
                return
            }
            
            for i in 0..<chats.count {
                if chats[i].data().keys.first == uid{
                    let id = chats[i].documentID
                    let key = chats[i].data().keys.first
                    let chat = chats[i].data().values.first as! NSDictionary
                    db.collection(Database.chats.rawValue).document(id).setData([
                        key! :
                            [
                                Chats.conversationId.rawValue: chat[Chats.conversationId.rawValue],
                                Users.otherUserFirstName.rawValue: user.firstName,
                                Users.otherUserLastName.rawValue: user.lastName,
                                Users.otherUserImagePath.rawValue: user.imagePath,
                                Chats.lastMessageText.rawValue: chat[Chats.lastMessageText.rawValue],
                                Messages.sendDate.rawValue: chat[Messages.sendDate.rawValue],
                                Messages.isRead.rawValue: chat[Messages.isRead.rawValue],
                                Messages.type.rawValue: chat[Messages.type.rawValue]
                            ]
                    ])
                }
            }
            completion(.success(user))
        }
    }
    
    static func getAllContacts(completion: @escaping (Result<[User],Error>) -> Void){
        db.collection(Database.contatcs.rawValue).addSnapshotListener{
            documentSnapshot, error in
            guard let documents = documentSnapshot?.documents else {
                completion(.failure(error!))
                return
            }
            var contacts = [User]()
            for contact in documents{
                print("ccc", contact.documentID)
                if contact.documentID != AuthManeger.getUid(){
                    var user = User()
                    user.uid = contact.documentID
                    user.firstName = contact.data()[ Users.firstName.rawValue] as! String
                    user.lastName = contact.data()[Users.lastName.rawValue] as! String
                    user.imagePath = contact.data()[Users.imagePath.rawValue] as! String
                    contacts.append(user)
                }
            }
            
            for i in 0..<contacts.count {
                downloadImage(contacts[i].getImageUrl()){
                    result in
                    switch result{
                    case .success(let image):
                        contacts[i].image = image
                        completion(.success(contacts))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    static func isTherePreConversation(currentUserId: String, otherUserId: String, completion: @escaping (Result<String,Error>) -> Void){
        
        db.collection(Database.chats.rawValue).document(currentUserId).getDocument{
            document, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = document?.data() else {
                let error = NSError(domain: "There is no id for conversation", code: 400, userInfo: nil)
                completion(.failure(error))
                return
            }
            
            for chat in data {
                if chat.key == otherUserId{
                    let currentChat = chat.value as! NSDictionary
                    let conversationId = currentChat[Chats.conversationId.rawValue] as! String
                    completion(.success(conversationId))
                }
            }
            
        }
        
    }
    
    static func addChat(chat: Chat, completion: @escaping (Result<Chat,Error>)->Void){
        let chatsRef = db.collection(Database.chats.rawValue)
        
        // current user
        chatsRef.document(chat.currentUserId).setData([
            chat.otherUserId :
                [
                    Chats.conversationId.rawValue: chat.conversationId,
                    Users.otherUserFirstName.rawValue: chat.otherUser.firstName,
                    Users.otherUserLastName.rawValue: chat.otherUser.lastName,
                    Users.otherUserImagePath.rawValue: chat.otherUser.imagePath,
                    Chats.lastMessageText.rawValue: chat.lastMessageText,
                    Messages.sendDate.rawValue: Timestamp(date: chat.sendDate as Date),
                    Messages.isRead.rawValue: chat.isRead,
                    Messages.type.rawValue: chat.type
                ]
        ], merge: true){
            error in
            if let addingError = error{
                completion(.failure(addingError))
                return
            }
            completion(.success(chat))
        }
        
        // other user
        chatsRef.document(chat.otherUserId).setData([
            chat.currentUserId :
                [
                    Chats.conversationId.rawValue: chat.conversationId,
                    Users.otherUserFirstName.rawValue: chat.currentUser.firstName,
                    Users.otherUserLastName.rawValue: chat.currentUser.lastName,
                    Users.otherUserImagePath.rawValue: chat.currentUser.imagePath,
                    Chats.lastMessageText.rawValue: chat.lastMessageText,
                    Messages.sendDate.rawValue: Timestamp(date: chat.sendDate as Date),
                    Messages.isRead.rawValue: chat.isRead,
                    Messages.type.rawValue: chat.type
                ]
        ], merge: true){
            error in
            if let addingError = error{
                completion(.failure(addingError))
                return
            }
            completion(.success(chat))
        }
        
    }
    
    
    static func getAllChats(currentUserId: String, completion: @escaping (Result<[Chat],Error>)->Void){
        db.collection(Database.chats.rawValue).document(currentUserId).addSnapshotListener{
            documentSnapshot, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = documentSnapshot?.data() else {
                let error = NSError(domain: "There is no chats for user", code: 400, userInfo: nil)
                completion(.failure(error))
                return
            }
            var allChats = [Chat]()
            
            for chat in data {
                let chatInfo = chat.value as! NSDictionary
                let conversationId = chatInfo[Chats.conversationId.rawValue] as! String
                
                let uid = chat.key
                let firstName = chatInfo[Users.otherUserFirstName.rawValue] as! String
                let lastName = chatInfo[Users.otherUserLastName.rawValue] as! String
                let imagePath = chatInfo[Users.otherUserImagePath.rawValue] as! String
                let otherUser = User(uid: uid, firstName: firstName, lastName: lastName,imagePath: imagePath)
                
                let lastMessageText = chatInfo[Chats.lastMessageText.rawValue] as! String
                let sendDate = chatInfo[Messages.sendDate.rawValue] as! Timestamp
                let isRead = chatInfo[Messages.isRead.rawValue] as! Bool
                let type = chatInfo[Messages.type.rawValue] as! String
                
                allChats.append(Chat(currentUserId: "", currentUser: User(), otherUserId: "", otherUser: otherUser, conversationId: conversationId, lastMessageText: lastMessageText, sendDate: sendDate.dateValue(), isRead: isRead, type: type))
            }
            
            for i in 0..<allChats.count {
                downloadImage(allChats[i].otherUser.getImageUrl()){
                    result in
                    switch result{
                    case .success(let image):
                        allChats[i].otherUser.image = image
                        completion(.success(allChats))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
        
    }
    
    static func sendMessage(conversationId: String, newMessage: Message, completion: @escaping (Result<String,Error>) -> Void){
        
        var conversationsRef: DocumentReference?
        if conversationId == ""{
            conversationsRef = db.collection(Database.conversations.rawValue).document()
        }else{
            conversationsRef = db.collection(Database.conversations.rawValue).document(conversationId)
        }
        
        let messageRef = conversationsRef!.collection(Database.messeges.rawValue).document()
        
        messageRef.setData([
            Messages.content.rawValue: newMessage.content,
            Messages.isRead.rawValue: newMessage.isRead,
            Messages.sendDate.rawValue: Timestamp(date: newMessage.sentDate),
            Messages.sender.rawValue: newMessage.sender.senderId,
            Messages.type.rawValue: newMessage.type
        ]){
            error in
            if let sendError = error {
                completion(.failure(sendError))
                return
            }
            completion(.success(conversationsRef!.documentID))
        }
    }
    
    static func getMessages(conversationId: String, completion: @escaping (Result<[Message],Error>) -> Void){
    
        let conversationsRef = db.collection(Database.conversations.rawValue).document(conversationId)
        let messagesRef = conversationsRef.collection(Database.messeges.rawValue).order(by: Messages.sendDate.rawValue, descending: false)
        
        messagesRef.addSnapshotListener{
            documentSnapshot, error in
            guard let documents = documentSnapshot?.documents else {
                completion(.failure(error!))
                return
            }
            
            var allMessages = [Message]()
            for document in documents {
                
                let senderId = document.data()[Messages.sender.rawValue] as! String
                let sebderType = Sender(senderId: senderId, displayName: "")
                
                let messageId = document.documentID
                let sentDate = document.data()[Messages.sendDate.rawValue] as! Timestamp
                let content = document.data()[Messages.content.rawValue] as! String
                let type = document.data()[Messages.type.rawValue] as! String
                let isRead = document.data()[Messages.isRead.rawValue] as! Bool
                
                allMessages.append(Message(sender: sebderType, messageId: messageId, sentDate: sentDate.dateValue(), kind: .attributedText(NSAttributedString(string: content)), content: content, type: type, isRead: isRead))
            }
            completion(.success(allMessages))
        }
    }
    
}



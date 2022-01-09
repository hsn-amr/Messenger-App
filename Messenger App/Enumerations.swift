//
//  Enumerations.swift
//  Messenger App
//
//  Created by TURKI ALFAISAL on 03/06/1443 AH.
//

import Foundation

enum Database: String {
    case users = "users"
    case contatcs = "contacts"
    case chats = "chats"
    case conversations = "conversations"
    case messeges = "messages"
}

enum Users: String {
    case firstName = "firstName"
    case lastName = "lastName"
    case imagePath = "imagePath"
    case age = "age"
    case gender = "gender"
    case otherUserFirstName = "otherUserFirstName"
    case otherUserLastName = "otherUserLastName"
    case otherUserImagePath = "otherUserImagePath"
}

enum Chats: String {
    case conversationId = "conversationId"
    case otherUser = "otherUser"
    case lastMessageText = "lastMessageTest"
}

enum Messages: String {
    case content = "content"
    case sender = "sender"
    case sendDate = "sendDate"
    case isRead = "isRead"
    case type = "type"
}

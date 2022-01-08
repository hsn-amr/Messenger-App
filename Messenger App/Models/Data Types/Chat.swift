//
//  Chat.swift
//  Messenger App
//
//  Created by TURKI ALFAISAL on 03/06/1443 AH.
//

import Foundation

struct Chat {
    var currentUserId: String 
    
    var currentUser: User
    
    var otherUserId: String
    
    var otherUser: User
    
    var conversationId: String
    
    var lastMessageText: String
    
    var sendDate: Date
    
    var isRead: Bool
    
    var type: String
}

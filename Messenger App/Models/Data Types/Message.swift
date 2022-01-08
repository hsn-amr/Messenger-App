//
//  Message.swift
//  Messenger App
//
//  Created by TURKI ALFAISAL on 02/06/1443 AH.
//

import Foundation
import MessageKit

struct Message: MessageType{
    
    var sender: SenderType
    
    var messageId: String
    
    var sentDate: Date
    
    var kind: MessageKind
    
    var content: String
    
    var type: String
    
    var isRead: Bool
    
}

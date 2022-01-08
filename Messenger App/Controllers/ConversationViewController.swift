//
//  ConversationViewController.swift
//  Messenger App
//
//  Created by TURKI ALFAISAL on 02/06/1443 AH.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class ConversationViewController: MessagesViewController, MessagesDataSource, MessagesDisplayDelegate, MessagesLayoutDelegate {
    
    
    let header = ConversationHeaderView()
    var users: UserDelegate?
    var conversationId: String = ""
    var index = 0
    
    private var currentUser = Sender(senderId: "", displayName: "")
    private var otherUser = Sender(senderId: "", displayName: "")
    
    private var messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        messagesCollectionView.messagesCollectionViewFlowLayout.setMessageIncomingAvatarSize(.zero)
        messagesCollectionView.messagesCollectionViewFlowLayout.setMessageOutgoingAvatarSize(.zero)
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        
        if let currentUserInfo = users?.getUserInfo(),
           let otherUserInfo = users?.getOtherUser(at: index){
            currentUser.senderId = currentUserInfo.uid
            otherUser.senderId = otherUserInfo.uid
            
            header.otherUserNameLabel.text = "\(otherUserInfo.firstName) \(otherUserInfo.lastName)"
            header.otherUserImageView.image = otherUserInfo.image
        }
        
        header.setupHeader(self.view)
        
        if conversationId != "" {
            getAllMessages(conversationId: conversationId)
        }else{
            DatabaseManeger.isTherePreConversation(currentUserId: currentUser.senderId, otherUserId: otherUser.senderId){
                result in
                switch result{
                case .success(let conversationId):
                    self.conversationId = conversationId
                    self.getAllMessages(conversationId: conversationId)
                case .failure(let error):
                    print("error",error)
                }
            }
        }
    }
    
    func getAllMessages(conversationId: String){
        DatabaseManeger.getMessages(conversationId: conversationId){
            result in
            switch result{
            case .success(let messages):
                self.messages = messages
                self.messagesCollectionView.reloadData()
                self.messagesCollectionView.scrollToLastItem(at: .bottom, animated: true)
            case .failure(let error):
                print(error)
            }
        }
    }
    @objc func goBack(sender: UIButton){
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        messagesCollectionView.contentInset.top = header.getInset()
        messagesCollectionView.contentInset.bottom = messageInputBar.frame.height
        header.otherUserImageView.makeCircle()
        header.backButton.addTarget(self, action: #selector(goBack(sender:)), for: .touchUpInside)
    }
    
    func formatDate(date: Date, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    func currentSender() -> SenderType {
        return currentUser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let date = formatDate(date: message.sentDate, format: "EEEE, dd/MM/yyyy")
        let font = UIFont.preferredFont(forTextStyle: .body)
        font.withSize(10)
        let attributes = [NSAttributedString.Key.font: font]
        return NSAttributedString(string: date, attributes: attributes)
    }
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 10
    }
    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let time = formatDate(date: message.sentDate, format: "h:mm a")
        let font = UIFont.preferredFont(forTextStyle: .body)
        font.withSize(10)
        let attributes = [NSAttributedString.Key.font: font]
        return NSAttributedString(string: time, attributes: attributes)
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 10
    }
}

extension ConversationViewController: InputBarAccessoryViewDelegate{
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
    
        guard let currentUserInfo = users?.getUserInfo() else {return}
        guard let otherUserInfo = users?.getOtherUser(at: index) else {return}
        let message = Message(sender: currentUser, messageId: "", sentDate: Date(), kind: .attributedText(NSAttributedString(string: text)), content: text, type: text, isRead: false)
        
        DatabaseManeger.sendMessage(conversationId: conversationId, newMessage: message){
            result in
            switch result{
            case .success(let conversationId):
                if self.conversationId == "" {
                    self.conversationId = conversationId
                    self.getAllMessages(conversationId: conversationId)
                }
                inputBar.inputTextView.text = ""
                let chat = Chat(currentUserId: self.currentUser.senderId, currentUser: currentUserInfo, otherUserId: self.otherUser.senderId, otherUser: otherUserInfo, conversationId: conversationId, lastMessageText: text, sendDate: Date(), isRead: false, type: "text")
                DatabaseManeger.addChat(chat: chat){
                    result in
                }
            case .failure(let error):
                print(error)
            }
        }
        
    }
}

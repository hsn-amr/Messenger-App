//
//  ChatsViewController.swift
//  Messenger App
//
//  Created by TURKI ALFAISAL on 29/05/1443 AH.
//

import UIKit

class ChatsViewController: UIViewController {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let spinner = Spinner()
    
    let uid = AuthManeger.getUid()
    var user: User?
    
    var chats = [Chat]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tabBarController?.delegate = self
        
        userImage.makeCircle()
        setActionToUserImage()
        
        getUserData()
        getAllChats()
    }
    
    
    func getAllChats(){
        DatabaseManeger.getAllChats(currentUserId: uid){
            result in
            self.spinner.stopSpinner(mainView: self.view)
            switch result{
            case .success(let chats):
                self.chats = chats
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getUserData(){
        spinner.startSpinner(mainView: self.view)
        DatabaseManeger.getUserData(uid: uid, completion: {
            result in
            self.spinner.stopSpinner(mainView: self.view)
            switch result{
            case .success(let user):
                self.user = user
                self.userImage.image = user.image
                self.userNameLabel.text = "\(user.firstName) \(user.lastName)"
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func setActionToUserImage(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped(tapGestureRecognizer:)))
        userImage.isUserInteractionEnabled = true
        userImage.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc func profileImageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        let profileVC = storyboard?.instantiateViewController(withIdentifier: "profileViewController") as! ProfileViewController
        profileVC.userDelegate = self
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        
    }
}

extension ChatsViewController: UserDelegate{
    func getUserInfo() -> User {
        return self.user!
    }
    
    func getOtherUser(at index: Int) -> User {
        return chats[index].otherUser
    }
}

extension ChatsViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as! ChatTableViewCell
        
        let chat = chats[indexPath.row]
        cell.nameLabel.text = "\(chat.otherUser.firstName) \(chat.otherUser.lastName)"
        cell.chatTextLabel.text = chat.lastMessageText
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let conversationVC = ConversationViewController()
        conversationVC.index = indexPath.row
        conversationVC.conversationId = chats[indexPath.row].conversationId
        conversationVC.users = self
        
        navigationController?.pushViewController(conversationVC, animated: true)
    }
}

extension ChatsViewController: UITabBarControllerDelegate{
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        if let contactsVC = viewController as? ContactsViewController {
            contactsVC.user = self.user
        }
    }
}

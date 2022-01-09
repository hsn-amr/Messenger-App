//
//  ContactsViewController.swift
//  Messenger App
//
//  Created by TURKI ALFAISAL on 29/05/1443 AH.
//

import UIKit

class ContactsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let spinner = Spinner()
    let refreshControl = UIRefreshControl()

    var user: User?
    var contacts = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        setupRefreshControl()
        getAllContacts()
    }
    
    
    func getAllContacts(){
        spinner.startSpinner(mainView: self.view)
        DatabaseManeger.getAllContacts{
            result in
            switch result{
            case .success(let users):
                self.contacts = users
                self.tableView.reloadData()
                self.spinner.stopSpinner(mainView: self.view)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func setupRefreshControl(){
        refreshControl.addTarget(self, action: #selector(refreshAction(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc func refreshAction(_ sender: AnyObject){
        getAllContacts()
        refreshControl.endRefreshing()
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
    }
    
}

extension ContactsViewController: UserDelegate{
    
    func getUserInfo() -> User {
        return self.user!
    }
    
    func getOtherUser(at index: Int) -> User {
        return contacts[index]
    }
}

extension ContactsViewController: UITableViewDataSource, UITableViewDelegate{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! ContactTableViewCell
        cell.contactImage.image = contacts[indexPath.row].image
        cell.contactNameLabel.text = "\(contacts[indexPath.row].firstName) \(contacts[indexPath.row].lastName)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let conversationVC = ConversationViewController()
        conversationVC.index = indexPath.row
        conversationVC.conversationId = ""
        conversationVC.users = self
        
        navigationController?.pushViewController(conversationVC, animated: true)
    }
}

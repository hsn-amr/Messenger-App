//
//  LoginViewController.swift
//  Messenger App
//
//  Created by TURKI ALFAISAL on 28/05/1443 AH.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginPageIcon: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    let spinner = Spinner()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginPageIcon.image = UIImage(named: "MessengerIcon")
        if AuthManeger.didHeLoggedin(){
            let mainTabBarController = self.storyboard?.instantiateViewController(withIdentifier: "mainTabBarController") as! UITabBarController
            self.navigationController?.pushViewController(mainTabBarController, animated: true)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        if AuthManeger.didHeVerify() {
            errorLabel.text = "Please verify your email then log in."
        }
    }
    
    
    @IBAction func newUserButtonPressed(_ sender: UIButton) {
        let signupVC = storyboard?.instantiateViewController(withIdentifier: "signupViewController") as! SignupViewController
        navigationController?.pushViewController(signupVC, animated: true)
    }

    @IBAction func forgetOasswordButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        self.spinner.startSpinner(mainView: self.view)
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        if !email.isEmpty && !password.isEmpty {
            var user = User()
            user.email = email
            user.password = password
            
            AuthManeger.login(user: user){
                result in
                self.spinner.stopSpinner(mainView: self.view)
                switch result{
                case .success(let uid):
                    if uid == "notVerified"{
                        self.errorLabel.text = "Please, verify your email first"
                    }else{
                        self.errorLabel.text = ""
                        let mainTabBarController = self.storyboard?.instantiateViewController(withIdentifier: "mainTabBarController") as! UITabBarController
                        self.navigationController?.pushViewController(mainTabBarController, animated: true)
                    }
                case .failure(let error):
                    self.errorLabel.text = error.localizedDescription
                    print(error)
                }
            }
        } else {self.spinner.stopSpinner(mainView: self.view)}
    }
}

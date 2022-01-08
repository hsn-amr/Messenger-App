//
//  SignupViewController.swift
//  Messenger App
//
//  Created by TURKI ALFAISAL on 28/05/1443 AH.
//

import UIKit

class SignupViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    let spinner = Spinner()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signupButtonPressed(_ sender: UIButton) {
        spinner.startSpinner(mainView: self.view)
        guard let image = userImage.image else {return}
        guard let firstName = firstNameTextField.text else {return}
        guard let lastName = lastNameTextField.text else {return}
        guard let age = ageTextField.text else {return}
        guard let gender = genderTextField.text else {return}
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        if !firstName.isEmpty && !lastName.isEmpty && !age.isEmpty && !gender.isEmpty && !email.isEmpty && !password.isEmpty {
            let user = User(firstName: firstName, lastName: lastName, age: age, gender: gender, image: image, email: email, password: password)
            
            AuthManeger.signup(user: user){
                result in
                self.spinner.stopSpinner(mainView: self.view)
                switch result{
                case .success( _):
                    self.errorLabel.text = ""
                    self.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    self.errorLabel.text = error.localizedDescription
                    print("error sing up - \(error.localizedDescription)")
                }
            }
        }else {spinner.stopSpinner(mainView: self.view)}
    }
    
    @IBAction func chooseImageButtonPressed(_ sender: UIButton) {
        let imagepickerVC = UIImagePickerController()
        imagepickerVC.sourceType = .photoLibrary
        imagepickerVC.delegate = self
        present(imagepickerVC, animated: true, completion: nil)
    }
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[.originalImage] as? UIImage {
            userImage.image = image
        }
    }
}

//
//  ProfileViewController.swift
//  Messenger App
//
//  Created by TURKI ALFAISAL on 29/05/1443 AH.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var chooseImageButton: UIButton!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var updateButton: UIButton!
    let spinner = Spinner()
    
    var userDelegate: UserDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = false
        chooseImageButton.isHidden = true
        updateButton.isHidden = true
        
        if let user = userDelegate?.getUserInfo() {
            userImage.image = user.image
            firstNameTextField.text = user.firstName
            lastNameTextField.text = user.lastName
            ageTextField.text = user.age
            genderTextField.text = user.gender
            emailLabel.text = user.email
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func chooseImageButtonPressed(_ sender: UIButton) {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.sourceType = .photoLibrary
        imagePickerVC.delegate = self
        present(imagePickerVC, animated: true, completion: nil)
    }
    
    @IBAction func updatePenButtonPressed(_ sender: UIButton) {
        chooseImageButton.isHidden = false
        updateButton.isHidden = false
        
        firstNameTextField.isEnabled = true
        lastNameTextField.isEnabled = true
        ageTextField.isEnabled = true
        genderTextField.isEnabled = true
    }
    
    @IBAction func updateButtonPressed(_ sender: UIButton) {
        spinner.startSpinner(mainView: self.view)
        if let firstNmae = firstNameTextField.text,
           let lastName = lastNameTextField.text,
           let age = ageTextField.text,
           let gender = genderTextField.text,
           let imageUrl = userDelegate?.getUserInfo().imageUrl{
            var user = User()
            user.image = userImage.image
            user.firstName = firstNmae
            user.lastName = lastName
            user.age = age
            user.gender = gender
            user.imageUrl = imageUrl
            DatabaseManeger.updateUserInfo(user: user){
                result in
                self.spinner.stopSpinner(mainView: self.view)
                switch result{
                case .success(let uid):
                    self.chooseImageButton.isHidden = true
                    self.updateButton.isHidden = true
                    
                    self.firstNameTextField.isEnabled = false
                    self.lastNameTextField.isEnabled = false
                    self.ageTextField.isEnabled = false
                    self.genderTextField.isEnabled = false
                    print(uid)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        spinner.startSpinner(mainView: self.view)
        if AuthManeger.logout(){
            spinner.stopSpinner(mainView: self.view)
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[.originalImage] as? UIImage{
            userImage.image = image
        }
    }

}

//
//  ConversationHeaderView.swift
//  Messenger App
//
//  Created by TURKI ALFAISAL on 03/06/1443 AH.
//

import UIKit

class ConversationHeaderView {

    let view = UIView()
    let stackViewHorizontally = UIStackView()
    let backButton = UIButton()
    let otherUserImageView = UIImageView()
    let otherUserNameLabel = UILabel()
    
    
    func setupHeader(_ mainView: UIView){
        mainView.addSubview(stackViewHorizontally)
        stackViewHorizontally.backgroundColor = .systemGray6
        stackViewHorizontally.distribution = .equalSpacing
        stackViewHorizontally.alignment = .center
        
        stackViewHorizontally.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: stackViewHorizontally, attribute: .top, relatedBy: .equal, toItem: mainView.layoutMarginsGuide, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: stackViewHorizontally, attribute: .leading, relatedBy: .equal, toItem: mainView, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: stackViewHorizontally, attribute: .trailing, relatedBy: .equal, toItem: mainView, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: stackViewHorizontally, attribute: .height, relatedBy: .equal, toItem: mainView, attribute: .height, multiplier: 0.1, constant: 0).isActive = true
        
        stackViewHorizontally.addSubview(backButton)
        backButton.setTitle("back", for: .normal)
        backButton.backgroundColor = .blue
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: backButton, attribute: .width, relatedBy: .equal, toItem: stackViewHorizontally, attribute: .width, multiplier: 0.1, constant: 0).isActive = true
        NSLayoutConstraint(item: backButton, attribute: .height, relatedBy: .equal, toItem: stackViewHorizontally, attribute: .height, multiplier: 1, constant: 0).isActive = true
        
        stackViewHorizontally.addSubview(otherUserImageView)
        otherUserImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: otherUserImageView, attribute: .width, relatedBy: .equal, toItem: stackViewHorizontally, attribute: .width, multiplier: 0.2, constant: 0).isActive = true
        NSLayoutConstraint(item: otherUserImageView, attribute: .height, relatedBy: .equal, toItem: stackViewHorizontally, attribute: .height, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: otherUserImageView, attribute: .leading, relatedBy: .equal, toItem: backButton, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        
        
        stackViewHorizontally.addSubview(otherUserNameLabel)
        otherUserNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: otherUserNameLabel, attribute: .width, relatedBy: .equal, toItem: stackViewHorizontally, attribute: .width, multiplier: 0.6, constant: 0).isActive = true
        NSLayoutConstraint(item: otherUserNameLabel, attribute: .height, relatedBy: .equal, toItem: stackViewHorizontally, attribute: .height, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: otherUserNameLabel, attribute: .leading, relatedBy: .equal, toItem: otherUserImageView, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        
        mainView.addSubview(view)
        view.backgroundColor = .systemGray6
        
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: mainView, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: mainView, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: mainView, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self.stackViewHorizontally, attribute: .top, multiplier: 1, constant: 0).isActive = true
    }
    
    func getInset() -> CGFloat{
        return self.stackViewHorizontally.frame.height
    }
}

//
//  Spinners.swift
//  Messenger App
//
//  Created by TURKI ALFAISAL on 01/06/1443 AH.
//

import Foundation
import UIKit

final class Spinner{
    
    private var spinner = UIActivityIndicatorView()
    
    init(){
        self.spinner.style = .large
        self.spinner.hidesWhenStopped = true
        self.spinner.color = .black
        self.spinner.backgroundColor = .systemGray4
        self.spinner.frame = CGRect(x: 0, y: 0, width: 100.0, height: 100.0)
        self.spinner.isUserInteractionEnabled = false
    }
    
    func startSpinner(mainView: UIView){
        self.spinner.center = mainView.center
        mainView.addSubview(self.spinner)
        mainView.isUserInteractionEnabled = false
        self.spinner.startAnimating()
    }
    
    func stopSpinner(mainView: UIView){
        self.spinner.stopAnimating()
        mainView.isUserInteractionEnabled = true
        self.spinner.removeFromSuperview()
    }
}

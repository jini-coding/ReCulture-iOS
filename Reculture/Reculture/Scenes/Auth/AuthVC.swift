//
//  AuthVC.swift
//  Reculture
//
//  Created by Jini on 4/26/24.
//

import UIKit

class AuthVC: UIViewController {

    let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "AuthVC"
        label.textColor = UIColor.blue
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        setupTitleLabel()
    }
    
    func setupTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

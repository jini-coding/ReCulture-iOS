//
//  EditPasswordVC.swift
//  ReCulture
//
//  Created by Jini on 5/17/24.
//

import UIKit

class EditPasswordVC: UIViewController {

    let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "EditPasswordVC"
        label.textColor = UIColor.rcMain
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        setupNavigationBar()
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
    
    func setupNavigationBar() {
        self.navigationItem.title = "비밀번호 변경"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.rcFont18B()]
        self.navigationController?.navigationBar.setBackgroundImage(nil, for:.default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.layoutIfNeeded()
        
    }
}


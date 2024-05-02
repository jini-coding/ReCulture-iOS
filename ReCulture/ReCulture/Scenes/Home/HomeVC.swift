//
//  HomeVC.swift
//  ReCulture
//
//  Created by Jini on 5/3/24.
//

import UIKit

class HomeVC: UIViewController {
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "HomeVC"
        label.textColor = UIColor.rcMain
        label.font = UIFont.rcFont26B()
        
        return label
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setTestLabel()
    }
    
    func setTestLabel() {
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
            label.heightAnchor.constraint(equalToConstant: 23)
        ])
    }
}

//
//  SearchVC.swift
//  Reculture
//
//  Created by Jini on 4/26/24.
//

import UIKit

class SearchVC: UIViewController {
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "SearchVC"
        label.textColor = UIColor.blue
        
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

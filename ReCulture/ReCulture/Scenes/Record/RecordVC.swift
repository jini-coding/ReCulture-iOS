//
//  RecordVC.swift
//  ReCulture
//
//  Created by Jini on 5/3/24.
//

import UIKit

class RecordVC: UIViewController {
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "RecordVC"
        label.textColor = UIColor.blue
        
        return label
    }()
    
    let tmpButton: UIButton = {
        let button = UIButton()
        button.setTitle("티켓북 보기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(goToTicketBook), for: .touchUpInside)
        return button
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setTestLabel()
        
        tmpButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tmpButton)
        NSLayoutConstraint.activate([
            tmpButton.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            tmpButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 5)
        ])
        
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

    @objc func goToTicketBook(){
        self.navigationController?.pushViewController(TicketBookVC(), animated: true)
    }
}


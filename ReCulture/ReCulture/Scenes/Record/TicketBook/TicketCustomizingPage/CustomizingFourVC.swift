//
//  CustomizingFourVC.swift
//  ReCulture
//
//  Created by Jini on 6/2/24.
//

import UIKit

class CustomizingFourVC: UIViewController {

    let guideLabel: UILabel = {
        let label = UILabel()
        label.text = "이대로 티켓을 완성할까요?"
        label.font = UIFont.rcFont24B()
        label.numberOfLines = 0
        
        return label
    }()
    
    let ticketImage: UIImageView = {
        let imageview = UIImageView()
        imageview.backgroundColor = UIColor.rcGray300
        imageview.layer.cornerRadius = 16
        
        return imageview
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        setupGuide()
        setupImage()
    }
    
    func setupGuide() {
        guideLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(guideLabel)
        
        NSLayoutConstraint.activate([
            guideLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 6),
            guideLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            guideLabel.heightAnchor.constraint(equalToConstant: 72)
        ])
    }
    
    func setupImage() {
        ticketImage.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(ticketImage)
        
        NSLayoutConstraint.activate([
            ticketImage.topAnchor.constraint(equalTo: guideLabel.bottomAnchor, constant: 25),
            ticketImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ticketImage.heightAnchor.constraint(equalToConstant: 400),
            ticketImage.widthAnchor.constraint(equalToConstant: 280)
        ])
    }
    
}

//
//  CustomizingOneVC.swift
//  ReCulture
//
//  Created by Jini on 6/2/24.
//

import UIKit

class CustomizingOneVC: UIViewController {
    
    let guideLabel: UILabel = {
        let label = UILabel()
        label.text = "티켓 틀을 골라주세요"
        label.font = UIFont.rcFont24B()
        label.numberOfLines = 0
        
        return label
    }()
    
    let ticketFrameImage: UIImageView = {
        let imageview = UIImageView()
        imageview.backgroundColor = UIColor.rcGray300
        
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
        ticketFrameImage.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(ticketFrameImage)
        
        NSLayoutConstraint.activate([
            ticketFrameImage.topAnchor.constraint(equalTo: guideLabel.bottomAnchor, constant: 25),
            ticketFrameImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ticketFrameImage.heightAnchor.constraint(equalToConstant: 400),
            ticketFrameImage.widthAnchor.constraint(equalToConstant: 280)
        ])
    }
    
}


//
//  AddPhotoButtonView.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 5/31/24.
//

import UIKit

class AddPhotoButtonView: UIView {
    
    // MARK: - Views
    
    private let addImageView: UIImageView = {
        let view = UIImageView()
        view.image = .addIcon.withTintColor(.rcGray300)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let addPhotoLabel: UILabel = {
        let label = UILabel()
        label.text = "사진을 최대 5장까지\n추가해보세요!"
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = .rcFont14M()
        label.textColor = .rcGray300
        label.isUserInteractionEnabled = true
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isUserInteractionEnabled = true
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
        
        setAddImageView()
        setAddPhotoLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        self.setDotLineWithCornerRadius(color: .rcGray300, radius: 12)
    }
    
    // MARK: - Layout
    
    private func setAddImageView(){
        addImageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(addImageView)
        
        NSLayoutConstraint.activate([
            addImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 35),
            addImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            addImageView.widthAnchor.constraint(equalToConstant: 28),
            addImageView.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    private func setAddPhotoLabel(){
        addPhotoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(addPhotoLabel)
        
        NSLayoutConstraint.activate([
            addPhotoLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            addPhotoLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
            addPhotoLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -25),
            addPhotoLabel.topAnchor.constraint(equalTo: addImageView.bottomAnchor, constant: 32)
        ])
    }
}

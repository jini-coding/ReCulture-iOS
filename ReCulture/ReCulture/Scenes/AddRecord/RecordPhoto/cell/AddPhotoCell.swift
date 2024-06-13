//
//  AddPhotoCell.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 6/1/24.
//

import UIKit

class AddPhotoCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "AddPhotoCell"
    
    // MARK: - Views
    
    private let addPhotoView = AddPhotoButtonView()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 12
        
        setAddPhotoView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func draw(_ rect: CGRect) {
//        contentView.setDotLineWithCornerRadius(color: .rcGray300, radius: 12)
//    }
    
    // MARK: - Layout
    
    private func setAddPhotoView(){
        addPhotoView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(addPhotoView)
        
        NSLayoutConstraint.activate([
            addPhotoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            addPhotoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            addPhotoView.topAnchor.constraint(equalTo: contentView.topAnchor),
            addPhotoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}

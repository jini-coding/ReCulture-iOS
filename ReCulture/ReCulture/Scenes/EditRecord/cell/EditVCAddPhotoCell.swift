//
//  AddPhotoCell.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 9/17/24.
//

import UIKit

final class EditVCAddPhotoCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "EditVCAddPhotoCell"
    
    // MARK: - Views
    
    private let containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let plusImageView: UIImageView = {
        let view = UIImageView()
        view.image = .addIcon.withTintColor(.rcGray200)
        return view
    }()
    
    private let addUpToFiveImagesLabel: UILabel = {
        let label = UILabel()
        label.text = "사진을 최대 5장까지\n추가해보세요!"
        label.numberOfLines = 0
        label.textColor = .rcGray300
        label.font = .rcFont16M()
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        contentView.layer.borderColor = UIColor.rcGray200.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        
        setupContainerView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layouts
    
    private func setupContainerView() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        plusImageView.translatesAutoresizingMaskIntoConstraints = false
        addUpToFiveImagesLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(containerView)
        containerView.addSubview(plusImageView)
        containerView.addSubview(addUpToFiveImagesLabel)
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
        
        NSLayoutConstraint.activate([
            plusImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            plusImageView.topAnchor.constraint(equalTo: containerView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            addUpToFiveImagesLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            addUpToFiveImagesLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            addUpToFiveImagesLabel.topAnchor.constraint(equalTo: plusImageView.bottomAnchor, constant: 32),
            addUpToFiveImagesLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
}

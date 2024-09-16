//
//  EditPhotoCollectionViewCell.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 9/17/24.
//

import UIKit

protocol EdtiPhotoCollectionViewDeleteDelegate: AnyObject {
    func deletePhoto()
}

final class EditPhotoCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "EditPhotoCollectionViewCell"
    
    weak var delegate: EdtiPhotoCollectionViewDeleteDelegate?
    
    // MARK: - Views
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .rcGray300
        view.image = UIImage(named: "TicketImage")
        view.clipsToBounds = true
        return view
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.closeIconWithBg, for: .normal)
        button.addTarget(self, action: #selector(deleteButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .rcLightPurple
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        
        setupImageView()
        setupDeleteButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    private func setupImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    private func setupDeleteButton() {
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(deleteButton)
        
        NSLayoutConstraint.activate([
            deleteButton.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 11),
            deleteButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -11),
        ])
    }
    
    // MARK: - Actions
    
    @objc private func deleteButtonDidTap() {
        print("이미지 삭제 버튼 선택됨")
        delegate?.deletePhoto()
    }
    
    // MARK: - Functions
    
    func configure(with imageURL: String) {
        
    }
}

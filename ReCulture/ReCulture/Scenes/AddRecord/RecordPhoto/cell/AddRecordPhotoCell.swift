//
//  AddRecordPhotoCell.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 6/1/24.
//

import UIKit

final class AddRecordPhotoCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "AddRecordPhotoCell"
    var removeBtnCallBackMehtod: (() -> Void)?
    
    // MARK: - Views
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private let removeButton: UIButton = {
        let button = UIButton()
        button.setImage(.closeIconWithBg, for: .normal)
        button.addTarget(self, action: #selector(removeButtonTappped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 12
        
        setImageView()
        setRemoveButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    private func setImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    private func setRemoveButton() {
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(removeButton)
        
        NSLayoutConstraint.activate([
            removeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7.5),
            removeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -7.5),
            removeButton.widthAnchor.constraint(equalToConstant: 28),
            removeButton.heightAnchor.constraint(equalToConstant: 28),
        ])
    }
    
    // MARK: - Actions
    
    @objc private func removeButtonTappped() {
        print("remove this photo")
        removeBtnCallBackMehtod?()
    }
    
    // MARK: - Functions
    
    func configure(image: UIImage) {
        DispatchQueue.main.async { self.imageView.image = image }
    }
}

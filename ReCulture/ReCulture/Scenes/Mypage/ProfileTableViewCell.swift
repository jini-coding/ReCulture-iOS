//
//  ProfileTableViewCell.swift
//  ReCulture
//
//  Created by Jini on 5/17/24.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.rcFont20B()
        label.text = ""
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let commentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.rcFont14M()
        label.text = ""
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rcGrayBg
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let editInfoLabel: UILabel = {
        let label = UILabel()
        //label.text = "정보 수정"
        label.text = ""
        label.font = UIFont.rcFont14R()
        label.textColor = UIColor.rcGray400
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let editImageView: UIImageView = {
        let imageView = UIImageView()
        //imageView.image = UIImage(named: "btn_arrow_small")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(profileImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(commentLabel)
        containerView.addSubview(editInfoLabel)
        containerView.addSubview(editImageView)
        
        let inset: CGFloat = 16 //인셋 값
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset),
            
            profileImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 50),
            profileImageView.heightAnchor.constraint(equalToConstant: 50),
            
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 15),
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            
            commentLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 15),
            commentLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            commentLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24),
            
            editImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            editImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            editImageView.widthAnchor.constraint(equalToConstant: 22),
            editImageView.heightAnchor.constraint(equalToConstant: 22),
            
            editInfoLabel.trailingAnchor.constraint(equalTo: editImageView.leadingAnchor, constant: 0),
            editInfoLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
}

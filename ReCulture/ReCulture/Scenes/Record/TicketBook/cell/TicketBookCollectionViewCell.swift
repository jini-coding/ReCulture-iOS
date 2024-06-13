//
//  TicketBookCollectionViewCell.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 5/10/24.
//

import UIKit

class TicketBookCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "TicketBookCollectionViewCell"
    
    // MARK: - Views
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .lightGray
        view.contentMode = .scaleAspectFill
//        view.image = UIImage(named: "TicketImage.png")
        return view
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .lightGray
        layer.cornerRadius = 10
        clipsToBounds = true
        
        setImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    private func setImageView(){
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    // MARK: - Helpers
    
    func configure(_ model: MyTicketBookModel){
        let imageUrlStr = "http://34.27.50.30:8080\(model.imageURL)"
        imageUrlStr.loadAsyncImage(imageView)
    }
}

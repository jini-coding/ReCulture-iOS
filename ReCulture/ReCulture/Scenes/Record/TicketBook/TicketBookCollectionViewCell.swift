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
        view.backgroundColor = .darkGray
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .lightGray
        
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
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 17),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -17),
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 11),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -11)
        ])
    }
}

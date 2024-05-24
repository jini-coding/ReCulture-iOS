//
//  TagCollectionViewCell.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 5/24/24.
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "TagCollectionViewCell"
    
    override var isSelected: Bool {
        didSet {
            updateCellAppearance()
        }
    }
    
    // MARK: - Views
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .rcFont16M()
        label.text = "콘서트"
        label.textColor = .rcMain
        return label
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .rcGray000
        contentView.layer.cornerRadius = 15
        contentView.clipsToBounds = true
        
        setLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    private func setLabel(){
        label.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
        ])
    }
    
    // MARK: - Functions
    
    func updateCellAppearance() {
        contentView.backgroundColor = isSelected ? .rcMain : .rcGray000
        label.textColor = isSelected ? .white : .rcMain
    }
    
    func configure(tag: String){
        label.text = tag
        label.sizeToFit()
    }
    
    func getLabelFrame() -> CGRect{
        return label.frame
    }
}

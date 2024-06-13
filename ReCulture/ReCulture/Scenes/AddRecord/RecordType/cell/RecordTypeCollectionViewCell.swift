//
//  RecordTypeCollectionViewCell.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 5/24/24.
//

import UIKit

class RecordTypeCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "RecordTypeCollectionViewCell"
    
    override var isSelected: Bool {
        didSet{
            if isSelected {
                contentView.layer.borderColor = UIColor.rcMain.cgColor
                contentView.layer.borderWidth = 2
                contentView.backgroundColor = .rcLightPurple
                label.font = .rcFont18B()
                label.textColor = .rcMain
            }
            else {
                contentView.layer.borderColor = nil
                contentView.layer.borderWidth = 0
                contentView.backgroundColor = .rcGrayBg
                label.font = .rcFont18M()
                label.textColor = UIColor(hexCode: "A9ABB8")
            }
        }
    }
    
    // MARK: - Views
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .rcFont18M()
        label.textColor = UIColor(hexCode: "A9ABB8")
        return label
    }()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .rcGrayBg
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 12
        
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
            label.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 15),
            label.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -15),
            label.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
        ])
    }
    
    // MARK: - Functions
    
    func configure(_ type: String){
        label.text = type
        label.sizeToFit()
    }
    
    func getLabelFrame() -> CGRect {
        return label.frame
    }
}

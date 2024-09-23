//
//  ToolTipView.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 5/18/24.
//

import UIKit

final class ToolTipView: UIView {
    
    // MARK: - Views
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .rcFont14M()
        label.textColor = .white
        return label
    }()
    
    // MARK: - Initialization
    
    override init (frame: CGRect) {
        super.init(frame: .zero)
        
        self.backgroundColor = .rcMain
        
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 9
        
        setLabel()
        
    }
      
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Layout
    
    private func setLabel() {
        label.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
        ])
    }
    
    // MARK: - Functions
    
    func configure(text: String) {
        self.label.text = text
    }
}

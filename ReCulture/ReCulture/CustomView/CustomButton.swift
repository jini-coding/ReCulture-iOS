//
//  CustomButton.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 6/1/24.
//

import UIKit

class CustomButton: UIButton {
    init(title: String) {
        super.init(frame: .zero)
        
        var config = UIButton.Configuration.bordered()
        config.background.cornerRadius = 10
        config.contentInsets = .init(top: 15, leading: 0, bottom: 15, trailing: 0)
        config.baseBackgroundColor = .rcMain
        config.attributedTitle = AttributedString.init(title)
        config.attributedTitle?.font = UIFont.rcFont16B()
        config.baseForegroundColor = .white
        
        self.configuration = config
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

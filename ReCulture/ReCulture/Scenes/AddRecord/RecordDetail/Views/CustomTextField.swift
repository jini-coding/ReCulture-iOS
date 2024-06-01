//
//  CustomTextField.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 5/26/24.
//

import UIKit

class CustomTextField: UITextField {
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor.rcGrayBg
        font = UIFont.rcFont16M()
        textColor = UIColor.black
        layer.cornerRadius = 8
        
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
             .font: UIFont.rcFont16M()
         ]
        attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: placeholderAttributes)
        
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        leftViewMode = .always
        rightView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        rightViewMode = .always
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

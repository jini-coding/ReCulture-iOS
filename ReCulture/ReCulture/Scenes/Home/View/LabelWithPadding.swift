//
//  LabelWithPadding.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 5/17/24.
//

import UIKit

class LabelWithPadding: UILabel {
    
    private var padding: UIEdgeInsets = UIEdgeInsets(top: .zero, left: .zero, bottom: .zero, right: .zero)

    convenience init(top: CGFloat = .zero, left: CGFloat = .zero, bottom: CGFloat = .zero, right: CGFloat = .zero) {
        self.init()
        self.padding.top = top
        self.padding.left = left
        self.padding.bottom = bottom
        self.padding.right = right
    }
        
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.width += self.padding.left + self.padding.right
        contentSize.height += self.padding.top + self.padding.bottom
        return contentSize
    }
}

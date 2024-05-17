//
//  LabelWithPadding.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 5/17/24.
//

import UIKit

class LabelWithPadding: UILabel {
    
    private var padding: UIEdgeInsets?
    
    convenience init(padding: UIEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)) {
            self.init()
            self.padding = padding
    }
        
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding!))
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.width += self.padding!.left + self.padding!.right
        contentSize.height += self.padding!.top + self.padding!.bottom
        return contentSize
    }
}

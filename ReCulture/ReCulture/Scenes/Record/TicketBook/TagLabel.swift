//
//  TagLabel.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 5/20/24.
//

import UIKit

class TagLabel: UILabel {
    
    private var padding = UIEdgeInsets(top: 6, left: 8, bottom: 6, right: 8)

    convenience init(padding: UIEdgeInsets) {
        self.init()
        self.padding = padding
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right

        return contentSize
    }
}

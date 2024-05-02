//
//  Font.swift
//  ReCulture
//
//  Created by Jini on 5/3/24.
//

import UIKit

extension UIFont {
    
    static func applyLetterSpacing(to font: UIFont, withSpacing spacing: CGFloat) -> UIFont {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .kern: spacing
        ]
        let attributedString = NSAttributedString(string: " ", attributes: attributes)
        guard let modifiedFont = attributedString.attribute(.font, at: 0, effectiveRange: nil) as? UIFont else {
            return font
        }
        return modifiedFont
    }
    
    static func rcFont26B() -> UIFont {
        let font = UIFont(name: "AppleSDGothicNeo-Bold", size: 26) ?? UIFont.systemFont(ofSize: 26, weight: .bold)
        return applyLetterSpacing(to: font, withSpacing: -2)
    }
    
    static func rcFont21SB() -> UIFont {
        let font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 21) ?? UIFont.systemFont(ofSize: 21, weight: .light)
        return applyLetterSpacing(to: font, withSpacing: -2)
    }
    
    static func rcFont20B() -> UIFont {
        let font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .bold)
        return applyLetterSpacing(to: font, withSpacing: -2)
    }
    
    static func rcFont20M() -> UIFont {
        let font = UIFont(name: "AppleSDGothicNeo-Medium", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .medium)
        return applyLetterSpacing(to: font, withSpacing: -2)
    }
    
    static func rcFont20R() -> UIFont {
        let font = UIFont(name: "AppleSDGothicNeo-Regular", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .regular)
        return applyLetterSpacing(to: font, withSpacing: -2)
    }
    
    static func rcFont18B() -> UIFont {
        let font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .bold)
        return applyLetterSpacing(to: font, withSpacing: -2)
    }
    
    static func rcFont18M() -> UIFont {
        let font = UIFont(name: "AppleSDGothicNeo-Medium", size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .medium)
        return applyLetterSpacing(to: font, withSpacing: -2)
    }
    
    static func rcFont18R() -> UIFont {
        let font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .regular)
        return applyLetterSpacing(to: font, withSpacing: -2)
    }
    
    static func rcFont16B() -> UIFont {
        let font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .bold)
        return applyLetterSpacing(to: font, withSpacing: -2)
    }
    
    static func rcFont16M() -> UIFont {
        let font = UIFont(name: "AppleSDGothicNeo-Medium", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .medium)
        return applyLetterSpacing(to: font, withSpacing: -2)
    }
    
    static func rcFont16R() -> UIFont {
        let font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .regular)
        return applyLetterSpacing(to: font, withSpacing: -2)
    }
    
    static func rcFont14B() -> UIFont {
        let font = UIFont(name: "AppleSDGothicNeo-Bold", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .bold)
        return applyLetterSpacing(to: font, withSpacing: -2)
    }
    
    static func rcFont14M() -> UIFont {
        let font = UIFont(name: "AppleSDGothicNeo-Medium", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .medium)
        return applyLetterSpacing(to: font, withSpacing: -2)
    }
    
    static func rcFont14R() -> UIFont {
        let font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .regular)
        return applyLetterSpacing(to: font, withSpacing: -2)
    }
        
    static func rcFont12M() -> UIFont {
        let font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .medium)
        return applyLetterSpacing(to: font, withSpacing: -2)
    }
        
    static func rcFont12R() -> UIFont {
        let font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .regular)
        return applyLetterSpacing(to: font, withSpacing: -2)
    }
        
    static func rcFont10B() -> UIFont {
        let font = UIFont(name: "AppleSDGothicNeo-Bold", size: 10) ?? UIFont.systemFont(ofSize: 10, weight: .bold)
        return applyLetterSpacing(to: font, withSpacing: -2)
    }
        
    static func rcFont10M() -> UIFont {
        let font = UIFont(name: "AppleSDGothicNeo-Medium", size: 10) ?? UIFont.systemFont(ofSize: 10, weight: .medium)
        return applyLetterSpacing(to: font, withSpacing: -2)
    }
        
    static func rcFont10R() -> UIFont {
        let font = UIFont(name: "AppleSDGothicNeo-Regular", size: 10) ?? UIFont.systemFont(ofSize: 10, weight: .regular)
        return applyLetterSpacing(to: font, withSpacing: -2)
    }
}

//
//  NextButton.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 5/24/24.
//

import UIKit

class NextButton: UIButton {
    
    // MARK: - Properties
    
    var isActive: Bool = false {
        didSet {
            setNeedsUpdateConfiguration()
        }
    }
    
    // MARK: - Initialization
    
    init() {
        super.init(frame: .zero)
        
        var config = UIButton.Configuration.filled()
        config.contentInsets = .init(top: 15, leading: 0, bottom: 15, trailing: 0)
        config.attributedTitle = AttributedString("다음")
        config.attributedTitle?.setAttributes(AttributeContainer([NSAttributedString.Key.font: UIFont.rcFont18M()]))
        self.configuration = config
        
        let buttonStateHandler: UIButton.ConfigurationUpdateHandler = { button in
            switch self.isActive {
            case true:
                button.configuration?.background.backgroundColor = .rcMain
                //button.configuration?.baseForegroundColor = .white
                button.configuration?.attributedTitle?.setAttributes(AttributeContainer([NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.rcFont18M()]))
            case false:
                button.configuration?.background.backgroundColor = UIColor(hexCode: "F6F2FF")
                //button.configuration?.baseForegroundColor = UIColor(hexCode: "D2C2FF")
                button.configuration?.attributedTitle?.setAttributes(AttributeContainer([NSAttributedString.Key.foregroundColor: UIColor(hexCode: "D2C2FF"), NSAttributedString.Key.font: UIFont.rcFont18M()]))
            }
        }
        
        self.configurationUpdateHandler = buttonStateHandler
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func setupButton() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        self.isEnabled = false  // 초기 상태
//        updateButtonState()
    }
    
//    private func updateButtonState() {
//        self.isEnabled = isActive
//        self.configuration?.baseBackgroundColor = isActive ? .white : UIColor(hexCode: "D2C2ff")
//        self.configuration?.baseForegroundColor = isActive ? .rcMain : UIColor(hexCode: "F6F2FF")
////        self.setTitleColor( isActive ? .white : UIColor(hexCode: "D2C2FF"), for: .normal)
////        self.backgroundColor = isActive ? .rcMain : UIColor(hexCode: "F6F2FF")
//    }
}

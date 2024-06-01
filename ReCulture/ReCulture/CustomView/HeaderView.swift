//
//  HeaderView.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 5/29/24.
//

import UIKit

class HeaderView: UIView {
    
    // MARK: - Views
    
    private let backButton: UIButton = {
        let button = UIButton()
        let backImage = UIImage.btnArrowBig.withRenderingMode(.alwaysOriginal).resizeImage(size: CGSize(width: 36, height: 36))
        button.setImage(backImage, for: .normal)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "기록 추가"
        label.font = .rcFont16M()
        label.textColor = .black
        return label
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setBackButton()
        setTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    private func setBackButton() {
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(backButton)
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backButton.topAnchor.constraint(equalTo: self.topAnchor),
            backButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    private func setTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
    }
    
    // MARK: - Functions
    
    // header view 사용하는 뷰컨트롤러에서 action 정의
    func addBackButtonTarget(target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        backButton.addTarget(target, action: action, for: controlEvents)
    }
}

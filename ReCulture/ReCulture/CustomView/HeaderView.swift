//
//  HeaderView.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 5/29/24.
//

import UIKit

class HeaderView: UIView {
    
    // MARK: - Properties
    
    private var withCloseButton: Bool = false
    
    // MARK: - Views
    
    private let backButton: UIButton = {
        let button = UIButton()
        let backImage = UIImage.btnArrowBig.withRenderingMode(.alwaysOriginal).resizeImage(size: CGSize(width: 36, height: 36))
        button.setImage(backImage, for: .normal)
        return button
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        let closeImage = UIImage.closeIcon.withRenderingMode(.alwaysOriginal).resizeImage(size: CGSize(width: 36, height: 36))
        button.setImage(closeImage, for: .normal)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        //label.text = "기록 추가"
        label.font = .rcFont16M()
        label.textColor = .black
        return label
    }()
    
    // MARK: - Initialization
    
    init(title: String = "기록 추가", withCloseButton: Bool = false) {
        super.init(frame: .zero)
        
        titleLabel.text = title
        self.withCloseButton = withCloseButton
        
        setBackButton()
        setTitleLabel()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    private func setBackButton() {
        print(withCloseButton)
        if withCloseButton {
            closeButton.translatesAutoresizingMaskIntoConstraints = false
            
            addSubview(closeButton)
            
            NSLayoutConstraint.activate([
                closeButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                closeButton.topAnchor.constraint(equalTo: self.topAnchor),
                closeButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            ])
        }
        
        else {
            backButton.translatesAutoresizingMaskIntoConstraints = false
            
            addSubview(backButton)
            
            NSLayoutConstraint.activate([
                backButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                backButton.topAnchor.constraint(equalTo: self.topAnchor),
                backButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            ])
        }
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
        if withCloseButton {
            closeButton.addTarget(target, action: action, for: controlEvents)
        }
        else {
            backButton.addTarget(target, action: action, for: controlEvents)
            
        }
    }
}

//
//  LogoutModal.swift
//  ReCulture
//
//  Created by Jini on 5/24/24.
//


import UIKit

class LogoutModal : UIViewController {
    
    weak var delegate: LogoutModalDelegate?
    
    let customModal = UIView(frame: CGRect(x: 0, y: 0, width: 322, height: 200))
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 0
        label.font = UIFont.rcFont20B()
        
        return label
    }()
    
    let contentLabel : UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 0
        label.font = UIFont.rcFont16M()
        
        return label
    }()
    
    let confirmButton : UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.rcMain
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        
        return button
    }()
    
    let cancelButton : UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.rcMain, for: .normal)
        button.backgroundColor = UIColor.rcGrayBg
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        
        return button
    }()
    
    // 모달 제목 바꾸는 함수
    func changeTitle(title : String){
        titleLabel.text = title
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presentCustomModal()
        setupBackground()
        setupLogoutView()
    }
    
    func presentCustomModal() {
        customModal.backgroundColor = UIColor.white
        view.addSubview(customModal)
        customModal.center = view.center
    }
    
    private func setupBackground() {
        customModal.layer.cornerRadius = 25
        customModal.layer.masksToBounds = true
    }
    
    
    
    private func setupLogoutView() {
        customModal.addSubview(titleLabel)
        customModal.addSubview(contentLabel)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        
        let titleAttributedText = NSAttributedString(string: "로그아웃", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        titleLabel.attributedText = titleAttributedText
        titleLabel.textAlignment = .center
       
        let contentAttributedText = NSAttributedString(string: "로그아웃하시겠습니까?", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        contentLabel.attributedText = contentAttributedText
        contentLabel.textAlignment = .center
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: customModal.topAnchor, constant: 35),
            titleLabel.centerXAnchor.constraint(equalTo: customModal.centerXAnchor),
            
            contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            contentLabel.centerXAnchor.constraint(equalTo: customModal.centerXAnchor)
            
        ])
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        
        customModal.addSubview(cancelButton)
        customModal.addSubview(confirmButton)
        
        confirmButton.setTitle("로그아웃", for: .normal)
        cancelButton.setTitle("취소", for: .normal)
        
        confirmButton.addTarget(self, action: #selector(performWithdrawal), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(popupDismiss), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            cancelButton.bottomAnchor.constraint(equalTo: customModal.bottomAnchor, constant: -15),
            cancelButton.leadingAnchor.constraint(equalTo: customModal.leadingAnchor, constant: 15),
            cancelButton.widthAnchor.constraint(equalToConstant: 140),
            cancelButton.heightAnchor.constraint(equalToConstant: 52),
            
            confirmButton.bottomAnchor.constraint(equalTo: customModal.bottomAnchor, constant: -15),
            confirmButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 15),
            confirmButton.trailingAnchor.constraint(equalTo: customModal.trailingAnchor, constant: -15),
            confirmButton.widthAnchor.constraint(equalToConstant: 140),
            confirmButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    @objc func popupDismiss(){

        delegate?.dismissLogoutModal()
    }
    
    @objc func performWithdrawal() {
        
        print("로그아웃")
    }
}


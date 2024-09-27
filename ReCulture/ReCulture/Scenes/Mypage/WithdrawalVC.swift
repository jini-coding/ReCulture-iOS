//
//  WithdrawalVC.swift
//  ReCulture
//
//  Created by Jini on 5/17/24.
//

import UIKit

class WithdrawalVC: UIViewController {
    
    let viewModel = MypageViewModel()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        
        let attributedText = NSAttributedString(string: "탈퇴하시기 전에\n확인해주세요", attributes: [
            .paragraphStyle: paragraphStyle,
            .foregroundColor: UIColor.black,
            .font: UIFont.rcFont24B()
        ])
        label.attributedText = attributedText
        
        return label
    }()

    let descLabel: UILabel = {
        let label = UILabel()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        
        let attributedText = NSAttributedString(string: "탈퇴 사유를 공유해주시면 반영하여\n더 좋은 서비스를 제공하기 위해 노력할게요", 
            attributes: [
                .paragraphStyle: paragraphStyle,
                .foregroundColor: UIColor.rcGray300,
                .font: UIFont.rcFont14M()
        ])
        label.attributedText = attributedText
        
        return label
    }()
    
    
    
    // 나중에 여기에 유의사항 + 체크박스 추가 예정
    
    

    let reasonLabel: UILabel = {
        let label = UILabel()
        label.text = "탈퇴 사유"
        label.textColor = UIColor.rcGray400
        label.font = UIFont.rcFont14M()
        
        return label
    }()
    
    let reasonTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "탈퇴 사유를 작성해주세요"
        textfield.backgroundColor = UIColor.rcGrayBg
        textfield.font = UIFont.rcFont16M()
        textfield.textColor = UIColor.black
        textfield.layer.cornerRadius = 8
        
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
             .font: UIFont.rcFont16M()
         ]
        textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: placeholderAttributes)
        
        return textfield
    }()
    
    let confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("탈퇴하기", for: .normal)
        button.backgroundColor = UIColor(hexCode: "#F6F2FF")
        button.setTitleColor(UIColor(hexCode: "#D2C2FF"), for: .normal)
        button.titleLabel?.font = UIFont.rcFont18M()
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.isEnabled = false
        button.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        setupNavigationBar()
        setupGuide()
        setupReasonSelect()
        setupConfirmButton()
        
        hideKeyboard()
        
        reasonTextfield.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = "계정 탈퇴"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.rcFont18B()]
        self.navigationController?.navigationBar.setBackgroundImage(nil, for:.default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.layoutIfNeeded()
        
    }
    
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
        
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setupGuide() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        view.addSubview(descLabel)
        
        titleLabel.numberOfLines = 0
        descLabel.numberOfLines = 0
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.heightAnchor.constraint(equalToConstant: 72),
            
            descLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            descLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            descLabel.heightAnchor.constraint(equalToConstant: 48),
        ])
    }
    
    func setupReasonSelect() {
        reasonLabel.translatesAutoresizingMaskIntoConstraints = false
        reasonTextfield.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(reasonLabel)
        view.addSubview(reasonTextfield)
        
        // Left padding view
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: reasonTextfield.frame.height))
        reasonTextfield.leftView = leftPaddingView
        reasonTextfield.leftViewMode = .always
        
        NSLayoutConstraint.activate([
            reasonLabel.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 16),
            reasonLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            reasonLabel.heightAnchor.constraint(equalToConstant: 20),
            
            reasonTextfield.topAnchor.constraint(equalTo: reasonLabel.bottomAnchor, constant: 5),
            reasonTextfield.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            reasonTextfield.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            reasonTextfield.heightAnchor.constraint(equalToConstant: 52),
        ])
    }
    
    func setupConfirmButton() {
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(confirmButton)
        
        NSLayoutConstraint.activate([
            confirmButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            confirmButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            confirmButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            confirmButton.heightAnchor.constraint(equalToConstant: 52),
        ])
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let text = textField.text ?? ""
        if text.isEmpty {
            confirmButton.isEnabled = false
            confirmButton.backgroundColor = UIColor(hexCode: "#F6F2FF")
            confirmButton.setTitleColor(UIColor(hexCode: "#D2C2FF"), for: .normal)
        } else {
            confirmButton.isEnabled = true
            confirmButton.backgroundColor = UIColor.rcMain
            confirmButton.setTitleColor(UIColor.white, for: .normal)
        }
    }
    
    @objc func confirmButtonTapped() {
        withdraw()
    }
    
    @objc func withdraw() {
        let alertController = UIAlertController(
            title: "탈퇴하시겠습니까?", message: nil,preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "탈퇴하기", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            performWithdrawal()
            print("탈퇴 완료됨")
            
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)

        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true)
    }
    
    func performWithdrawal() {
        viewModel.withdrawal(fromCurrentVC: self)
        let refreshTokenDeleted = KeychainManager.shared.deleteToken(type: .refreshToken)
        UserDefaults.standard.set(false, forKey: "isFirstLaunch")
    }
}



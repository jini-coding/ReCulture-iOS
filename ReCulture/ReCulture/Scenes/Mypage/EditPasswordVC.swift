//
//  EditPasswordVC.swift
//  ReCulture
//
//  Created by Jini on 5/17/24.
//

import UIKit

class EditPasswordVC: UIViewController {

    private let viewModel = MypageViewModel()
    
    private var isValidNewPw = false {
        willSet {
            newValue ? removePwIsNotValidLabel() : addPwIsNotValidLabel()
        }
    }
    
    private var isPwSame = false {
        willSet {
            newValue ? removePwDoesNotMatchLabel() : addPwDoesNotMatchLabel()
        }
    }
    
    
    let currentPwLabel: UILabel = {
        let label = UILabel()
        label.text = "현재 비밀번호"
        label.textColor = UIColor.rcGray400
        label.font = UIFont.rcFont14M()
        
        return label
    }()
    
    let currentPwTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "현재 비밀번호를 입력해주세요"
        textfield.isSecureTextEntry = true
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
    
    let newPwLabel: UILabel = {
        let label = UILabel()
        label.text = "새 비밀번호"
        label.textColor = UIColor.rcGray400
        label.font = UIFont.rcFont14M()
        
        return label
    }()
    
    let newPwTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "새 비밀번호를 입력해주세요"
        textfield.isSecureTextEntry = true
        textfield.backgroundColor = UIColor.rcGrayBg
        textfield.font = UIFont.rcFont16M()
        textfield.textColor = UIColor.black
        textfield.layer.cornerRadius = 8
        
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
             .font: UIFont.rcFont16M()
         ]
        textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: placeholderAttributes)
        textfield.addTarget(self, action: #selector(tfDidChange), for: .editingChanged)
        
        return textfield
    }()
    
    let pwIsNotValidLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호는 대소문자, 특수문자, 숫자 8자 이상의 조합이어야 합니다."
        label.font = .rcFont12M()
        label.textColor = .red.withAlphaComponent(0.5)
        return label
    }()
    
    let renewPwLabel: UILabel = {
        let label = UILabel()
        label.text = "새 비밀번호 확인"
        label.textColor = UIColor.rcGray400
        label.font = UIFont.rcFont14M()
        
        return label
    }()
    
    let renewPwTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "새 비밀번호를 다시 입력해주세요"
        textfield.isSecureTextEntry = true
        textfield.backgroundColor = UIColor.rcGrayBg
        textfield.font = UIFont.rcFont16M()
        textfield.textColor = UIColor.black
        textfield.layer.cornerRadius = 8
        
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
             .font: UIFont.rcFont16M()
         ]
        textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: placeholderAttributes)
        textfield.addTarget(self, action: #selector(tfDidChange), for: .editingChanged)
        
        return textfield
    }()
    
    let pwDoesNotMatchLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호가 일치하지 않습니다."
        label.font = .rcFont12M()
        label.textColor = .red.withAlphaComponent(0.5)
        return label
    }()
    
    let confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("변경하기", for: .normal)
        button.backgroundColor = UIColor.rcMain
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.rcFont18M()
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        setupNavigationBar()
        setupCurrentPw()
        setupNewPw()
        setupRenewPw()
        setupConfirmButton()
        
        hideKeyboard()
        
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        
    }
    
    @objc func tfDidChange(_ sender: UITextField) {
        isValidNewPw = newPwTextfield.text?.isValidPassword() ?? false
        isPwSame = newPwTextfield.text == renewPwTextfield.text
    }
    
    @objc func confirmButtonTapped() {
        guard let currentPassword = currentPwTextfield.text,
              let newPassword = newPwTextfield.text,
              let renewPassword = renewPwTextfield.text else {
            showAlert(message: "모든 필드를 입력해주세요.")
            return
        }

        if !isPwSame {
            showAlert(message: "새 비밀번호와 확인 비밀번호가 일치하지 않습니다.")
            return
        }

        if !isValidNewPw {
            showAlert(message: "새 비밀번호는 대소문자, 특수문자, 숫자 8자 이상의 조합이어야 합니다.")
            return
        }
        print("Request Data:", currentPassword, newPassword)

        viewModel.changePassword(curPassword: currentPassword, newPassword: newPassword, fromCurrentVC: self)
    }
    
    func addPwIsNotValidLabel() {
        view.addSubview(pwIsNotValidLabel)
        pwIsNotValidLabel.isHidden = false
    }

    func removePwIsNotValidLabel() {
        pwIsNotValidLabel.isHidden = true
    }

    func addPwDoesNotMatchLabel() {
        view.addSubview(pwDoesNotMatchLabel)
        pwDoesNotMatchLabel.isHidden = false
    }

    func removePwDoesNotMatchLabel() {
        pwDoesNotMatchLabel.isHidden = true
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(confirmAction)
        self.present(alert, animated: true)
    }
    
    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    

    func setupNavigationBar() {
        self.navigationItem.title = "비밀번호 변경"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.rcFont18B()]
        self.navigationController?.navigationBar.setBackgroundImage(nil, for:.default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.layoutIfNeeded()
        
    }
    
    func setupCurrentPw() {
        currentPwLabel.translatesAutoresizingMaskIntoConstraints = false
        currentPwTextfield.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(currentPwLabel)
        view.addSubview(currentPwTextfield)
        
        // Left padding view
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: currentPwTextfield.frame.height))
        currentPwTextfield.leftView = leftPaddingView
        currentPwTextfield.leftViewMode = .always
        
        NSLayoutConstraint.activate([
            currentPwLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
            currentPwLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            currentPwLabel.heightAnchor.constraint(equalToConstant: 20),
            
            currentPwTextfield.topAnchor.constraint(equalTo: currentPwLabel.bottomAnchor, constant: 5),
            currentPwTextfield.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            currentPwTextfield.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            currentPwTextfield.heightAnchor.constraint(equalToConstant: 52),
        ])
    }
    
    func setupNewPw() {
        newPwLabel.translatesAutoresizingMaskIntoConstraints = false
        newPwTextfield.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(newPwLabel)
        view.addSubview(newPwTextfield)
        
        // Left padding view
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: newPwTextfield.frame.height))
        newPwTextfield.leftView = leftPaddingView
        newPwTextfield.leftViewMode = .always
        
        NSLayoutConstraint.activate([
            newPwLabel.topAnchor.constraint(equalTo: currentPwTextfield.bottomAnchor, constant: 30),
            newPwLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            newPwLabel.heightAnchor.constraint(equalToConstant: 20),
            
            newPwTextfield.topAnchor.constraint(equalTo: newPwLabel.bottomAnchor, constant: 5),
            newPwTextfield.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            newPwTextfield.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            newPwTextfield.heightAnchor.constraint(equalToConstant: 52),
        ])
    }
    
    func setupRenewPw() {
        renewPwLabel.translatesAutoresizingMaskIntoConstraints = false
        renewPwTextfield.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(renewPwLabel)
        view.addSubview(renewPwTextfield)
        
        // Left padding view
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: renewPwTextfield.frame.height))
        renewPwTextfield.leftView = leftPaddingView
        renewPwTextfield.leftViewMode = .always
        
        NSLayoutConstraint.activate([
            renewPwLabel.topAnchor.constraint(equalTo: newPwTextfield.bottomAnchor, constant: 24),
            renewPwLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            renewPwLabel.heightAnchor.constraint(equalToConstant: 20),
            
            renewPwTextfield.topAnchor.constraint(equalTo: renewPwLabel.bottomAnchor, constant: 5),
            renewPwTextfield.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            renewPwTextfield.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            renewPwTextfield.heightAnchor.constraint(equalToConstant: 52),
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
    
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
        
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


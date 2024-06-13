//
//  EditPasswordVC.swift
//  ReCulture
//
//  Created by Jini on 5/17/24.
//

import UIKit

class EditPasswordVC: UIViewController {

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
        button.setTitle("저장", for: .normal)
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
}


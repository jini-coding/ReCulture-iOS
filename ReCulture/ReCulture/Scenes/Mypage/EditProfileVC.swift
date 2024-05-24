//
//  EditProfileVC.swift
//  ReCulture
//
//  Created by Jini on 5/17/24.
//

import UIKit

class EditProfileVC: UIViewController {
    
    let profileImage: UIImageView = {
        let imageview = UIImageView()
        imageview.backgroundColor = UIColor.rcGray200
        imageview.layer.cornerRadius = 45
        imageview.clipsToBounds = true
        
        return imageview
    }()
    
    let nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.textColor = UIColor.rcGray400
        label.font = UIFont.rcFont14M()
        
        return label
    }()
    
    let nicknameTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "닉네임을 입력해주세요"
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
    
    let introLabel: UILabel = {
        let label = UILabel()
        label.text = "소개"
        label.textColor = UIColor.rcGray400
        label.font = UIFont.rcFont14M()
        
        return label
    }()
    
    let introTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "소개글을 입력해주세요"
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
    
    let birthLabel: UILabel = {
        let label = UILabel()
        label.text = "생년월일"
        label.textColor = UIColor.rcGray400
        label.font = UIFont.rcFont14M()
        
        return label
    }()
    
    let birthTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "생년월일을 입력해주세요"
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
    
    let interestLabel: UILabel = {
        let label = UILabel()
        label.text = "관심분야"
        label.textColor = UIColor.rcGray400
        label.font = UIFont.rcFont14M()
        
        return label
    }()
    
    let interestTextfield: UITextField = {
        let textfield = UITextField()
        textfield.text = "관심분야를 설정해주세요"
        textfield.backgroundColor = UIColor.rcGrayBg
        textfield.font = UIFont.rcFont16M()
        textfield.textColor = UIColor.black
        textfield.layer.cornerRadius = 8
        
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
        setupProfileImage()
        setupInputNickname()
        setupInputIntro()
        setupInputBirth()
        setupSelectField()
        setupConfirmButton()
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = "프로필 변경"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.rcFont18B()]
        self.navigationController?.navigationBar.setBackgroundImage(nil, for:.default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.layoutIfNeeded()
        
    }
    
    func setupProfileImage() {
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(profileImage)
        
        NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 32),
            profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImage.heightAnchor.constraint(equalToConstant: 90),
            profileImage.widthAnchor.constraint(equalToConstant: 90)
        ])
        
    }
    
    func setupInputNickname() {
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        nicknameTextfield.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(nicknameLabel)
        view.addSubview(nicknameTextfield)
        
        // Left padding view
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: nicknameTextfield.frame.height))
        nicknameTextfield.leftView = leftPaddingView
        nicknameTextfield.leftViewMode = .always
        
        NSLayoutConstraint.activate([
            nicknameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 24),
            nicknameLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nicknameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            nicknameTextfield.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 5),
            nicknameTextfield.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nicknameTextfield.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            nicknameTextfield.heightAnchor.constraint(equalToConstant: 52),
        ])
    }
    
    func setupInputIntro() {
        introLabel.translatesAutoresizingMaskIntoConstraints = false
        introTextfield.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(introLabel)
        view.addSubview(introTextfield)
        
        // Left padding view
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: introTextfield.frame.height))
        introTextfield.leftView = leftPaddingView
        introTextfield.leftViewMode = .always
        
        NSLayoutConstraint.activate([
            introLabel.topAnchor.constraint(equalTo: nicknameTextfield.bottomAnchor, constant: 28),
            introLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            introLabel.heightAnchor.constraint(equalToConstant: 20),
            
            introTextfield.topAnchor.constraint(equalTo: introLabel.bottomAnchor, constant: 5),
            introTextfield.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            introTextfield.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            introTextfield.heightAnchor.constraint(equalToConstant: 52),
        ])
    }
    
    func setupInputBirth() {
        birthLabel.translatesAutoresizingMaskIntoConstraints = false
        birthTextField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(birthLabel)
        view.addSubview(birthTextField)
        
        // Left padding view
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: birthTextField.frame.height))
        birthTextField.leftView = leftPaddingView
        birthTextField.leftViewMode = .always
        
        NSLayoutConstraint.activate([
            birthLabel.topAnchor.constraint(equalTo: introTextfield.bottomAnchor, constant: 28),
            birthLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            birthLabel.heightAnchor.constraint(equalToConstant: 20),
            
            birthTextField.topAnchor.constraint(equalTo: birthLabel.bottomAnchor, constant: 5),
            birthTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            birthTextField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            birthTextField.heightAnchor.constraint(equalToConstant: 52),
        ])
    }
    
    func setupSelectField() {
        interestLabel.translatesAutoresizingMaskIntoConstraints = false
        interestTextfield.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(interestLabel)
        view.addSubview(interestTextfield)
        
        // Left padding view
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: interestTextfield.frame.height))
        interestTextfield.leftView = leftPaddingView
        interestTextfield.leftViewMode = .always
        
        NSLayoutConstraint.activate([
            interestLabel.topAnchor.constraint(equalTo: birthTextField.bottomAnchor, constant: 28),
            interestLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            interestLabel.heightAnchor.constraint(equalToConstant: 20),
            
            interestTextfield.topAnchor.constraint(equalTo: interestLabel.bottomAnchor, constant: 5),
            interestTextfield.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            interestTextfield.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            interestTextfield.heightAnchor.constraint(equalToConstant: 52),
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



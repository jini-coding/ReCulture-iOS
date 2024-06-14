//
//  EditProfileVC.swift
//  ReCulture
//
//  Created by Jini on 5/17/24.
//

import UIKit

class EditProfileVC: UIViewController {
    
    let viewModel = MypageViewModel()
    
    let profileImage: UIImageView = {
        let imageview = UIImageView()
        imageview.backgroundColor = UIColor.rcGray200
        imageview.layer.cornerRadius = 45
        imageview.clipsToBounds = true
        
        return imageview
    }()

    let roundImage: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rcGray300
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        
        return view
    }()
    
    let plusImage: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "AddIcon")
        
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
        textfield.placeholder = "관심분야를 설정해주세요"
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
        
        button.addTarget(self, action: #selector(didTapConfirmButton), for: .touchUpInside)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        bind()
        viewModel.getMyInfo(fromCurrentVC: self)
        
        setupNavigationBar()
        setupProfileImage()
        setupInputNickname()
        setupInputIntro()
        //setupInputBirth()
        setupSelectField()
        setupConfirmButton()
    }
    
    private func bind() {
        viewModel.myPageModelDidChange = { [weak self] in
            DispatchQueue.main.async { [self] in
                self?.nicknameTextfield.text = self?.viewModel.getNickname()
                self?.introTextfield.text = self?.viewModel.getBio()
                self?.interestTextfield.text = self?.viewModel.getInterest()
            }
        }
        
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
        roundImage.translatesAutoresizingMaskIntoConstraints = false
        plusImage.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(profileImage)
        view.addSubview(roundImage)
        roundImage.addSubview(plusImage)
        
        NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 32),
            profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImage.heightAnchor.constraint(equalToConstant: 90),
            profileImage.widthAnchor.constraint(equalToConstant: 90),
            
            roundImage.bottomAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: -2),
            roundImage.trailingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: -10),
            roundImage.heightAnchor.constraint(equalToConstant: 20),
            roundImage.widthAnchor.constraint(equalToConstant: 20),
            
            plusImage.centerXAnchor.constraint(equalTo: roundImage.centerXAnchor),
            plusImage.centerYAnchor.constraint(equalTo: roundImage.centerYAnchor),
            plusImage.heightAnchor.constraint(equalToConstant: 18),
            plusImage.widthAnchor.constraint(equalToConstant: 18),
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
            interestLabel.topAnchor.constraint(equalTo: introTextfield.bottomAnchor, constant: 28),
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
    
    @objc func didTapConfirmButton() {
//        guard let nickname = nicknameTextfield.text,
//              let bio = introTextfield.text,
//              let birthdate = birthTextField.text,
//              let interest = interestTextfield.text else {
//            return
//        }
//        
//        let requestDTO: [String: Any] = [
//            "nickname": nickname,
//            "bio": bio,
//            "birthdate": birthdate,
//            "interest": interest,
//            "photo":
//        ]
//        
//        // profileImage는 예시로 비어 있는 [ImageFile]을 보냅니다.
//        // 실제로는 사용자가 선택한 이미지를 이 배열에 담아야 합니다.
//        let profileImages: [ImageFile] = []
//        
//        viewModel.editMyProfile(
//            requestDTO: NewUserProfileRequestDTO(nickname: nickname, bio: bio, birthdate: birth, interest: interest),
//            profileImage: [image],
//            fromCurrentVC: self
//        )
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default)
        alertController.addAction(confirmAction)
        present(alertController, animated: true)
    }
}



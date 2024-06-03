//
//  NewUserProfileVC.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 6/3/24.
//

import UIKit
import PhotosUI

class NewUserProfileVC: UIViewController {
    
    // MARK: - Properties
    
    private let profileImageViewWidth: CGFloat = 125
    
    private let addProfileImageButtonWidth: CGFloat = 30
    
    private lazy var phPicker: PHPickerViewController = {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images
        
        let phPicker = PHPickerViewController(configuration: config)
        phPicker.delegate = self
        return phPicker
    }()
    
    private var selectedImage = UIImage()
    
    // MARK: - Views
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "프로필 설정"
        label.font = .rcFont16M()
        return label
    }()
    
    private let profileImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .rcLightPurple
        view.clipsToBounds = true
        return view
    }()
    
    private let addProfileImageButton: UIButton = {
        let button = UIButton()
        button.setImage(.addIcon.withTintColor(.white), for: .normal)
        button.backgroundColor = .rcMain
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(addProfileImageButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private let nicknameStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 8
        return view
    }()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.font = .rcFont14M()
        return label
    }()
    
    private let nicknameTextField: CustomTextField = {
        let tf = CustomTextField()
        tf.placeholder = "닉네임을 입력해주세요"
        tf.addTarget(self, action: #selector(tfDidChange), for: .editingChanged)
        return tf
    }()
    
    private let bioStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 8
        return view
    }()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.text = "한 줄 소개"
        label.font = .rcFont14M()
        return label
    }()
    
    private lazy var bioTextField: CustomTextField = {
        let tf = CustomTextField()
        tf.placeholder = "한 줄 소개를 입력해주세요(최대 50자)"
        tf.addTarget(self, action: #selector(tfDidChange), for: .editingChanged)
        tf.delegate = self
        return tf
    }()
    
    private let signupButton: NextButton = {
        let button = NextButton("회원가입")
        button.addTarget(self, action: #selector(signUpButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupNavigation()
        setupProfileImageView()
        setupAddProfileImageButton()
        setupNicknameStackView()
        setupBioStackView()
        setupSignupButton()
    }
    
    // MARK: - Layout
    
    private func setupNavigation(){
        self.navigationItem.titleView = titleLabel
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    private func setupProfileImageView(){
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(profileImageView)
        
        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: profileImageViewWidth),
            profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor),
            profileImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 35)
        ])
        
        profileImageView.layer.cornerRadius = profileImageViewWidth / 2
    }
    
    private func setupAddProfileImageButton(){
        addProfileImageButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(addProfileImageButton)
        
        NSLayoutConstraint.activate([
            addProfileImageButton.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: -7),
            addProfileImageButton.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: -7),
            addProfileImageButton.widthAnchor.constraint(equalToConstant: addProfileImageButtonWidth),
            addProfileImageButton.heightAnchor.constraint(equalTo: addProfileImageButton.widthAnchor),
        ])
        
        addProfileImageButton.layer.cornerRadius = addProfileImageButtonWidth / 2
    }
    
    private func setupNicknameStackView(){
        nicknameStackView.translatesAutoresizingMaskIntoConstraints = false
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        nicknameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(nicknameStackView)
        
        [nicknameLabel, nicknameTextField].forEach { nicknameStackView.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            nicknameStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            nicknameStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            nicknameStackView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 30)
        ])
        
        NSLayoutConstraint.activate([
            nicknameTextField.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    private func setupBioStackView(){
        bioStackView.translatesAutoresizingMaskIntoConstraints = false
        bioLabel.translatesAutoresizingMaskIntoConstraints = false
        bioTextField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(bioStackView)
        
        [bioLabel, bioTextField].forEach { bioStackView.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            bioStackView.leadingAnchor.constraint(equalTo: nicknameStackView.leadingAnchor),
            bioStackView.trailingAnchor.constraint(equalTo: nicknameStackView.trailingAnchor),
            bioStackView.topAnchor.constraint(equalTo: nicknameStackView.bottomAnchor, constant: 30)
        ])
        
        NSLayoutConstraint.activate([
            bioTextField.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    private func setupSignupButton(){
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(signupButton)
        
        NSLayoutConstraint.activate([
            signupButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            signupButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            signupButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -5),
        ])
    }
    
    // MARK: - Actions
    
    @objc private func tfDidChange(_ sender: UITextField){
        if !(nicknameTextField.text?.isEmpty ?? true){
            signupButton.isActive = true
        }
        else {
            signupButton.isActive = false
        }
    }
    
    @objc private func addProfileImageButtonDidTap(){
        self.present(phPicker, animated: true)
    }
    
    @objc private func signUpButtonDidTap(){
        print("회원가입 완료")
    }
    
    // MARK: - Functions
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - Extension: PHPicker

extension NewUserProfileVC: PHPickerViewControllerDelegate {
    
    /// 이미지 수행 끝났을 때
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        print(results.count)
        
        if results[0].itemProvider.canLoadObject(ofClass: UIImage.self) {
            results[0].itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                self.selectedImage = image as! UIImage
            }
        }
        
        picker.dismiss(animated: true) {
            self.profileImageView.image = self.selectedImage
        }
    }
}

// MARK: - Extension: UITextField

extension NewUserProfileVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // 백스페이스 처리
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 {  // 백스페이스를 UInt32 형태로 변환하면 -92가 된다고 함 -> 비교
              return true
            }
        }
        
        if textField == bioTextField {
            guard textField.text!.count < 5 else { return false } // 50 글자로 제한
        }
        return true
    }
}

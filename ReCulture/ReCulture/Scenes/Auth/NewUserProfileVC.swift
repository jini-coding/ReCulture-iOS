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
    
    private let profileImageViewWidth: CGFloat = 90
    
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
    
    var menuItems: [UIAction] {
        var array: [UIAction] = []
        RecordType.getAllRecordTypes().forEach { type in
            array.append(UIAction(
                title: type,
                handler: { _ in
                    self.interestRangeMenuBtn.configuration?.attributedTitle = AttributedString(type)
                    self.interestRangeMenuBtn.configuration?.attributedTitle?.setAttributes(AttributeContainer([NSAttributedString.Key.font: UIFont.rcFont16M(),
                        NSAttributedString.Key.foregroundColor: UIColor.black]))
                }
            ))
        }
        return array
    }
    
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
        button.setImage(.cameraIcon, for: .normal)
        button.backgroundColor = .rcGray100
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
    
    private let birthStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 8
        return view
    }()
    
    private let birthLabel: UILabel = {
        let label = UILabel()
        label.text = "생년월일"
        label.font = .rcFont14M()
        return label
    }()
    
    private lazy var birthTextField: CustomTextField = {
        let tf = CustomTextField()
        tf.placeholder = "생년월일을 입력해주세요"
        tf.addTarget(self, action: #selector(tfDidChange), for: .editingChanged)
        tf.delegate = self
        return tf
    }()
    
    private let interestStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 8
        return view
    }()
    
    private let interestLabel: UILabel = {
        let label = UILabel()
        label.text = "관심분야"
        label.font = .rcFont14M()
        return label
    }()
    
    private let interestRangeMenuBtn: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .rcGrayBg
        config.attributedTitle = "관심분야를 설정해주세요"
        config.attributedTitle?.setAttributes(AttributeContainer([NSAttributedString.Key.font: UIFont.rcFont16M(),
                                                                 NSAttributedString.Key.foregroundColor: UIColor.black]))
        config.image = UIImage.chevronDown
        config.imagePlacement = .trailing
        config.imagePadding = 10
        config.titleAlignment = .leading
        config.background.cornerRadius = 8
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 12)
        
        button.contentHorizontalAlignment = .leading
        button.configuration = config
        return button
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
        setupBirthStackView()
        setupInterestStackView()
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
            addProfileImageButton.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor),
            addProfileImageButton.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor),
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
            nicknameStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nicknameStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
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
            bioStackView.topAnchor.constraint(equalTo: nicknameStackView.bottomAnchor, constant: 28)
        ])
        
        NSLayoutConstraint.activate([
            bioTextField.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    private func setupBirthStackView(){
        birthStackView.translatesAutoresizingMaskIntoConstraints = false
        birthLabel.translatesAutoresizingMaskIntoConstraints = false
        birthTextField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(birthStackView)
        
        [birthLabel, birthTextField].forEach { birthStackView.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            birthStackView.leadingAnchor.constraint(equalTo: bioStackView.leadingAnchor),
            birthStackView.trailingAnchor.constraint(equalTo: bioStackView.trailingAnchor),
            birthStackView.topAnchor.constraint(equalTo: bioStackView.bottomAnchor, constant: 28)
        ])
        
        NSLayoutConstraint.activate([
            birthTextField.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    private func setupInterestStackView(){
        interestStackView.translatesAutoresizingMaskIntoConstraints = false
        interestLabel.translatesAutoresizingMaskIntoConstraints = false
        interestRangeMenuBtn.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(interestStackView)
        
        [interestLabel, interestRangeMenuBtn].forEach { interestStackView.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            interestStackView.leadingAnchor.constraint(equalTo: birthStackView.leadingAnchor),
            interestStackView.trailingAnchor.constraint(equalTo: birthStackView.trailingAnchor),
            interestStackView.topAnchor.constraint(equalTo: birthStackView.bottomAnchor, constant: 28)
        ])
        
        NSLayoutConstraint.activate([
            interestRangeMenuBtn.heightAnchor.constraint(equalToConstant: 52),
            interestRangeMenuBtn.widthAnchor.constraint(equalTo: interestStackView.widthAnchor)
        ])
        
        let menu = UIMenu(children: menuItems)
        interestRangeMenuBtn.menu = menu
        interestRangeMenuBtn.showsMenuAsPrimaryAction = true
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
        
        if results.count != 0{
            if results[0].itemProvider.canLoadObject(ofClass: UIImage.self) {
                results[0].itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    self.selectedImage = image as! UIImage
                }
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

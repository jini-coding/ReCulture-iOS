//
//  EditProfileVC.swift
//  ReCulture
//
//  Created by Jini on 5/17/24.
//

import UIKit
import PhotosUI

protocol EditProfileDelegate: AnyObject {
    func didUpdateProfile(nickname: String, bio: String)
}

class EditProfileVC: UIViewController {
    
    // ViewModel
    let viewModel = MypageViewModel()
    weak var delegate: EditProfileDelegate?

    // UI Properties
    private let profileImageViewWidth: CGFloat = 90
    private let addProfileImageButtonWidth: CGFloat = 30
    private var selectedInterest = ""
    
    lazy var imageFileName = ""
    lazy var selectedImage = UIImage()
    
    // Profile Image Picker
    private lazy var phPicker: PHPickerViewController = {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images
        
        let phPicker = PHPickerViewController(configuration: config)
        phPicker.delegate = self
        return phPicker
    }()
    
    // UI Components
    let profileImage: UIImageView = {
        let imageview = UIImageView()
        imageview.backgroundColor = UIColor.rcGray200
        imageview.layer.cornerRadius = 45
        imageview.clipsToBounds = true
        imageview.contentMode = .scaleAspectFill
        return imageview
    }()
    
    var menuItems: [UIAction] {
        var array: [UIAction] = []
        RecordType.getAllRecordTypes().forEach { type in
            array.append(UIAction(
                title: type,
                handler: { _ in
                    self.selectedInterest = type
                    self.interestRangeMenuBtn.configuration?.attributedTitle = AttributedString(type)
                    self.interestRangeMenuBtn.configuration?.attributedTitle?.setAttributes(AttributeContainer([NSAttributedString.Key.font: UIFont.rcFont16M(),
                        NSAttributedString.Key.foregroundColor: UIColor.black]))
                    self.interestRangeMenuBtn.setTitle(type, for: .normal)
                }
            ))
        }
        return array
    }
    
    let addProfileImageButton: UIButton = {
        let button = UIButton()
        button.setImage(.cameraIcon, for: .normal)
        button.backgroundColor = .rcGray100
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(addProfileImageButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    let nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.textColor = UIColor.rcGray400
        label.font = UIFont.rcFont14M()
        return label
    }()
    
    lazy var nicknameTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "닉네임을 입력해주세요"
        textfield.backgroundColor = UIColor.rcGrayBg
        textfield.font = UIFont.rcFont16M()
        textfield.textColor = UIColor.black
        textfield.layer.cornerRadius = 8
        textfield.addTarget(self, action: #selector(tfDidChange), for: .editingChanged)
        
        return textfield
    }()
    
    let introLabel: UILabel = {
        let label = UILabel()
        label.text = "소개"
        label.textColor = UIColor.rcGray400
        label.font = UIFont.rcFont14M()
        return label
    }()
    
    lazy var introTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "소개글을 입력해주세요"
        textfield.backgroundColor = UIColor.rcGrayBg
        textfield.font = UIFont.rcFont16M()
        textfield.textColor = UIColor.black
        textfield.layer.cornerRadius = 8
        
        textfield.addTarget(self, action: #selector(tfDidChange), for: .editingChanged)
        return textfield
    }()
    
    let birthLabel: UILabel = {
        let label = UILabel()
        label.text = "생년월일"
        label.textColor = UIColor.rcGray400
        label.font = UIFont.rcFont14M()
        return label
    }()
    
    lazy var birthTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "생년월일을 입력해주세요"
        textfield.backgroundColor = UIColor.rcGrayBg
        textfield.font = UIFont.rcFont16M()
        textfield.textColor = UIColor.black
        textfield.layer.cornerRadius = 8
        
        textfield.addTarget(self, action: #selector(tfDidChange), for: .editingChanged)
        return textfield
    }()
    
    let interestLabel: UILabel = {
        let label = UILabel()
        label.text = "관심분야"
        label.textColor = UIColor.rcGray400
        label.font = UIFont.rcFont14M()
        return label
    }()
    
    lazy var interestRangeMenuBtn: UIButton = {
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
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12)
        
        button.setTitleColor(UIColor.black, for: .normal)
        button.contentHorizontalAlignment = .leading
        button.configuration = config
        return button
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
    
    // Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        bind()
        viewModel.getMyInfo(fromCurrentVC: self)
        
        setupUI()
        hideKeyboard()
        
        let menu = UIMenu(children: menuItems)
        interestRangeMenuBtn.menu = menu
        interestRangeMenuBtn.showsMenuAsPrimaryAction = true
    }
    
    private func setupUI() {
        setupProfileImage()
        setupAddProfileImageButton()
        setupInputNickname()
        setupInputIntro()
        setupInputBirth()
        setupSelectField()
        setupConfirmButton()
    }

    // MARK: - Bind Data
    private func bind() {
        let imageUrlStr = "http://34.64.120.187:8080\(viewModel.getProfileImage())"
            imageUrlStr.loadAsyncImage(profileImage)
        
        viewModel.myPageModelDidChange = { [weak self] in
            DispatchQueue.main.async {
                self?.nicknameTextfield.text = self?.viewModel.getNickname()
                self?.introTextfield.text = self?.viewModel.getBio()
                self?.birthTextField.text = self?.viewModel.getBirth().toDate()?.toString()
                self?.interestRangeMenuBtn.setTitle(self?.viewModel.getInterest(), for: .normal)
            }
        }
    }


    // MARK: - Actions
    
    @objc private func addProfileImageButtonDidTap() {
        self.present(phPicker, animated: true)
    }

    @objc func didTapConfirmButton() {
        guard let nickname = nicknameTextfield.text,
              let bio = introTextfield.text,
              let birthdate = birthTextField.text,
              let interest = interestRangeMenuBtn.title(for: .normal) else {
            return
        }

        let finalSelectedImage: UIImage = selectedImage.size == .zero ? profileImage.image! : selectedImage
        let imageData = finalSelectedImage.pngData() ?? Data()
        let image = ImageFile(filename: imageFileName, data: imageData, type: "png")

        viewModel.editMyProfile(
            requestDTO: EditMyProfileRequestDTO(nickname: nickname, bio: bio, birthdate: birthdate, interest: interest),
            profileImage: [image],
            fromCurrentVC: self
        )

        let alertController = UIAlertController(
            title: "수정되었습니다", message: "이전 화면으로 돌아갑니다", preferredStyle: .alert
        )

        let confirmAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            // Delegate 호출
            self.delegate?.didUpdateProfile(nickname: nickname, bio: bio)
            
            // 이전 화면으로 돌아가기
            self.navigationController?.popViewController(animated: true)
        }

        alertController.addAction(confirmAction)
        self.present(alertController, animated: true)
    }

    
    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func tfDidChange(_ sender: UITextField) {
        confirmButton.isEnabled = !(nicknameTextfield.text?.isEmpty ?? true)
    }

    // MARK: - Setup UI
    private func setupProfileImage() {
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileImage)
        NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 32),
            profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImage.heightAnchor.constraint(equalToConstant: profileImageViewWidth),
            profileImage.widthAnchor.constraint(equalToConstant: profileImageViewWidth)
        ])
        profileImage.layer.cornerRadius = profileImageViewWidth / 2
    }

    private func setupAddProfileImageButton() {
        addProfileImageButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addProfileImageButton)
        NSLayoutConstraint.activate([
            addProfileImageButton.trailingAnchor.constraint(equalTo: profileImage.trailingAnchor),
            addProfileImageButton.bottomAnchor.constraint(equalTo: profileImage.bottomAnchor),
            addProfileImageButton.widthAnchor.constraint(equalToConstant: addProfileImageButtonWidth),
            addProfileImageButton.heightAnchor.constraint(equalTo: addProfileImageButton.widthAnchor)
        ])
        addProfileImageButton.layer.cornerRadius = addProfileImageButtonWidth / 2
    }
    
    private func setupInputNickname() {
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

    private func setupInputIntro() {
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

    private func setupInputBirth() {
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

    private func setupSelectField() {
        
        interestLabel.translatesAutoresizingMaskIntoConstraints = false
        interestRangeMenuBtn.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(interestLabel)
        view.addSubview(interestRangeMenuBtn)
        
        NSLayoutConstraint.activate([
            interestLabel.topAnchor.constraint(equalTo: birthTextField.bottomAnchor, constant: 28),
            interestLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            interestLabel.heightAnchor.constraint(equalToConstant: 20),
            
            interestRangeMenuBtn.topAnchor.constraint(equalTo: interestLabel.bottomAnchor, constant: 20),
            interestRangeMenuBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            interestRangeMenuBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            interestRangeMenuBtn.heightAnchor.constraint(equalToConstant: 52)
        ])
    }

    private func setupConfirmButton() {
        view.addSubview(confirmButton)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            confirmButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            confirmButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            confirmButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            confirmButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
}

// MARK: - PHPickerViewControllerDelegate

extension EditProfileVC: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        if results.count != 0 {
            if results[0].itemProvider.canLoadObject(ofClass: UIImage.self) {
                results[0].itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    if let fileName = results[0].itemProvider.suggestedName {
                        self.imageFileName = fileName
                        print("선택된 이미지 파일 이름: \(fileName)")
                    }
                    self.selectedImage = image as! UIImage
                    DispatchQueue.main.async {
                        self.profileImage.image = self.selectedImage
                    }
                }
            }
        }
        picker.dismiss(animated: true)
    }
}

// MARK: - Keyboard Handling

extension EditProfileVC {
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

//
//  CustomizingOneVC.swift
//  ReCulture
//
//  Created by Jini on 6/2/24.
//

import UIKit
import PhotosUI

class CustomizingOneVC: UIViewController, PHPickerViewControllerDelegate {
    
    // MARK: - Properties
    
    weak var ticketCustomizingVC: TicketCustomizingVC?
    
    private var phPickerConfig: PHPickerConfiguration = {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images
        return config
    }()
    
    private lazy var phPicker = PHPickerViewController(configuration: phPickerConfig)
    
    var imageFiles: [ImageFile] = []
    var imageName: String?
    var currentFrame: Int = 1 // Track the selected frame, default to frame1
    
    // MARK: - Views
    
    let guideLabel: UILabel = {
        let label = UILabel()
        label.text = "티켓 프레임을 골라주세요"
        label.font = UIFont.rcFont24B()
        label.numberOfLines = 0
        return label
    }()
    
    let ticketFrameImage: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFit
        imageview.clipsToBounds = true
        imageview.image = UIImage(named: "frame1") // Default to frame1
        imageview.isUserInteractionEnabled = true // Enable user interaction
        return imageview
    }()
    
    // 사진 선택 버튼
    let photoSelectButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.bordered()
        config.image = .cameraIcon
        config.baseBackgroundColor = .clear
        config.background.cornerRadius = 5
        config.background.strokeColor = .rcGray100
        config.background.strokeWidth = 1
        config.contentInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
        button.configuration = config
        button.addTarget(self, action: #selector(photoSelectButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    // 선택된 이미지를 표시할 뷰
    let selectedImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.alpha = 1.0 // Adjust transparency
        view.clipsToBounds = true // Clip image to frame
        return view
    }()
    
    // Frame selection buttons
    let frameButtons: [UIButton] = {
        let titles = ["프레임1", "프레임2", "프레임3"]
        return titles.enumerated().map { index, title in
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.backgroundColor = UIColor.rcGray000
            button.setTitleColor(UIColor.rcMain, for: .normal)
            button.layer.cornerRadius = 8
            button.tag = index + 1 // 틀 태그
            button.contentEdgeInsets = UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4)
                    
            
            button.addTarget(self, action: #selector(frameButtonTapped(_:)), for: .touchUpInside)
            return button
        }
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        ticketCustomizingVC = self.parent as? TicketCustomizingVC
        
        setupGuide()
        setupImage()
        setupPhotoSelectButton()
        setupFrameButtons() // Setup the frame switching buttons
        setPhPicker()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Reapply the mask after layout to ensure correct bounds
        applyImageMask()
    }
    
    // MARK: - Setup Methods
    
    func setupGuide() {
        guideLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(guideLabel)
        NSLayoutConstraint.activate([
            guideLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 6),
            guideLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            guideLabel.heightAnchor.constraint(equalToConstant: 72)
        ])
    }
    
    func setupImage() {
        ticketFrameImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ticketFrameImage)
        NSLayoutConstraint.activate([
            ticketFrameImage.topAnchor.constraint(equalTo: guideLabel.bottomAnchor, constant: 20),
            ticketFrameImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ticketFrameImage.heightAnchor.constraint(equalToConstant: 480),
            ticketFrameImage.widthAnchor.constraint(equalToConstant: 280)
        ])
        
        // Add selected image view on top of the ticket frame
        selectedImageView.translatesAutoresizingMaskIntoConstraints = false
        ticketFrameImage.addSubview(selectedImageView)
        NSLayoutConstraint.activate([
            selectedImageView.topAnchor.constraint(equalTo: ticketFrameImage.topAnchor),
            selectedImageView.bottomAnchor.constraint(equalTo: ticketFrameImage.bottomAnchor),
            selectedImageView.leadingAnchor.constraint(equalTo: ticketFrameImage.leadingAnchor),
            selectedImageView.trailingAnchor.constraint(equalTo: ticketFrameImage.trailingAnchor)
        ])
    }
    
    func setupPhotoSelectButton() {
        photoSelectButton.translatesAutoresizingMaskIntoConstraints = false
        ticketFrameImage.addSubview(photoSelectButton)
        NSLayoutConstraint.activate([
            photoSelectButton.centerXAnchor.constraint(equalTo: ticketFrameImage.centerXAnchor),
            photoSelectButton.centerYAnchor.constraint(equalTo: ticketFrameImage.centerYAnchor),
            photoSelectButton.heightAnchor.constraint(equalToConstant: 60),
            photoSelectButton.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func setupFrameButtons() {
        // Stack view to hold frame buttons
        let buttonStackView = UIStackView(arrangedSubviews: frameButtons)
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .equalSpacing
        buttonStackView.alignment = .center
        buttonStackView.spacing = 16
        
        view.addSubview(buttonStackView)
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: ticketFrameImage.bottomAnchor, constant: 8),
            buttonStackView.heightAnchor.constraint(equalToConstant: 26),
            buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func photoSelectButtonDidTap() {
        print("버튼 선택")
        self.present(phPicker, animated: true, completion: nil)
    }
    
    @objc private func frameButtonTapped(_ sender: UIButton) {
        // Update the current frame based on which button is pressed
        currentFrame = sender.tag
        print("Selected frame: \(currentFrame)")
        
        let frameImageName = "frame\(currentFrame)"
        ticketFrameImage.image = UIImage(named: frameImageName)
        
        if selectedImageView.image != nil {
            applyImageMask()
        }
        
//        // Create and configure CustomizingFourVC
//        let customizingFourVC = CustomizingFourVC()
//
//        selectedFrame = currentFrame
//        selectedUserImage = selectedImageView.image
        
        ticketCustomizingVC?.selectedFrame = currentFrame
        
        print("Passing frame: frame\(currentFrame)")
        print("Passing user image: \(String(describing: selectedImageView.image))")
    }

    
    // MARK: - PHPickerViewControllerDelegate
    
    private func setPhPicker() {
        phPicker.delegate = self
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        // Handle the case where selection is cancelled
        if results.isEmpty {
            picker.dismiss(animated: true)
            return
        }
        
        imageFiles.removeAll()
        print("선택된 사진의 개수: \(results.count)")
        
        results.forEach { result in
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    guard let image = image as? UIImage else { return }
                    
                    DispatchQueue.main.async {
                        self.selectedImageView.image = image
                        self.applyImageMask() // Apply masking after selecting the image
                    }
                    
                    if let fileName = result.itemProvider.suggestedName {
                        self.imageName = fileName
                        self.imageFiles.append(ImageFile(filename: fileName, data: image.pngData()!, type: "png"))
                        print("선택된 이미지 파일 이름: \(fileName)")
                    }
                    
                    // 마스킹 후 이미지를 캡처하여 저장
//                    DispatchQueue.main.async {
//                        if let maskedImage = self.captureMaskedImage() {
//                            // 마스킹된 이미지를 저장하거나 사용
//                            UIImageWriteToSavedPhotosAlbum(maskedImage, nil, nil, nil)
//                            print("마스킹된 이미지가 저장되었습니다.")
//                        }
//                    }
                }
            }
        }
        
        if let selectedImage = selectedImageView.image {
            ticketCustomizingVC?.selectedUserImage = selectedImage
        }
        picker.dismiss(animated: true)
    }
    
    // MARK: - 티켓 모양 마스킹 적용 함수
    
    func applyImageMask() {
        // Mask the image based on the current frame
        guard let maskImage = UIImage(named: "frame\(currentFrame)")?.cgImage else { return }

        let maskLayer = CALayer()
        maskLayer.contents = maskImage
        maskLayer.frame = ticketFrameImage.bounds // Adjust the mask to fit the ticket frame

        // Apply the mask to the selected image view
        selectedImageView.layer.mask = maskLayer
        //selectedImageView.layer.masksToBounds = true
    }



}

//extension CustomizingOneVC {
//    func captureMaskedImage() -> UIImage? {
//        // 캡처할 이미지의 크기를 280x480으로 설정
//        let captureSize = CGSize(width: 280, height: 480)
//        // UIGraphicsImageRenderer를 사용해 280x480 사이즈로 렌더러를 설정
//        let renderer = UIGraphicsImageRenderer(size: captureSize)
//
//        // 이미지 캡처 시작
//        let capturedImage = renderer.image { context in
//            // 배경을 투명하게 설정
//            context.cgContext.setFillColor(UIColor.clear.cgColor)
//            context.cgContext.fill(CGRect(origin: .zero, size: captureSize))
//
//            // ticketFrameImage의 레이어를 캡처
//            ticketFrameImage.layer.render(in: context.cgContext)
//        }
//
//        return capturedImage
//    }
//}


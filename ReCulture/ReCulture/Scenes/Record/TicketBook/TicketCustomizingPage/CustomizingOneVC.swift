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
    
    private var phPickerConfig: PHPickerConfiguration = {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images
        return config
    }()
    
    private lazy var phPicker = PHPickerViewController(configuration: phPickerConfig)
    
    var imageFiles: [ImageFile] = []
    
    // MARK: - Views
    
    let guideLabel: UILabel = {
        let label = UILabel()
        label.text = "티켓 배경을 골라주세요"
        //label.text = "티켓 틀을 골라주세요"
        label.font = UIFont.rcFont24B()
        label.numberOfLines = 0
        return label
    }()
    
    let ticketFrameImage: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFit
        imageview.clipsToBounds = true
        imageview.image = UIImage(named: "frame1") // 프레임 이미지를 설정
        imageview.isUserInteractionEnabled = true // 터치 가능하도록 설정
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
        view.alpha = 1 // 투명도 조정
        view.clipsToBounds = true // 이미지를 프레임 안에 맞춤
        return view
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        setupGuide()
        setupImage()
        setupPhotoSelectButton()
        setPhPicker()
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
        
        // 선택된 이미지 뷰를 티켓 프레임 위에 추가
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
    
    // MARK: - Actions
    
    @objc private func photoSelectButtonDidTap() {
        print("버튼 선택")
        self.present(phPicker, animated: true, completion: nil)
    }
    
    // MARK: - PHPickerViewControllerDelegate
    
    private func setPhPicker() {
        phPicker.delegate = self
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        // 선택을 취소했을 때
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
                        self.applyImageMask() // 마스킹 적용
                        
                    }
                    
                    if let fileName = result.itemProvider.suggestedName {
                        self.imageFiles.append(ImageFile(filename: fileName, data: image.pngData()!, type: "png"))
                        print("선택된 이미지 파일 이름: \(fileName)")
                    }
                }
            }
        }
        
        picker.dismiss(animated: true)
    }
    
    // MARK: - 티켓 모양 마스킹 적용 함수
    
    func applyImageMask() {
        guard let maskImage = UIImage(named: "frame1")?.cgImage else { return }

        let maskLayer = CALayer()
        maskLayer.contents = maskImage
        maskLayer.frame = ticketFrameImage.bounds // 이미지 프레임과 동일하게 맞춤

        // 선택된 이미지에 마스크 적용
        selectedImageView.layer.mask = maskLayer
        
        // ticketFrameImage의 이미지만 제거
        ticketFrameImage.image = nil
    }



}

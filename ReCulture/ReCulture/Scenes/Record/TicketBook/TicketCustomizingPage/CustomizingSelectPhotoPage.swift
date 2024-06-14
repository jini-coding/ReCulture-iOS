//
//  CustomizingSelectPhotoPage.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 6/14/24.
//

import UIKit
import PhotosUI

class CustomizingSelectPhotoPage: UIViewController {
    
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
        label.text = "사진을 선택해주세요"
        label.font = UIFont.rcFont24B()
        label.numberOfLines = 0
        
        return label
    }()
    
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
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        setupGuide()
        setupButton()
        setupImageView()
        
        setPhPicker()
    }
    
    func setupGuide() {
        guideLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(guideLabel)
        
        NSLayoutConstraint.activate([
            guideLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 6),
            guideLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            guideLabel.heightAnchor.constraint(equalToConstant: 72)
        ])
    }
    
    func setupButton() {
        photoSelectButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(photoSelectButton)
        
        NSLayoutConstraint.activate([
            photoSelectButton.topAnchor.constraint(equalTo: guideLabel.bottomAnchor, constant: 25),
            photoSelectButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
            photoSelectButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35),
            photoSelectButton.heightAnchor.constraint(equalTo: photoSelectButton.widthAnchor, multiplier: 40/28),
        ])
    }
    
    func setupImageView(){
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageView)
        
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageViewDidTap)))
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: photoSelectButton.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: photoSelectButton.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: photoSelectButton.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: photoSelectButton.trailingAnchor)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func photoSelectButtonDidTap(){
        print("버튼 선택")
        self.present(phPicker, animated: true, completion: nil)
    }
    
    @objc private func imageViewDidTap(){
        self.present(phPicker, animated: true, completion: nil)
    }
    
    // MARK: - Functions
    
    private func setPhPicker(){
        phPicker.delegate = self
    }
}

extension CustomizingSelectPhotoPage: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        // cancel 눌렀을 때
        if results.isEmpty {
            picker.dismiss(animated: true)
            return
        }
        
        imageFiles.removeAll()
        print("선택된 사진의 개수: \(results.count)")
        
        results.forEach { result in
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    let image = image as! UIImage
                    
                    DispatchQueue.main.async {
                        self.imageView.image = image.resizeImage(size: self.imageView.frame.size)
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
}


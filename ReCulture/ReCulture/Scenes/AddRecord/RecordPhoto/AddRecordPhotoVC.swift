//
//  AddRecordPhotoVC.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 5/31/24.
//

import UIKit
import PhotosUI

final class AddRecordPhotoVC: UIViewController {
    
    // MARK: - Properties
    
    static let photoMaxSelectionCount = 5
    
    private let requestDTO: AddRecordRequestDTO
    
    private let viewModel = AddRecordPhotoViewModel()
    
    private var phPickerConfig: PHPickerConfiguration = {
        var config = PHPickerConfiguration()
        config.selectionLimit = photoMaxSelectionCount
        config.filter = .images
        return config
    }()
    
    private lazy var phPicker = PHPickerViewController(configuration: phPickerConfig)
    
    private let minimumLineSpacing: CGFloat = 12
    private let minimumInteritemSpacing: CGFloat = 8
    
    private var selectedPhotos: [UIImage] = [] {
        didSet{
            if selectedPhotos.count != 0 {
                DispatchQueue.main.async {
                    self.addPhotoButtonView.isHidden = true
                    self.addPhotoButtonView.isUserInteractionEnabled = false
                    self.uploadButton.isActive = true
                }
            }
            else {
                DispatchQueue.main.async {
                    self.addPhotoButtonView.isHidden = false
                    self.addPhotoButtonView.isUserInteractionEnabled = true
                    self.uploadButton.isActive = false
                }
            }
        }
    }
    
    private var imageFiles: [ImageFile] = []
    
    var postNewRecordSuccess = false {
        didSet {
            goBackToPreviousTab(postNewRecordSuccess)
        }
    }
    
    // MARK: - Views
    
    private let headerView = HeaderView(title: "기록 추가", withCloseButton: false)
    
    private let photoTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "문화 생활을 기록할\n사진을 추가해주세요"
        label.font = .rcFont26B()
        label.numberOfLines = 2
        return label
    }()
    
    private let addPhotoButtonView: AddPhotoButtonView = {
        let view = AddPhotoButtonView()
        return view
    }()
    
    private lazy var photoCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = minimumLineSpacing
        flowLayout.minimumInteritemSpacing = minimumInteritemSpacing
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .white
        view.register(AddRecordPhotoCell.self, forCellWithReuseIdentifier: AddRecordPhotoCell.identifier)
        view.register(AddPhotoCell.self, forCellWithReuseIdentifier: AddPhotoCell.identifier)
        return view
    }()
    
    private let uploadButton: NextButton = {
        let button = NextButton("업로드하기")
        button.addTarget(self, action: #selector(uploadButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    // MARK: - init
    
    init(requestDTO: AddRecordRequestDTO) {
        self.requestDTO = requestDTO
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        
        setHeaderView()
        setPhotoTitlelLabel()
        
        setPhotoCollectionView()
        setAddPhotoButtonView()  // 제일 위로
        setUploadButton()
        
        setPhPicker()
    }
    
    // MARK: - Layout
    
    private func setHeaderView() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(headerView)
        
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
        ])
        
        headerView.addBackButtonTarget(target: self, action: #selector(goBack), for: .touchUpInside)
    }
    
    private func setPhotoTitlelLabel() {
        photoTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(photoTitleLabel)
        
        NSLayoutConstraint.activate([
            photoTitleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            photoTitleLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 40),
        ])
    }
    
    private func setAddPhotoButtonView() {
        print(addPhotoButtonView.layer.sublayers)
        
        addPhotoButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openLibrary)))
        
        addPhotoButtonView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(addPhotoButtonView)
        
        NSLayoutConstraint.activate([
            addPhotoButtonView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            addPhotoButtonView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
        ])
    }
    
    private func setPhotoCollectionView() {
        photoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(photoCollectionView)
        
        NSLayoutConstraint.activate([
            photoCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            photoCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            photoCollectionView.topAnchor.constraint(equalTo: photoTitleLabel.bottomAnchor, constant: 36),
        ])
    }
    
    private func setUploadButton() {
        uploadButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(uploadButton)
        
        NSLayoutConstraint.activate([
            uploadButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            uploadButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            uploadButton.topAnchor.constraint(equalTo: photoCollectionView.bottomAnchor, constant: 32),
            uploadButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5),
        ])
    }
    
    private func setPhPicker() {
        phPicker.delegate = self
    }
    
    // MARK: - Actions
    
    @objc private func goBack() {
        print("기록 내용 입력 화면으로 이동")
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func openLibrary(_ gesture: UITapGestureRecognizer) {
        self.present(phPicker, animated: true, completion: nil)
    }
    
    @objc private func uploadButtonDidTap() {
        LoadingIndicator.showLoading()
        print("==업로드 버튼 눌림==")
        print(imageFiles)
        viewModel.postNewRecord(requestDTO: requestDTO, photos: imageFiles, fromCurrentVC: self)
    }
    
    // MARK: - Functions
    
    func goBackToPreviousTab(_ success: Bool) {
        DispatchQueue.main.async {
            let parentVC = self.presentingViewController
            print(parentVC)
            let grandParentVC = parentVC?.presentingViewController as? TabBarVC
            print(grandParentVC)
            self.presentingViewController?.presentingViewController?.dismiss(animated: true) {
                print(RecordTypeVC.previousSelectedTabbarIndex)
                let recordTypeVC = grandParentVC?.viewControllers?[2] as? RecordTypeVC
                recordTypeVC?.initializeViews()
                grandParentVC?.selectedIndex = RecordTypeVC.previousSelectedTabbarIndex
            }
            LoadingIndicator.hideLoading()
        }
    }
}

// MARK: - Extension

extension AddRecordPhotoVC: PHPickerViewControllerDelegate {
    
    /// 이미지 수행 끝났을 때
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        // cancel 눌렀을 때
        if results.isEmpty {
            picker.dismiss(animated: true)
            return
        }
        selectedPhotos.removeAll()
        imageFiles.removeAll()
        print("선택된 사진의 개수: \(results.count)")
        
        
        results.forEach { result in
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    let image = image as! UIImage
                    let compressionedImage: Data? = image.jpegData(compressionQuality: 0.2)!
                    
                    DispatchQueue.main.async {
                        self.selectedPhotos.append(image)
                        self.photoCollectionView.reloadData()
                    }
                    if let fileName = result.itemProvider.suggestedName {
                        self.imageFiles.append(ImageFile(filename: fileName, data: compressionedImage!, type: "jpeg"))
                        print("선택된 이미지 파일 이름: \(fileName)")
                    }
                }
            }
        }
        
        picker.dismiss(animated: true)
    }
}

// MARK: - Extension: UICollectionView

extension AddRecordPhotoVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if selectedPhotos.count == 5 || selectedPhotos.count == 0 {
            return selectedPhotos.count
        }
        else {
            return selectedPhotos.count + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 5개 다 채웠을 때는 선택된 사진으로만 된 셀로 구성
        if selectedPhotos.count == 5 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddRecordPhotoCell.identifier, for: indexPath) as? AddRecordPhotoCell
            else { return UICollectionViewCell() }
            
            cell.configure(image: selectedPhotos[indexPath.item])
            cell.removeBtnCallBackMehtod = { [weak self] in
                let index = indexPath.item
                self?.selectedPhotos.remove(at: index)
                self?.imageFiles.remove(at: index)
                DispatchQueue.main.async { collectionView.reloadData() }
            }
            return cell
        }
        // 5개를 다 채우지 않았을 때 마지막 셀은 +가 있는 셀로 구성
        else {
            if indexPath.item == selectedPhotos.count {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddPhotoCell.identifier, for: indexPath) as? AddPhotoCell else { return UICollectionViewCell() }
                return cell
            }
            else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddRecordPhotoCell.identifier, for: indexPath) as? AddRecordPhotoCell
                else { return UICollectionViewCell() }
                
                cell.configure(image: selectedPhotos[indexPath.item])
                cell.removeBtnCallBackMehtod = { [weak self] in
                    let index = indexPath.item
                    self?.selectedPhotos.remove(at: index)
                    self?.imageFiles.remove(at: index)
                    self?.phPicker = PHPickerViewController(configuration: (self?.phPickerConfig)!)
                    self?.phPicker.delegate = self
                    DispatchQueue.main.async { collectionView.reloadData() }
                }
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedPhotos.count != 5 && indexPath.item == selectedPhotos.count {
            self.present(phPicker, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - minimumLineSpacing) / 2
        let height = width
        return CGSize(width: width, height: height)
    }
}

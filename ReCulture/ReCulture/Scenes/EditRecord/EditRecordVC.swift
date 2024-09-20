//
//  EditRecordVC.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 9/16/24.
//

import UIKit
import PhotosUI

protocol EditRecordDelegate: AnyObject {
    func doneEditingRecordVC()
}

final class EditRecordVC: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: EditRecordDelegate?
    
    var editRecordSuccess = false {
        didSet {
            print("=== edit record success didset ===")
            self.dismiss(animated: true)
            delegate?.doneEditingRecordVC()
        }
    }
    private let viewModel = EditRecordViewModel()
    
    private var recordModel: RecordModel
    private var recordType: RecordType
    
    private var selectedCategory: RecordType = .book
    private var disclosure: DisclosureType = .Public
    
    private var categoryItems: [UIAction] {
        var array: [UIAction] = []
        RecordType.getAllRecordTypes().forEach { type in
            array.append(UIAction(
                title: type,
                handler: { _ in
                    self.selectedCategory = RecordType(rawValue: type) ?? .book
                    self.categoryRangeMenuBtn.configuration?.attributedTitle = AttributedString(type)
                    self.categoryRangeMenuBtn.configuration?.attributedTitle?.setAttributes(AttributeContainer([NSAttributedString.Key.font: UIFont.rcFont16M(),
                        NSAttributedString.Key.foregroundColor: UIColor.black]))
                }
            ))
        }
        return array
    }
    
    private var phPickerConfig: PHPickerConfiguration = {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 0
        config.filter = .images
        return config
    }()
    
    private lazy var phPicker = PHPickerViewController(configuration: phPickerConfig)
    
    /// Identifier와 PHPickerResult로 만든 Dictionary (이미지 데이터를 저장하기 위해 만들어 줌)
    private var selections = [String : PHPickerResult]()
    
    /// 선택한 사진의 순서에 맞게 Identifier들을 배열로 저장해줄 겁니다.
    /// selections은 딕셔너리이기 때문에 순서가 없습니다. 그래서 따로 식별자를 담을 배열 생성
    private var selectedAssetIdentifiers = [String]()
    
    /// 갤러리를 통해 새로 선택한 이미지들
    private var newlySelectedPhotos: [PHPickerResult] = []
    
    /// 실제 collectionview에서 보여주는 사진들 리스트
    private var images: [Any] = []
    
    /// 갤러리를 통해 새로 선택한 이미지들
    private var imageFiles: [ImageFile] = []
    
    private var isFourTextFieldsView = false
    
    private var disclosureItems: [UIAction] {
        var array: [UIAction] = []
        ["공개", "팔로워", "비공개"].forEach { type in
            array.append(UIAction(
                title: type,
                handler: { _ in
                    self.disclosure = DisclosureType.getDisclosureTypeByKorean(type)
                    self.recordRangeMenuBtn.configuration?.attributedTitle = AttributedString(type)
                    self.recordRangeMenuBtn.configuration?.attributedTitle?.setAttributes(AttributeContainer([NSAttributedString.Key.font: UIFont.rcFont16M(),
                        NSAttributedString.Key.foregroundColor: UIColor.black]))
                }
            ))
        }
        return array
    }
    
    // MARK: - Views
    
    private let customHeaderView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let exitButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.closeIcon, for: .normal)
        button.addTarget(self, action: #selector(exitButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "기록 수정"
        label.font = .rcFont16M()
        label.textColor = .black
        return label
    }()
    
    private let doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.setTitleColor(.rcMain, for: .normal)
        button.setTitleColor(.rcLightPurple, for: .highlighted)
        button.setTitleColor(.rcGray200, for: .selected)
        button.titleLabel?.font = .rcFont16B()
        button.addTarget(self, action: #selector(doneButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsHorizontalScrollIndicator = false
        view.isScrollEnabled = true
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let titleTextField: UITextField = {
        let tf = UITextField()
        tf.font = .rcFont20B()
        tf.textColor = .black
        tf.text = "오늘은 시카고를 봐서 너무 행복한 하루"
        return tf
    }()
    
    private let borderLine1: UIView = {
        let view = UIView()
        view.backgroundColor = .rcGray100
        return view
    }()
    
    private lazy var dateTextField: CustomTextField = {
        let tf = CustomTextField()
        tf.delegate = self
        tf.tintColor = .clear
        return tf
    }()
    
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.addTarget(self, action: #selector(datePickerValueDidChange), for: .valueChanged)
        return picker
    }()
    
    private let categoryRangeMenuBtn: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .rcGrayBg
        config.attributedTitle = "카테고리"
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
    
    private lazy var photoCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 8
        flowLayout.minimumInteritemSpacing = 0
        
        let width = UIScreen.main.bounds.width - 32
        let height = width * 5 / 4
        flowLayout.itemSize = CGSize(width: width, height: height)
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        view.showsHorizontalScrollIndicator = false
        view.dataSource = self
        view.delegate = self
        view.isPagingEnabled = false
        view.contentInsetAdjustmentBehavior = .never
        view.decelerationRate = .fast
        view.register(EditPhotoCollectionViewCell.self,
                      forCellWithReuseIdentifier: EditPhotoCollectionViewCell.identifier)
        view.register(EditVCAddPhotoCell.self,
                      forCellWithReuseIdentifier: EditVCAddPhotoCell.identifier)
        return view
    }()
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .rcGray000
        pageControl.currentPageIndicatorTintColor = .rcMain
        pageControl.hidesForSinglePage = true
        return pageControl
    }()
    
    private lazy var fourTextFieldsView = EditFourTextFieldsView()
    private lazy var fiveTextFieldsView = EditFiveTextFieldsView()
    
    private let emojiStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 4
        return view
    }()
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.text = "이모지 총평"
        label.font = .rcFont14M()
        label.textColor = .rcGray400
        return label
    }()
    
    private let emojiTextField: CustomTextField = {
        let textField = CustomTextField()
//        textField.placeholder = "이모지로 감상을 표현해주세요"
        //textField.addTarget(self, action: #selector(emojiTextFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    private let recordRangeStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 4
        return view
    }()
    
    private let recordRangeLabel: UILabel = {
        let label = UILabel()
        label.text = "공개여부"
        label.font = .rcFont14M()
        label.textColor = .rcGray400
        return label
    }()
    
    private let recordRangeMenuBtn: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .rcGrayBg
        config.attributedTitle = "공개여부"
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
    
    // MARK: - Lifecycle
    
    init(recordModel: RecordModel) {
        self.recordModel = recordModel
        self.recordType = RecordType(categoryId: recordModel.culture.categoryId) ?? .movie
        self.images = recordModel.photoDocs
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("view did load, recordModel: \(recordModel)")
        print("images: \(images)")
        
        view.backgroundColor = .white
        
        phPicker.delegate = self
        
        addKeyboardObserver()
        
        setupCustomHeaderView()
        setupScrollView()
        setupContentView()
        setupTitleTextFieldAndBorderLine()
        setupDatePickerAndTextField()
        setupCategoryRangeMenuBtn()
        setupPhotoCollectionView()
        setupPageControl()
        
        // 영화, 뮤지컬, 연극, 드라마, 전시회, 기타이면 4칸짜리 뷰를 넣어야 함
        switch RecordType(categoryId: recordModel.culture.categoryId) {
        case .movie, .musical, .play, .drama, .exhibition, .etc:
            isFourTextFieldsView = true
        default: 
            isFourTextFieldsView = false
        }
        setupDetailView()
        setupEmojiStackView()
        setupRecordRangeStackView()
        
        configureWithData()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeKeyBoardObserver()
    }
    
    // MARK: - Layouts
    
    private func setupCustomHeaderView() {
        [customHeaderView, exitButton, titleLabel, doneButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        view.addSubview(customHeaderView)
        
        customHeaderView.addSubview(exitButton)
        customHeaderView.addSubview(titleLabel)
        customHeaderView.addSubview(doneButton)
        
        // customHeaderView 제약 조건
        NSLayoutConstraint.activate([
            customHeaderView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            customHeaderView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            customHeaderView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            customHeaderView.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        // exitButton 제약 조건
        NSLayoutConstraint.activate([
            exitButton.leadingAnchor.constraint(equalTo: customHeaderView.leadingAnchor, constant: 4),
            exitButton.centerYAnchor.constraint(equalTo: customHeaderView.centerYAnchor),
        ])
        
        // titleLabel 제약 조건
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: customHeaderView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: customHeaderView.centerYAnchor),
        ])
        
        // doneButton 제약 조건
        NSLayoutConstraint.activate([
            doneButton.trailingAnchor.constraint(equalTo: customHeaderView.trailingAnchor, constant: -16),
            doneButton.centerYAnchor.constraint(equalTo: customHeaderView.centerYAnchor)
        ])
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: customHeaderView.bottomAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(scrollViewTapped))
        tapGesture.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(tapGesture)
    }
    
    private func setupContentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
    }
    
    private func setupTitleTextFieldAndBorderLine() {
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        borderLine1.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(titleTextField)
        contentView.addSubview(borderLine1)
        
        NSLayoutConstraint.activate([
            titleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 21),
            
            borderLine1.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor),
            borderLine1.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor),
            borderLine1.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 5),
            borderLine1.heightAnchor.constraint(equalToConstant: 1),
        ])
    }
    
    private func setupDatePickerAndTextField() {
        dateTextField.inputView = datePicker
        // TODO: 나중에 밖으로 빼야 함
        dateTextField.text = dateFormatToString(date: Date())
        
        dateTextField.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(dateTextField)
        
        NSLayoutConstraint.activate([
            dateTextField.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor),
            dateTextField.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor),
            dateTextField.topAnchor.constraint(equalTo: borderLine1.bottomAnchor, constant: 15),
            dateTextField.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    private func setupCategoryRangeMenuBtn() {
        categoryRangeMenuBtn.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(categoryRangeMenuBtn)
                
        NSLayoutConstraint.activate([
            categoryRangeMenuBtn.leadingAnchor.constraint(equalTo: dateTextField.leadingAnchor),
            categoryRangeMenuBtn.trailingAnchor.constraint(equalTo: dateTextField.trailingAnchor),
            categoryRangeMenuBtn.topAnchor.constraint(equalTo: dateTextField.bottomAnchor, constant: 15),
            categoryRangeMenuBtn.heightAnchor.constraint(equalToConstant: 44),
        ])
        
        let menu = UIMenu(children: categoryItems)
        categoryRangeMenuBtn.menu = menu
        categoryRangeMenuBtn.showsMenuAsPrimaryAction = true
    }
    
    private func setupPhotoCollectionView() {
        photoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(photoCollectionView)
        
        NSLayoutConstraint.activate([
            photoCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photoCollectionView.topAnchor.constraint(equalTo: categoryRangeMenuBtn.bottomAnchor, constant: 25),
            photoCollectionView.heightAnchor.constraint(equalTo: photoCollectionView.widthAnchor, multiplier: 5 / 4),
        ])
    }
    
    private func setupPageControl() {
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            pageControl.topAnchor.constraint(equalTo: photoCollectionView.bottomAnchor/*, constant: 8*/),
        ])
    }
    
    private func setupDetailView() {
        if isFourTextFieldsView {
            let placeholderList = RecordPlaceholders.getTitlesByRecordType(recordType)
            print("=== setup detail view ===")
            print("placeholder: \(placeholderList)")
            
            fourTextFieldsView.translatesAutoresizingMaskIntoConstraints = false
            
            contentView.addSubview(fourTextFieldsView)
            
            NSLayoutConstraint.activate([
                fourTextFieldsView.leadingAnchor.constraint(equalTo: categoryRangeMenuBtn.leadingAnchor),
                fourTextFieldsView.trailingAnchor.constraint(equalTo: categoryRangeMenuBtn.trailingAnchor),
                fourTextFieldsView.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 25),
            ])
            
//            fourTextFieldsView.configure(placeholderList, withData: [recordModel.culture.detail1,
//                                                                     recordModel.culture.detail2,
//                                                                     recordModel.culture.detail3,
//                                                                     recordModel.culture.review])
        }
        else {
            let placeholderList = RecordPlaceholders.getTitlesByRecordType(recordType)
            
            fiveTextFieldsView.translatesAutoresizingMaskIntoConstraints = false
            
            contentView.addSubview(fiveTextFieldsView)
            
            NSLayoutConstraint.activate([
                fiveTextFieldsView.leadingAnchor.constraint(equalTo: categoryRangeMenuBtn.leadingAnchor),
                fiveTextFieldsView.trailingAnchor.constraint(equalTo: categoryRangeMenuBtn.trailingAnchor),
                fiveTextFieldsView.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 28),
            ])
            
//            fiveTextFieldsView.configure(placeholderList, withData: [recordModel.culture.detail1,
//                                                                     recordModel.culture.detail2,
//                                                                     recordModel.culture.detail3,
//                                                                     recordModel.culture.review])
        }
    }
    
    private func setupEmojiStackView() {
        emojiStackView.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiTextField.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(emojiStackView)
        
        emojiStackView.addArrangedSubview(emojiLabel)
        emojiStackView.addArrangedSubview(emojiTextField)
        
        if(isFourTextFieldsView) {
            NSLayoutConstraint.activate([
                emojiStackView.leadingAnchor.constraint(equalTo: fourTextFieldsView.leadingAnchor),
                emojiStackView.trailingAnchor.constraint(equalTo: fourTextFieldsView.trailingAnchor),
                emojiStackView.topAnchor.constraint(equalTo: fourTextFieldsView.bottomAnchor, constant: 28),
            ])
        }
        else {
            NSLayoutConstraint.activate([
                emojiStackView.leadingAnchor.constraint(equalTo: fiveTextFieldsView.leadingAnchor),
                emojiStackView.trailingAnchor.constraint(equalTo: fiveTextFieldsView.trailingAnchor),
                emojiStackView.topAnchor.constraint(equalTo: fiveTextFieldsView.bottomAnchor, constant: 28),
            ])
        }
        
        NSLayoutConstraint.activate([
            emojiTextField.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    private func setupRecordRangeStackView() {
        recordRangeStackView.translatesAutoresizingMaskIntoConstraints = false
        recordRangeLabel.translatesAutoresizingMaskIntoConstraints = false
        recordRangeMenuBtn.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(recordRangeStackView)
        
        recordRangeStackView.addArrangedSubview(recordRangeLabel)
        recordRangeStackView.addArrangedSubview(recordRangeMenuBtn)
        
        NSLayoutConstraint.activate([
            recordRangeStackView.leadingAnchor.constraint(equalTo: emojiStackView.leadingAnchor),
            recordRangeStackView.trailingAnchor.constraint(equalTo: emojiStackView.trailingAnchor),
            recordRangeStackView.topAnchor.constraint(equalTo: emojiStackView.bottomAnchor, constant: 28),
            recordRangeStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
        ])
        
        NSLayoutConstraint.activate([
            recordRangeMenuBtn.heightAnchor.constraint(equalToConstant: 52),
            recordRangeMenuBtn.widthAnchor.constraint(equalTo: recordRangeStackView.widthAnchor)
        ])
        
        let menu = UIMenu(children: disclosureItems)
        recordRangeMenuBtn.menu = menu
        recordRangeMenuBtn.showsMenuAsPrimaryAction = true
    }
    
    // MARK: - Actions
    
    // 키보드가 나타났다는 알림을 받으면 실행할 메서드
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo as NSDictionary?,
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else { return }
        
        /// 키보드의 높이
        let keyboardHeight = keyboardFrame.size.height
        scrollView.contentInset.bottom = keyboardHeight
            
        UIView.animate(withDuration: 0.3,
                       animations: { self.view.layoutIfNeeded() },
                       completion: nil)
    }

    // 키보드 숨겨질 때 -> 원래 상태로
    @objc private func keyboardWillHide(_ notification: NSNotification) {
        let animationDuration = notification.userInfo![ UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        
        scrollView.contentInset.bottom = .zero
                
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func scrollViewTapped() {
        scrollView.endEditing(true)
    }
    
    @objc private func exitButtonDidTap() {
        print("수정 그만하기")
        let alertContoller = UIAlertController(title: "정말 기록 수정을 그만하시겠어요?", message: "변경된 사항은 저장되지 않습니다.", preferredStyle: .alert)
        alertContoller.addAction(UIAlertAction(title: "취소", style: .cancel) { _ in
            print("기록 수정 계속 하기")
        })
        alertContoller.addAction(UIAlertAction(title: "그만하기", style: .destructive) { _ in
            print("기록 수정 그만하기")
            self.dismiss(animated: true)
        })
        present(alertContoller, animated: true)
    }
    
    @objc private func doneButtonDidTap() {
        print("기록 수정 완료")
        editRecordSuccess = true
    }
    
    @objc private func datePickerValueDidChange(_ sender: UIDatePicker) {
        dateTextField.text = dateFormatToString(date: datePicker.date)
    }
    
    // MARK: - Functions
    
    private func dateFormatToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func removeKeyBoardObserver() {
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillShowNotification)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillHideNotification)
    }
    
    private func setPageControlCount(_ pages: Int) {
        pageControl.numberOfPages = pages
    }
    
    private func configureWithData() {
        titleTextField.text = recordModel.culture.title
        
        if let date = recordModel.culture.date.toDate() {
            datePicker.date = date
        }
        
        if let categoryType = RecordType(categoryId: recordModel.culture.categoryId) {
            categoryRangeMenuBtn.configuration?.attributedTitle = AttributedString(categoryType.rawValue, attributes: AttributeContainer([
                NSAttributedString.Key.font: UIFont.rcFont16M(),
                NSAttributedString.Key.foregroundColor: UIColor.black])
            )
        }
        
        // 이미지 & page control
        print("image 개수: \(recordModel.photoDocs.count)")
        pageControl.numberOfPages = recordModel.photoDocs.count
        DispatchQueue.main.async { [weak self] in
            self?.photoCollectionView.reloadData()
        }
        
        // 앞서 넘어온 데이터 중 이미지를 image file로 변경해서 imageFile로 변환하여 imageFiles에 저장
        for photoDoc in recordModel.photoDocs {
            if let url = URL(string: "http://34.64.120.187:8080\(photoDoc.url)") {
                DispatchQueue.global().async { [weak self] in
                    if let data = try? Data(contentsOf: url) {
                        let originalFileName = String(photoDoc.url.split(separator: "/").last!)
                        let fileName = originalFileName.split(separator: ".").first!
                        
                        self?.imageFiles.append(ImageFile(filename: String(fileName),
                                                         data: data,
                                                         type: "jpeg"))
                    }
                }
            }
        }
        
        // 기록 상세 후기 뷰 만들기
        if isFourTextFieldsView {
            fourTextFieldsView.configure(RecordPlaceholders.getTitlesByRecordType(recordType),
                                         withData: [recordModel.culture.detail1,
                                                    recordModel.culture.detail2,
                                                    recordModel.culture.detail3,
                                                    recordModel.culture.review])
        }
        else {
            fiveTextFieldsView.configure(RecordPlaceholders.getTitlesByRecordType(recordType),
                                         withData: [recordModel.culture.detail1,
                                                    recordModel.culture.detail2,
                                                    recordModel.culture.detail3,
                                                    recordModel.culture.detail4,
                                                    recordModel.culture.review])
        }
        
        emojiTextField.text = recordModel.culture.emoji
        
        if let disclosureType = DisclosureType(rawValue: recordModel.culture.disclosure) {
            recordRangeMenuBtn.configuration?.attributedTitle = AttributedString(disclosureType.getKorean(), attributes: AttributeContainer([
                NSAttributedString.Key.font: UIFont.rcFont16M(),
                NSAttributedString.Key.foregroundColor: UIColor.black])
            )
        }
    }
}

// MARK: - Extensions: UITextField

extension EditRecordVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == dateTextField {
            return false
        }
        return true
    }
}

// MARK: - Extension: UICollectionView

extension EditRecordVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("===edit record===")
        let count = images.count
        print("cell 개수: \(count)")
        return count == 5 ? count : count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let count = images.count
        
        print("=== cell for item at ===")
        print("indexPath: \(indexPath)")
        
        if count != 5 && indexPath.item == count {
            print("-- edit vc add photo cell 보여줌 --")
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EditVCAddPhotoCell.identifier, for: indexPath) as? EditVCAddPhotoCell
            else { return UICollectionViewCell() }
            return cell
        }
        else {
            print("-- EditPhotoCollectionViewCell 보여줌 --")
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EditPhotoCollectionViewCell.identifier, for: indexPath) as? EditPhotoCollectionViewCell
            else { return UICollectionViewCell() }
            //        print((collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize)
            
            cell.delegate = self
            
            print("image: \(images[indexPath.item])")
            print("===============")
            print("image: \(images.last)")
            
            let thisIsPhotoDoc = (images[indexPath.item] is RecordModel.PhotoDoc)
            
            if let photoDoc = images[indexPath.item] as? RecordModel.PhotoDoc {
                print("this is actual photo")
                cell.configureWithURL(with: photoDoc.url, thisCellIndexPath: indexPath)
            }
            else if let uiImage = images[indexPath.item] as? UIImage {
                print("this is not actual photo")
                cell.configureWithImage(image: uiImage, thisCellIndexPath: indexPath)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("=== did select item at ===")
//        let count = recordModel.photoDocs.count
        let count = images.count
        
        if count != 5 && indexPath.item == count {
            print("imageFiles: \(imageFiles)")
            self.present(phPicker, animated: true, completion: nil)
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EditVCAddPhotoCell.identifier, for: indexPath) as? EditVCAddPhotoCell
            else { return }
            print("cell is EditVCAddPhotoCell: \(cell)")
        }
        else {
            print("cell is NOT EditVCAddPhotoCell")
        }
    }
    
    // collectionview는 전체 화면 너비를 기준으로 페이징하기 때문에, section inset에 대해 적용되도록 하는 코드
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let layout = photoCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        else { return }
        
        let scrolledOffsetX = targetContentOffset.pointee.x + scrollView.contentInset.left
        let cellWidth = layout.itemSize.width + layout.minimumLineSpacing
        let index = round(scrolledOffsetX / cellWidth)
        targetContentOffset.pointee = CGPoint(x: index * cellWidth - scrollView.contentInset.left, y: scrollView.contentInset.top)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == photoCollectionView {
            let frameWidth = scrollView.frame.size.width
            let centerOffsetX = (scrollView.contentOffset.x + (frameWidth / 2)) / frameWidth
            let index = Int(centerOffsetX)
            
            let count = images.count
            
            // 새로운 사진을 추가하는 셀에 대해서는 움직이지 않도록
            if index != count {
                pageControl.currentPage = index
            }
        }
    }
}

// MARK: - Extension: EdtiPhotoCollectionViewDeleteDelegate

extension EditRecordVC: EdtiPhotoCollectionViewDeleteDelegate {
    func deletePhoto(at indexPath: IndexPath) {
        print("edit record vc에서 받음, indexPath: \(indexPath)")
        print("section 0 items: \(photoCollectionView.numberOfItems(inSection: 0))")
        images.remove(at: indexPath.item)
        pageControl.numberOfPages = images.count
        photoCollectionView.deleteItems(at: [indexPath])
        print("deleted, section 0 items: \(photoCollectionView.numberOfItems(inSection: 0))")
    }
}

// MARK: - Extension: PHPickerViewControllerDelegate

extension EditRecordVC: PHPickerViewControllerDelegate {

    /// 이미지 수행 끝났을 때
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        // cancel 눌렀을 때
        if results.isEmpty {
            picker.dismiss(animated: true)
            return
        }
        
        newlySelectedPhotos.removeAll()
        imageFiles.removeAll()
        images.removeAll {
            $0 is UIImage
        }
        print("선택된 사진의 개수: \(results.count)")
        
        // 현 상태에서 새로 등록 가능한 사진 개수
        let maxPhotoSelection = 5 - images.count
        
        for i in 0 ..< results.count {
            if i >= maxPhotoSelection {
                break
            }
            
            if results[i].itemProvider.canLoadObject(ofClass: UIImage.self) {
                results[i].itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    let image = image as! UIImage
                    let compressionedImage: Data? = image.jpegData(compressionQuality: 0.2)!
                    
                    DispatchQueue.main.async {
                        self.images.append(image)
                        self.setPageControlCount(self.images.count)
                        
                        // 컬렉션 뷰에서 위치를 0번째 사진으로 이동시키기
                        self.pageControl.currentPage = 0
                        self.photoCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0),
                                                              at: .centeredHorizontally,
                                                              animated: true)
                        self.photoCollectionView.reloadData()
                    }
                    
                    if let fileName = results[i].itemProvider.suggestedName {
                        self.imageFiles.append(ImageFile(filename: fileName,
                                                         data: compressionedImage!,
                                                         type: "jpeg"))
                        print("선택된 이미지 파일 이름: \(fileName)")
                    }
                }
            }
        }
        
        picker.dismiss(animated: true)
    }
}

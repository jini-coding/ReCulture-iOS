//
//  EditRecordVC.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 9/16/24.
//

import UIKit

protocol EditRecordDelegate: AnyObject {
    func doneEditingRecordVC()
}

final class EditRecordVC: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: EditRecordDelegate?
    
    private var recordModel: RecordModel
    
    private var selectedCategory: RecordType = .book
    
    private var menuItems: [UIAction] {
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
        button.setTitleColor(.rcGray200, for: .disabled)
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
        print(width)
        print(height)
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
    
    private let detailContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .rcGrayBg
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        return view
    }()
    
    // MARK: - Lifecycle
    
    init(recordModel: RecordModel) {
        self.recordModel = recordModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("view did load, recordModel: \(recordModel)")
        
        view.backgroundColor = .white
        
        addKeyboardObserver()
        
        setupCustomHeaderView()
        setupScrollView()
        setupContentView()
        setupTitleTextFieldAndBorderLine()
        setupDatePickerAndTextField()
        setupCategoryRangeMenuBtn()
        setupPhotoCollectionView()
        setupPageControl()
        setupDetailContainerView()
        
        configureWithData()
        
        //setPageControlCount(3)
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
        
        let menu = UIMenu(children: menuItems)
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
    
    private func setupDetailContainerView() {
        detailContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(detailContainerView)
        
        NSLayoutConstraint.activate([
            detailContainerView.leadingAnchor.constraint(equalTo: categoryRangeMenuBtn.leadingAnchor),
            detailContainerView.trailingAnchor.constraint(equalTo: categoryRangeMenuBtn.trailingAnchor),
            detailContainerView.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 30),
            detailContainerView.heightAnchor.constraint(equalToConstant: 30),
            detailContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
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
        let count = recordModel.photoDocs.count
        print("cell 개수: \(count)")
        return count == 5 ? count : count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let count = recordModel.photoDocs.count
        
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
            cell.configure(with: recordModel.photoDocs[indexPath.item].url, thisCellIndexPath: indexPath)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("=== did select item at ===")
        let count = recordModel.photoDocs.count
        
        if count != 5 && indexPath.item == count {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EditVCAddPhotoCell.identifier, for: indexPath) as? EditVCAddPhotoCell
            else { return }
            print("cell is EditVCAddPhotoCell: \(cell)")
        }
        print("cell is NOT EditVCAddPhotoCell")
    }
    
    // collectionview는 전체 화면 너비를 기준으로 페이징하기 때문에, section inset에 대해 적용되도록 하는 코드
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        print("=== scroll view will end dragging ===")
        print("targetContentOffset: \(targetContentOffset.pointee)")
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
            
            let count = recordModel.photoDocs.count
            
            // 새로운 사진을 추가하는 셀에 대해서는 움직이지 않도록
            if index != count {
                print("=== page control ===")
                print("moving to \(Int(centerOffsetX))")
                pageControl.currentPage = index
            }
        }
    }
}

// MARK: - Extension: EdtiPhotoCollectionViewDeleteDelegate

extension EditRecordVC: EdtiPhotoCollectionViewDeleteDelegate {
    func deletePhoto() {
        print("edit record vc에서 받음")
    }
}

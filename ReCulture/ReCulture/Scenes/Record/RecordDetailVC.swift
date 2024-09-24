//
//  RecordDetailVC.swift
//  ReCulture
//
//  Created by Jini on 6/14/24.
//

import UIKit

class RecordDetailVC: UIViewController {
    
    private let viewModel = RecordViewModel()
    
    var recordId: Int = 0
    var titleText: String = ""
    var creator: String = ""
    var createdAt: String = ""
    var category: String = ""
    var contentImage: [String] = []
    
    let textFieldPlaceholders: [[RecordType: [[String]]]] = [
        [.movie: [["영화 이름", "어떤 영화인가요?"],
                  ["출연진 및 감독", "출연진 및 감독을 적어주세요"],
                  ["장르", "어떤 장르의 영화인가요?"]]],
        [.musical: [["작품명", "어떤 뮤지컬인가요?"],
                    ["극장", "어디에서 보셨나요?"],
                    ["캐스팅", "출연자를 작성해주세요"]]],
        [.play: [["작품명", "어떤 연극인가요?"],
                 ["공연장", "어디에서 보셨나요?"],
                 ["캐스팅", "출연자를 작성해주세요"]]],
        [.sports: [["스포츠 종류", "어떤 스포츠인가요?"],
                   ["장소 및 상대팀", "어디에서, 누가 한 경기인가요?"],
                   ["경기 결과", "경기 결과를 입력해주세요"],
                   ["선발 라인업", "선발 라인업을 입력해주세요"]]],
        [.concert: [["공연명", "어떤 공연인가요?"],
                    ["공연장", "어디에서 한 공연인가요?"],
                    ["출연진/연주자", "출연진/연주자를 입력해주세요"],
                    ["셋리스트", "셋리스트/프로그램을 입력해주세요"]]],
        [.drama: [["제목", "어떤 드라마인가요?"],
                  ["장르", "어떤 장르의 드라마인가요?"],
                  ["출연진 및 감독/극본", "출연진, 감독, 극본을 입력해주세요"]]],
        [.book: [["책 이름", "어떤 책인가요?"],
                 ["저자", "누구의 책인가요?"],
                 ["독서 기간", "언제부터 언제까지 읽으셨나요?"],
                 ["인상깊은 구절", "인상깊은 구절을 입력해주세요"]]],
        [.exhibition: [["주제", "어떤 전시회인가요?"],
                       ["장소", "어디에서 열렸나요?"],
                       ["인상깊은 전시물", "인상깊은 전시물을 입력해주세요"]]],
        [.etc: [["내용", "무엇을 했나요?"],
                ["장소", "어디에서 했나요?"],
                ["함께한 사람들", "누구와 했나요?"]]]
    ]
    
    
    struct ContentDetail {
        var version: String
        var location: String
        var casting: String
        var comment: String
    }
    
    let contentScrollView: UIScrollView = {
        let scrollview = UIScrollView()
        scrollview.showsVerticalScrollIndicator = false
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollview
    }()
    
    let contentsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.blue
        imageView.layer.cornerRadius = 14
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.rcFont20B()
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let creatorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.rcFont14R()
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let separateLineImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "separate_line")
        imageview.translatesAutoresizingMaskIntoConstraints = false
        
        return imageview
    }()
    
    let createDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.rcFont14R()
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.rcFont14M()
        label.textColor = UIColor.rcMain
        label.backgroundColor = UIColor.rcGrayBg
        label.textAlignment = .center
        label.layer.cornerRadius = 6
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let contentImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFill
        imageview.clipsToBounds = true
        imageview.layer.cornerRadius = 8
        imageview.translatesAutoresizingMaskIntoConstraints = false
        
        
        return imageview
    }()
    
    let imageScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    let imageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    
    let detailInfoView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rcGray000
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        bind()
        viewModel.getRecordDetails(recordId: recordId)
        
        setupNavigationBar()
        setupScrollView()
        setupTitleInfo()
        setupImage()
        setupInfoView()
    }
    
    private func bind() {
        viewModel.myRecordModelDidChange = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                guard let model = self.viewModel.getRecordDetail() else { return }
                
                // Set the category based on the category ID
                let category: String
                switch model.culture.categoryId {
                case 1: category = "영화"
                case 2: category = "뮤지컬"
                case 3: category = "연극"
                case 4: category = "스포츠"
                case 5: category = "콘서트"
                case 6: category = "드라마"
                case 7: category = "독서"
                case 8: category = "전시회"
                case 9: category = "기타"
                default: category = "기타"
                }

                self.titleLabel.text = model.culture.title
                self.creatorLabel.text = "\(self.creator)"
                self.createDateLabel.text = model.culture.date.toDate()?.toString()
                self.categoryLabel.text = category
                
                self.contentImage = model.photoDocs.map { $0.url }
                self.loadImagesIntoStackView()
                
                if let recordType = RecordType(categoryId: model.culture.categoryId-1) {
                    let placeholders = self.textFieldPlaceholders.first { $0.keys.contains(recordType) }?[recordType] ?? []
                    
                    let details = [
                        model.culture.detail1,
                        model.culture.detail2,
                        model.culture.detail3,
                        model.culture.detail4
                    ]

                    self.updateInfoView(with: placeholders, and: details)
                } else {
                    print("Failed to get RecordType for categoryId: \(model.culture.categoryId)")
                }
            }
        }
    }

    
    private func updateInfoView(with titles: [[String]], and details: [String]) {
        var previousView: UIView?

        for (index, title) in titles.enumerated() {
            let titleLabel = UILabel()
            titleLabel.font = UIFont.rcFont14B()
            titleLabel.textColor = .black
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.text = title.first
            titleLabel.numberOfLines = 0

            let detailLabel = UILabel()
            detailLabel.font = UIFont.rcFont14M()
            detailLabel.textColor = .black
            detailLabel.translatesAutoresizingMaskIntoConstraints = false
            detailLabel.text = details[index].isEmpty ? "-" : details[index]
            detailLabel.lineBreakMode = .byCharWrapping
            detailLabel.numberOfLines = 0

            detailInfoView.addSubview(titleLabel)
            detailInfoView.addSubview(detailLabel)

            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: previousView?.bottomAnchor ?? detailInfoView.topAnchor, constant: 16),
                titleLabel.leadingAnchor.constraint(equalTo: detailInfoView.leadingAnchor, constant: 16),

                detailLabel.topAnchor.constraint(equalTo: previousView?.bottomAnchor ?? detailInfoView.topAnchor, constant: 16),
                detailLabel.trailingAnchor.constraint(equalTo: detailInfoView.trailingAnchor, constant: -16),
                detailLabel.widthAnchor.constraint(equalToConstant: 240)
            ])

            previousView = detailLabel
        }
        
        let reviewTitleLabel = UILabel()
        reviewTitleLabel.font = UIFont.rcFont14B()
        reviewTitleLabel.textColor = .black
        reviewTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        reviewTitleLabel.text = "간단한 후기"
        reviewTitleLabel.lineBreakMode = .byCharWrapping
        reviewTitleLabel.numberOfLines = 0

        let reviewDetailLabel = UILabel()
        reviewDetailLabel.font = UIFont.rcFont14M()
        reviewDetailLabel.textColor = .black
        reviewDetailLabel.translatesAutoresizingMaskIntoConstraints = false
        reviewDetailLabel.text = viewModel.getRecordDetail()?.culture.review ?? ""
        reviewDetailLabel.lineBreakMode = .byCharWrapping
        reviewDetailLabel.numberOfLines = 0

        detailInfoView.addSubview(reviewTitleLabel)
        detailInfoView.addSubview(reviewDetailLabel)
        
        NSLayoutConstraint.activate([
            reviewTitleLabel.topAnchor.constraint(equalTo: previousView?.bottomAnchor ?? detailInfoView.topAnchor, constant: 16),
            reviewTitleLabel.leadingAnchor.constraint(equalTo: detailInfoView.leadingAnchor, constant: 16),
            reviewTitleLabel.trailingAnchor.constraint(equalTo: reviewDetailLabel.leadingAnchor, constant: -16),

            reviewDetailLabel.topAnchor.constraint(equalTo: previousView?.bottomAnchor ?? detailInfoView.topAnchor, constant: 16),
            reviewDetailLabel.trailingAnchor.constraint(equalTo: detailInfoView.trailingAnchor, constant: -16),
            reviewDetailLabel.widthAnchor.constraint(equalToConstant: 240),
        ])
        
        // Add emoji summary at the end
        let emojiTitleLabel = UILabel()
        emojiTitleLabel.font = UIFont.rcFont14B()
        emojiTitleLabel.textColor = .black
        emojiTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiTitleLabel.text = "이모지 총평"
        emojiTitleLabel.lineBreakMode = .byCharWrapping
        emojiTitleLabel.numberOfLines = 0

        let emojiDetailLabel = UILabel()
        emojiDetailLabel.font = UIFont.rcFont14M()
        emojiDetailLabel.textColor = .black
        emojiDetailLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiDetailLabel.text = viewModel.getRecordDetail()?.culture.emoji ?? ""
        emojiDetailLabel.lineBreakMode = .byCharWrapping
        emojiDetailLabel.numberOfLines = 0

        detailInfoView.addSubview(emojiTitleLabel)
        detailInfoView.addSubview(emojiDetailLabel)
        
        NSLayoutConstraint.activate([
            emojiTitleLabel.topAnchor.constraint(equalTo: reviewDetailLabel.bottomAnchor, constant: 16),
            emojiTitleLabel.leadingAnchor.constraint(equalTo: detailInfoView.leadingAnchor, constant: 16),
            emojiTitleLabel.trailingAnchor.constraint(equalTo: emojiDetailLabel.leadingAnchor, constant: -16),

            emojiDetailLabel.topAnchor.constraint(equalTo: reviewDetailLabel.bottomAnchor, constant: 16),
            emojiDetailLabel.trailingAnchor.constraint(equalTo: detailInfoView.trailingAnchor, constant: -16),
            emojiDetailLabel.widthAnchor.constraint(equalToConstant: 240),
            emojiDetailLabel.bottomAnchor.constraint(equalTo: detailInfoView.bottomAnchor, constant: -16)
        ])

    }
    
    func setupNavigationBar() {
        self.navigationItem.title = "나의 기록"
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.rcFont18B()
        ]
        
        // Create a button with UIButton.Configuration
        var buttonConfig = UIButton.Configuration.plain()
        buttonConfig.image = UIImage(systemName: "ellipsis")
        buttonConfig.imagePadding = 5
        buttonConfig.baseForegroundColor = UIColor.black
        buttonConfig.buttonSize = .medium
        
        let moreButton = UIButton(configuration: buttonConfig)
        
        let editAction = UIAction(title: "수정하기", attributes: .init()) { _ in
            self.editRecord()
        }
        
        let deleteAction = UIAction(title: "삭제하기", attributes: .destructive) { _ in
            self.deleteRecord()
        }
        
        // Create the UIMenu and assign it to the button
        let menu = UIMenu(title: "", children: [editAction, deleteAction])
        moreButton.menu = menu
        moreButton.showsMenuAsPrimaryAction = true  // Shows the menu when the button is tapped
        
        // Assign the button to the navigation bar as a UIBarButtonItem
        let moreBarButtonItem = UIBarButtonItem(customView: moreButton)
        self.navigationItem.rightBarButtonItem = moreBarButtonItem
        
        /* 홈에서 상세를 보여줄 때 내비게이션 바 appearance가 home 그대로 적용되어 보라색으로 보이는 문제 해결 */
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .white
        appearance.shadowImage = UIImage()
        
        let backbutton = UIBarButtonItem(image: UIImage.btnArrowBig.withRenderingMode(.alwaysOriginal).resizeImage(size: CGSize(width: 36, height: 36)),
                                         style: .done,
                                         target: self,
                                         action: #selector(goBack))
        backbutton.tintColor = .black
        self.navigationItem.leftBarButtonItem = backbutton
        
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
//        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func editRecord() {
        let editRecordVC = EditRecordVC(recordModel: viewModel.getRecordDetail()!)
        editRecordVC.modalPresentationStyle = .fullScreen
        editRecordVC.modalTransitionStyle = .coverVertical
        editRecordVC.delegate = self
        self.present(editRecordVC, animated: true)
    }
    
    @objc func deleteRecord() {
        let alertController = UIAlertController(title: "삭제하시겠습니까?", message: "삭제한 기록은 복구할 수 없어요", preferredStyle: .alert)
             
        let confirmAction = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.deleteRecord(postId: self.recordId)
            print("\(self.recordId)번 기록 삭제 완료됨")
                 
            self.navigationController?.popViewController(animated: true)
        }
             
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)

        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true)
             
//        self.viewModel.deleteRecord(postId: recordId)
//        print("\(recordId)번 기록 삭제 완료됨")
//        //이전 페이지로 이동
//        navigationController?.popViewController(animated: true)
    }
    
    func setupScrollView() {
        view.addSubview(contentScrollView)
        contentScrollView.addSubview(contentsView)
        
        NSLayoutConstraint.activate([
            contentScrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            contentScrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            contentScrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            contentScrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            
            contentsView.topAnchor.constraint(equalTo: contentScrollView.topAnchor),
            contentsView.leadingAnchor.constraint(equalTo: contentScrollView.leadingAnchor),
            contentsView.trailingAnchor.constraint(equalTo: contentScrollView.trailingAnchor),
            contentsView.bottomAnchor.constraint(equalTo: contentScrollView.bottomAnchor),
            contentsView.widthAnchor.constraint(equalTo: contentScrollView.widthAnchor),
            //contentsView.heightAnchor.constraint(equalToConstant: 850)
        ])
        
        view.layoutIfNeeded()
        contentScrollView.contentSize = contentsView.bounds.size
    }
    
    func setupTitleInfo() {
        titleLabel.text = titleText
        creatorLabel.text = creator
        createDateLabel.text = createdAt
        categoryLabel.text = category
        
        contentsView.addSubview(titleLabel)
        contentsView.addSubview(creatorLabel)
        contentsView.addSubview(separateLineImageView)
        contentsView.addSubview(createDateLabel)
        contentsView.addSubview(categoryLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentsView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentsView.leadingAnchor, constant: 16),
            titleLabel.heightAnchor.constraint(equalToConstant: 30),
            
            creatorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            creatorLabel.leadingAnchor.constraint(equalTo: contentsView.leadingAnchor, constant: 16),
            creatorLabel.heightAnchor.constraint(equalToConstant: 14),
            
            separateLineImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            separateLineImageView.leadingAnchor.constraint(equalTo: creatorLabel.trailingAnchor, constant: 8),
            separateLineImageView.heightAnchor.constraint(equalToConstant: 12),
            separateLineImageView.widthAnchor.constraint(equalToConstant: 1),
            
            createDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            createDateLabel.leadingAnchor.constraint(equalTo: separateLineImageView.trailingAnchor, constant: 8),
            createDateLabel.heightAnchor.constraint(equalToConstant: 14),
            
            categoryLabel.topAnchor.constraint(equalTo: creatorLabel.bottomAnchor, constant: 12),
            categoryLabel.leadingAnchor.constraint(equalTo: contentsView.leadingAnchor, constant: 16),
            categoryLabel.heightAnchor.constraint(equalToConstant: 22),
            categoryLabel.widthAnchor.constraint(equalToConstant: 49)
        ])
        
    }
    
//    func setupImage() {
//        if let imageUrl = contentImage.first {
//            let baseUrl = "http://34.64.120.187:8080"
//            let imageUrlStr = "\(baseUrl)\(imageUrl)"
//            imageUrlStr.loadAsyncImage(contentImageView)
//        }
//        
//        contentsView.addSubview(contentImageView)
//        
//        NSLayoutConstraint.activate([
//            contentImageView.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 20),
//            contentImageView.leadingAnchor.constraint(equalTo: contentsView.leadingAnchor, constant: 16),
//            contentImageView.trailingAnchor.constraint(equalTo: contentsView.trailingAnchor, constant: -16),
//            contentImageView.heightAnchor.constraint(equalToConstant: 420)
//        ])
//    }
    
    func setupImage() {
        contentsView.addSubview(imageScrollView)
        imageScrollView.addSubview(imageStackView)

        NSLayoutConstraint.activate([
            imageScrollView.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 20),
            imageScrollView.leadingAnchor.constraint(equalTo: contentsView.leadingAnchor, constant: 26),
            imageScrollView.trailingAnchor.constraint(equalTo: contentsView.trailingAnchor, constant: -26),
            imageScrollView.heightAnchor.constraint(equalToConstant: 420),

            imageStackView.topAnchor.constraint(equalTo: imageScrollView.topAnchor),
            imageStackView.leadingAnchor.constraint(equalTo: imageScrollView.leadingAnchor),
            imageStackView.trailingAnchor.constraint(equalTo: imageScrollView.trailingAnchor),
            imageStackView.bottomAnchor.constraint(equalTo: imageScrollView.bottomAnchor),
            imageStackView.heightAnchor.constraint(equalTo: imageScrollView.heightAnchor)
        ])
        
        loadImagesIntoStackView()
    }

    
    func loadImagesIntoStackView() {
        for subview in imageStackView.arrangedSubviews {
            subview.removeFromSuperview()
        }

        for imageUrlStr in contentImage {
            let baseUrl = "http://34.64.120.187:8080"
            let imageUrl = "\(baseUrl)\(imageUrlStr)"
            
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 8
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.backgroundColor = UIColor.lightGray
            
            imageUrl.loadAsyncImage(imageView)
            
            imageStackView.addArrangedSubview(imageView)
            
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: 320),
                imageView.heightAnchor.constraint(equalToConstant: 420)
            ])
        }
        
        imageScrollView.contentSize = CGSize(width: 320 * contentImage.count, height: 420)
    }
    
    //여기 미완...
    func setupInfoView() {
        
        contentsView.addSubview(detailInfoView)
        
        NSLayoutConstraint.activate([
            detailInfoView.topAnchor.constraint(equalTo: imageScrollView.bottomAnchor, constant: 20),
            detailInfoView.leadingAnchor.constraint(equalTo: contentsView.leadingAnchor, constant: 16),
            detailInfoView.trailingAnchor.constraint(equalTo: contentsView.trailingAnchor, constant: -16),
            detailInfoView.bottomAnchor.constraint(equalTo: contentsView.bottomAnchor, constant: -20)
        ])
//
//        let titles = [""]
//        let details = [""]
//
//        var previousView: UIView?
//        for index in 0..<titles.count {
//            let titleLabel = UILabel()
//            titleLabel.font = UIFont.rcFont14B()
//            titleLabel.textColor = .black
//            titleLabel.translatesAutoresizingMaskIntoConstraints = false
//
//            let detailLabel = UILabel()
//            detailLabel.font = UIFont.rcFont14M()
//            detailLabel.textColor = .black
//            detailLabel.translatesAutoresizingMaskIntoConstraints = false
//            detailLabel.numberOfLines = 0
//
//            detailInfoView.addSubview(titleLabel)
//            detailInfoView.addSubview(detailLabel)
//
//            NSLayoutConstraint.activate([
//                titleLabel.topAnchor.constraint(equalTo: previousView?.bottomAnchor ?? detailInfoView.topAnchor, constant: 16),
//                titleLabel.leadingAnchor.constraint(equalTo: detailInfoView.leadingAnchor, constant: 16),
//
//                detailLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor),
//                detailLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 15),
//                detailLabel.trailingAnchor.constraint(equalTo: detailInfoView.trailingAnchor, constant: -16)
//            ])
//
//            previousView = titleLabel
    }
}

// MARK: - Extension: UIGestureRecognizer

extension RecordDetailVC: UIGestureRecognizerDelegate {}

// MARK: - Extension: EditRecordDelegate (수정 페이지에서 delegate - 수정 취소 혹은 완료)

extension RecordDetailVC: EditRecordDelegate {
    
    func doneEditingRecordVC() {
        print("=== record Detail VC ===")
        print("수정 완료~")
        viewModel.getRecordDetails(recordId: recordId)
    }
}

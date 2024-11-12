//
//  RecordVC.swift
//  ReCulture
//
//  Created by Jini on 5/3/24.
//

import UIKit

class RecordVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let viewModel = RecordViewModel()
    private let myviewModel = MypageViewModel()
    
    struct RecordContent {
        var title: String
        var name: String
        var id: String
        var createdAt: String
        var category: String
        var profileImage: String
        var comment: String
        var contentImages: [String]
    }
    
    var selectedCategory: String = "전체"
    
    /// refresh control
    let refreshControl = UIRefreshControl()
    
    let biglabel: UILabel = {
        let label = UILabel()
        label.text = "내 기록"
        label.textColor = UIColor.white
        label.font = UIFont.rcFont24B()
        
        return label
    }()
    
    let ticketButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.ticketBook, for: .normal)
        button.addTarget(self, action: #selector(goToTicketBook), for: .touchUpInside)
        return button
    }()
    
    let contentsView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        
        return view
    }()
    
    let categoryView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        
        return view
    }()
    
    let categoryScrollView: UIScrollView = {
        let scrollview = UIScrollView()
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        scrollview.showsHorizontalScrollIndicator = false
        
        return scrollview
    }()
    
    let contentTableView: UITableView = {
        let tableview = UITableView()
        tableview.separatorStyle = .singleLine
        tableview.showsVerticalScrollIndicator = false
        
        return tableview
    }()
    
    let emptyView: UIView = {
        let view = UIView()
        let label = UILabel()
        
        label.text = "아직 작성한 기록이 없어요"
        label.textColor = UIColor.rcGray300
        label.font = UIFont.rcFont16M()
        label.textAlignment = .center

        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        view.isHidden = true
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        
        view.backgroundColor = UIColor.rcMain
        
        bind()
        viewModel.getmyRecords(fromCurrentVC: self)
        myviewModel.getMyInfo(fromCurrentVC: self)
        
        setupHeaderView()
        setupContentView()
        
        contentTableView.register(RecordContentCell.self, forCellReuseIdentifier: RecordContentCell.cellId)
        
        contentTableView.delegate = self
        contentTableView.dataSource = self
        
        contentTableView.rowHeight = UITableView.automaticDimension
        contentTableView.estimatedRowHeight = 390
        
        setupEmptyView()
        
        /// refresh 추가하게 되면 밑에 주석 해제
        /// RefreshControl 세팅
        refreshControl.addTarget(self, action: #selector(refreshControlDidChange), for: .valueChanged)
        refreshControl.tintColor = .rcLightPurple
        contentTableView.refreshControl = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 네비게이션 바 숨김 설정
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
            
        // 다른 뷰로 이동할 때 네비게이션 바 보이도록 설정
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func bind() {
        viewModel.allRecordModelDidChange = { [weak self] in
             DispatchQueue.main.async {
                 self?.updateEmptyView()
                 self?.contentTableView.reloadData()
             }
        }
    }
    
    private func updateEmptyView() {
        let hasData = viewModel.recordCount() > 0
        emptyView.isHidden = hasData
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.recordCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecordContentCell.cellId, for: indexPath) as! RecordContentCell
        cell.selectionStyle = .none
        
        let model = viewModel.getRecord(at: indexPath.row)
        
        cell.titleLabel.text = model.culture.title
        cell.nameLabel.text = "\(myviewModel.getNickname())"
        
        cell.profileImageView.loadImage(urlWithoutBaseURL: myviewModel.getProfileImage())
        
        cell.createDateLabel.text = model.culture.date.toDate()?.toString()
        cell.commentLabel.text = model.culture.review
        
        let imageUrls = model.photoDocs.map { "\($0.url)" }
        cell.configureImages(imageUrls)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = viewModel.getRecord(at: indexPath.row)

        // 이동할 뷰 컨트롤러 초기화
        let vc = RecordDetailVC()

        // 선택된 데이터를 디테일 뷰 컨트롤러에 전달
        vc.recordId = model.culture.id
        vc.titleText = model.culture.title
        vc.creator = "\(myviewModel.getNickname())"
        vc.profileImageView.loadImage(urlWithoutBaseURL: myviewModel.getProfileImage())
//        vc.createdAt = model.culture.date.toDate()?.toString() ?? model.culture.date
//        //vc.category = "\(model.culture.categoryId)"
//        vc.contentImage = model.photoDocs.map { $0.url }

        // 뷰 컨트롤러 표시
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    

    @objc func goToTicketBook(){
        let vc = TicketBookVC()
        
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /// refresh control 추가 시 여기에 액션 정의 (ex. 페이지 넘버 초기화 등)
    @objc private func refreshControlDidChange() {
        viewModel.getmyRecords(fromCurrentVC: self)

        refreshControl.endRefreshing()
    }
    
    func setupHeaderView() {
        biglabel.translatesAutoresizingMaskIntoConstraints = false
        ticketButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(biglabel)
        view.addSubview(ticketButton)
        
        NSLayoutConstraint.activate([
            biglabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8),
            biglabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            biglabel.heightAnchor.constraint(equalToConstant: 34),
            
            ticketButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8),
            ticketButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -14),
            ticketButton.heightAnchor.constraint(equalToConstant: 34),
            ticketButton.widthAnchor.constraint(equalToConstant: 34)
            
        ])
    }
    
    func setupContentView() {
        contentsView.translatesAutoresizingMaskIntoConstraints = false
        categoryView.translatesAutoresizingMaskIntoConstraints = false
        contentTableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(contentsView)
        contentsView.addSubview(categoryView)
        contentsView.addSubview(contentTableView)
        
        NSLayoutConstraint.activate([
            contentsView.topAnchor.constraint(equalTo: biglabel.bottomAnchor, constant: 8),
            contentsView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            contentsView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            contentsView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            
            categoryView.topAnchor.constraint(equalTo: contentsView.topAnchor),
            categoryView.leadingAnchor.constraint(equalTo: contentsView.leadingAnchor),
            categoryView.trailingAnchor.constraint(equalTo: contentsView.trailingAnchor),
            categoryView.heightAnchor.constraint(equalToConstant: 60),
            
            contentTableView.topAnchor.constraint(equalTo: categoryView.bottomAnchor, constant: 0),
            contentTableView.leadingAnchor.constraint(equalTo: contentsView.leadingAnchor),
            contentTableView.trailingAnchor.constraint(equalTo: contentsView.trailingAnchor, constant: -16),
            contentTableView.bottomAnchor.constraint(equalTo: contentsView.bottomAnchor)
        ])
        
        setupCategoryButtons()

    }
    
    private func setupEmptyView() {
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyView)
        
        NSLayoutConstraint.activate([
            emptyView.topAnchor.constraint(equalTo: contentTableView.topAnchor),
            emptyView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            emptyView.bottomAnchor.constraint(equalTo: contentTableView.bottomAnchor)
        ])
    }
    
    func setupCategoryButtons() {

        categoryView.addSubview(categoryScrollView)
        
        NSLayoutConstraint.activate([
            categoryScrollView.topAnchor.constraint(equalTo: categoryView.topAnchor),
            categoryScrollView.leadingAnchor.constraint(equalTo: categoryView.leadingAnchor),
            categoryScrollView.trailingAnchor.constraint(equalTo: categoryView.trailingAnchor),
            categoryScrollView.bottomAnchor.constraint(equalTo: categoryView.bottomAnchor)
        ])
        
        // Define categories
        let categories = ["전체", "뮤지컬", "전시회", "콘서트", "스포츠", "영화", "독서", "기타"]
        
        var previousButton: UIButton?

        for category in categories {
            
            let button = UIButton(type: .system)
            button.setTitle(category, for: .normal)
            button.backgroundColor = category == selectedCategory ? UIColor.rcMain : UIColor.rcGray000
            button.setTitleColor(category == selectedCategory ? .white : .rcMain, for: .normal)
            button.layer.cornerRadius = 15
            button.clipsToBounds = true
            button.translatesAutoresizingMaskIntoConstraints = false

            categoryScrollView.addSubview(button)

            NSLayoutConstraint.activate([
                button.centerYAnchor.constraint(equalTo: categoryView.centerYAnchor),
                button.widthAnchor.constraint(equalToConstant: 65),
                button.heightAnchor.constraint(equalToConstant: 31)
            ])
            
            if let previousButton = previousButton {
                NSLayoutConstraint.activate([
                    button.leadingAnchor.constraint(equalTo: previousButton.trailingAnchor, constant: 8)
                ])
            } else {
                NSLayoutConstraint.activate([
                    button.leadingAnchor.constraint(equalTo: categoryScrollView.leadingAnchor, constant: 16)
                ])
            }

            previousButton = button

            button.addTarget(self, action: #selector(categoryButtonTapped(_:)), for: .touchUpInside)
            
        }

        if let lastButton = previousButton {
            NSLayoutConstraint.activate([
                lastButton.trailingAnchor.constraint(equalTo: categoryScrollView.trailingAnchor, constant: -16)
            ])
        }
    }
    
    @objc func categoryButtonTapped(_ sender: UIButton) {
        if let selectedCategory = sender.currentTitle {
            self.selectedCategory = selectedCategory
            updateCategoryButtonAppearance()
            print("\(selectedCategory) 버튼 선택됨")
            viewModel.filterRecords(by: selectedCategory)
        }
    }

    func updateCategoryButtonAppearance() {
        
        for case let button as UIButton in categoryScrollView.subviews {
            if let category = button.currentTitle {
                button.backgroundColor = category == selectedCategory ? UIColor.rcMain : UIColor.rcGray000
                button.setTitleColor(category == selectedCategory ? .white : .rcMain, for: .normal)
            }
        }
    }
}

class RecordContentCell: UITableViewCell {
    
    static let cellId = "CellId"
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.lightGray
        imageView.layer.cornerRadius = 14
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.rcFont16B()
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.rcFont14B()
        label.textColor = UIColor.rcGray800
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
        label.font = UIFont.rcFont12M()
        label.textColor = UIColor.rcGray500
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let commentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.rcFont14M()
        label.textColor = UIColor.rcGray800
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        return label
    }()
    
//    let categoryLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.rcFont14M()
//        label.textColor = UIColor.rcMain
//        label.backgroundColor = UIColor.rcGrayBg
//        label.textAlignment = .center
//        label.layer.cornerRadius = 6
//        label.clipsToBounds = true
//        label.translatesAutoresizingMaskIntoConstraints = false
//
//        return label
//    }()
    
    let contentImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFill
        imageview.clipsToBounds = true
        imageview.layer.cornerRadius = 6
        imageview.translatesAutoresizingMaskIntoConstraints = false
        
        
        return imageview
    }()
    
    let imageScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .clear
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

    
    let imageContentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rcMain
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(separateLineImageView)
        //contentView.addSubview(idLabel)
        contentView.addSubview(createDateLabel)
        contentView.addSubview(commentLabel)
        //contentView.addSubview(categoryLabel)
        //contentView.addSubview(contentImageView)
        
        contentView.addSubview(imageScrollView)
        imageScrollView.addSubview(imageStackView)

        imageScrollView.contentSize = CGSize(width: 940, height: 210)
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            profileImageView.heightAnchor.constraint(equalToConstant: 28),
            profileImageView.widthAnchor.constraint(equalToConstant: 28),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12),
            nameLabel.heightAnchor.constraint(equalToConstant: 18),
            
            separateLineImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 22),
            separateLineImageView.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 8),
            separateLineImageView.heightAnchor.constraint(equalToConstant: 12),
            separateLineImageView.widthAnchor.constraint(equalToConstant: 1),
            
            //idLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
//            idLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 21),
//            idLabel.leadingAnchor.constraint(equalTo: separateLineImageView.trailingAnchor, constant: 8),
//            idLabel.heightAnchor.constraint(equalToConstant: 15),
            
            createDateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 21),
            createDateLabel.leadingAnchor.constraint(equalTo: separateLineImageView.trailingAnchor, constant: 8),
            createDateLabel.heightAnchor.constraint(equalToConstant: 15),
            
//            createDateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
//            createDateLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12),
//            createDateLabel.heightAnchor.constraint(equalToConstant: 15),
            
            titleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            commentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            commentLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12),
            commentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            imageScrollView.topAnchor.constraint(equalTo: commentLabel.bottomAnchor, constant: 16),
            imageScrollView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12),
            imageScrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            imageScrollView.heightAnchor.constraint(equalToConstant: 210),
            imageScrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),

            imageStackView.topAnchor.constraint(equalTo: imageScrollView.topAnchor),
            imageStackView.leadingAnchor.constraint(equalTo: imageScrollView.leadingAnchor),
            imageStackView.trailingAnchor.constraint(equalTo: imageScrollView.trailingAnchor),
            imageStackView.bottomAnchor.constraint(equalTo: imageScrollView.bottomAnchor)
        ])
            
    }
    
    func configureImages(_ images: [String]) {
        // Clear previous images
        for subview in imageStackView.arrangedSubviews {
            subview.removeFromSuperview()
        }
        
        for imageUrlStr in images {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 8
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.backgroundColor = UIColor.lightGray

            //imageUrlStr.loadAsyncImage(imageView)
            imageView.loadImage(urlWithoutBaseURL: imageUrlStr)

            imageStackView.addArrangedSubview(imageView)

            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: 180),
                imageView.heightAnchor.constraint(equalToConstant: 210)
            ])
        }
    }
    
}

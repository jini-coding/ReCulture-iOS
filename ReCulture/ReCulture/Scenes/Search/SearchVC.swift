//
//  SearchVC.swift
//  ReCulture
//
//  Created by Jini on 5/3/24.
//

import UIKit

class SearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let viewModel = SearchViewModel()

    struct SearchContent {
        var title: String
        var creator: String
        var createdAt: String
        var category: String
        var profileImage: String
        var contentImages: [String]
    }
    
    var selectedCategory: String = "전체"
    var isFetching = false //페이지네이션 로딩 상태
    
    let searchTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "검색어를 입력해주세요"
        textfield.textColor = UIColor.black
        textfield.font = UIFont.rcFont16M()
        textfield.backgroundColor = UIColor.white
        textfield.layer.cornerRadius = 12
        textfield.layer.masksToBounds = true
        
        return textfield
    }()
    
    let bookmarkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "bookmarkIcon"), for: .normal)
        button.addTarget(self, action: #selector(goToBookMark), for: .touchUpInside)
        
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


    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        
        view.backgroundColor = UIColor.rcMain
        
        setupSearchField()
        setupBookmarkButton()
        setupContentView()
        
        contentTableView.register(SearchContentCell.self, forCellReuseIdentifier: SearchContentCell.cellId)
        
        contentTableView.delegate = self
        contentTableView.dataSource = self
        
        
        bind()
        viewModel.getAllRecords(fromCurrentVC: self)

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
        viewModel.allSearchModelsDidChange = { [weak self] in
             DispatchQueue.main.async {
                 self?.contentTableView.reloadData()
             }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.recordCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchContentCell.cellId, for: indexPath) as? SearchContentCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            
            let model = viewModel.getRecord(at: indexPath.row)
            
            let authorId = model.authorId
            
        if let userProfile = viewModel.getUserProfileModel(for: authorId!) {
                cell.creatorLabel.text = userProfile.nickname
                if let profileImageUrl = userProfile.profilePhoto {
                    let imageUrlStr = "http://34.64.120.187:8080\(profileImageUrl)"
                    imageUrlStr.loadAsyncImage(cell.profileImageView)
                }
            } else {
                // Fetch user profile if not loaded yet
                viewModel.getUserProfile(userId: authorId!) { userProfile in
                    DispatchQueue.main.async {
                        cell.creatorLabel.text = userProfile?.nickname
                        if let profileImageUrl = userProfile?.profilePhoto {
                            let imageUrlStr = "http://34.64.120.187:8080\(profileImageUrl)"
                            imageUrlStr.loadAsyncImage(cell.profileImageView)
                        }
                    }
                }
            }
        
            cell.titleLabel.text = model.title

        if let date = model.date!.toDate() {
                cell.createDateLabel.text = date.toString()
            } else {
                cell.createDateLabel.text = model.date
            }
            
            let category: String
            switch model.categoryId {
            case 1:
                category = "영화"
            case 2:
                category = "뮤지컬"
            case 3:
                category = "연극"
            case 4:
                category = "스포츠"
            case 5:
                category = "콘서트"
            case 6:
                category = "드라마"
            case 7:
                category = "독서"
            case 8:
                category = "전시회"
            case 9:
                category = "기타"
            default:
                category = "기타"
            }
            cell.categoryLabel.text = category
            
        if let firstPhotoDoc = model.photos?.first {
                let baseUrl = "http://34.64.120.187:8080"
                let imageUrlStr = "\(baseUrl)\(firstPhotoDoc.url)"
                imageUrlStr.loadAsyncImage(cell.contentImageView)
            }
            
            return cell
        }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return tempData.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let data = tempData[indexPath.row]
//         
//        let cell = tableView.dequeueReusableCell(withIdentifier: SearchContentCell.cellId, for: indexPath) as! SearchContentCell
//        cell.selectionStyle = .none
//         // Assuming you have images added in assets
//        cell.profileImageView.image = UIImage(named: data.profileImage)
//        cell.titleLabel.text = data.title
//        cell.creatorLabel.text = data.creator
//        cell.createDateLabel.text = data.createdAt
//        cell.categoryLabel.text = data.category
//         // Assuming the first image for contentImages
//        if let contentImage = data.contentImages.first {
//            cell.contentImageView.image = UIImage(named: contentImage)
//        }
//        
//        return cell
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = viewModel.getRecord(at: indexPath.row)
        let authorId = model.authorId!
        
        let userProfile = viewModel.getUserProfileModel(for: authorId)
        let vc = SearchRecordDetailVC()

        vc.recordId = model.id!
        vc.titleText = model.title!
        vc.creator = userProfile?.nickname ?? "Unknown"
        vc.createdAt = model.date?.toDate()?.toString() ?? model.date!
        
        // Safely unwrap the 'photos' array and map 'url' strings
        if let photos = model.photos {
            vc.contentImage = photos.compactMap { $0.url }  // compactMap will remove any nil values
        } else {
            vc.contentImage = []
        }

        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        if position > (contentHeight - frameHeight - 100) && !isFetching {
            if viewModel.canLoadMorePages() {
                isFetching = true
                viewModel.getAllRecords(fromCurrentVC: self)
                isFetching = false
            }
        }
    }
    
    func setupSearchField() {
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        
        let attributedPlaceholder = NSAttributedString(string: "검색어를 입력해주세요", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.rcGray300,
            NSAttributedString.Key.font: UIFont.rcFont16M(),
            NSAttributedString.Key.baselineOffset: -1.0
        ])
        searchTextField.attributedPlaceholder = attributedPlaceholder
        
        let searchIconImageView = UIImageView(frame: CGRect(x: 10, y: 8, width: 21, height: 21))
        if let image = UIImage(named: "Search_icon")?.resizeImage(size: CGSize(width: 21, height: 21)) {
            searchIconImageView.image = image.withRenderingMode(.alwaysTemplate)
            searchIconImageView.tintColor = UIColor(hexCode: "#6B6D83")
        }
        searchIconImageView.contentMode = .center
        
        let imageContainerView: UIView = UIView(frame: CGRect(x: 20, y: 0, width: 37, height: 37))
        imageContainerView.addSubview(searchIconImageView)
        // Set the left view of the text field to the search icon image view
        searchTextField.leftView = imageContainerView
        searchTextField.leftViewMode = .always
        
        view.addSubview(searchTextField)
        
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8),
            searchTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            searchTextField.heightAnchor.constraint(equalToConstant: 44),
            searchTextField.widthAnchor.constraint(equalToConstant: 321)
        ])
    }
    
    func setupBookmarkButton() {
        bookmarkButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(bookmarkButton)
        
        NSLayoutConstraint.activate([
            bookmarkButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 19),
            bookmarkButton.leadingAnchor.constraint(equalTo: searchTextField.trailingAnchor, constant: 16),
            bookmarkButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -21),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 24),
            bookmarkButton.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    @objc func goToBookMark() {
        let vc = BookmarkListVC()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func setupContentView() {
        contentsView.translatesAutoresizingMaskIntoConstraints = false
        categoryView.translatesAutoresizingMaskIntoConstraints = false
        contentTableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(contentsView)
        contentsView.addSubview(categoryView)
        contentsView.addSubview(contentTableView)
        
        NSLayoutConstraint.activate([
            contentsView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 8),
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
    
    func setupCategoryButtons() {

        categoryView.addSubview(categoryScrollView)
        
        NSLayoutConstraint.activate([
            categoryScrollView.topAnchor.constraint(equalTo: categoryView.topAnchor),
            categoryScrollView.leadingAnchor.constraint(equalTo: categoryView.leadingAnchor),
            categoryScrollView.trailingAnchor.constraint(equalTo: categoryView.trailingAnchor),
            categoryScrollView.bottomAnchor.constraint(equalTo: categoryView.bottomAnchor)
        ])
        
        // Define categories
        let categories = ["전체", "영화", "뮤지컬", "연극", "스포츠", "콘서트", "드라마", "독서", "전시회", "기타"]
        
        var previousButton: UIButton?

        for category in categories {
            // Create button
            let button = UIButton(type: .system)
            button.setTitle(category, for: .normal)
            button.backgroundColor = category == selectedCategory ? UIColor.rcMain : UIColor.rcGray000
            button.setTitleColor(category == selectedCategory ? .white : .rcMain, for: .normal)
            button.layer.cornerRadius = 15
            button.clipsToBounds = true
            button.translatesAutoresizingMaskIntoConstraints = false

            // Add button to scrollView
            categoryScrollView.addSubview(button)

            // Set button constraints
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

        // Set content size of scrollView based on buttons
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
            viewModel.filterRecords(by: selectedCategory)
        }
    }

    func updateCategoryButtonAppearance() {
        // Iterate through scrollView's subviews to update buttons
        for case let button as UIButton in categoryScrollView.subviews {
            if let category = button.currentTitle {
                button.backgroundColor = category == selectedCategory ? UIColor.rcMain : UIColor.rcGray000
                button.setTitleColor(category == selectedCategory ? .white : .rcMain, for: .normal)
            }
        }
    }

}

class SearchContentCell: UITableViewCell {
    
    static let cellId = "CellId"
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.rcGray300
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
    
    let creatorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.rcFont14M()
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
        label.font = UIFont.rcFont14M()
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
        imageview.layer.cornerRadius = 6
        imageview.translatesAutoresizingMaskIntoConstraints = false
        
        
        return imageview
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
        contentView.addSubview(creatorLabel)
        contentView.addSubview(separateLineImageView)
        contentView.addSubview(createDateLabel)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(contentImageView)

        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            profileImageView.heightAnchor.constraint(equalToConstant: 28),
            profileImageView.widthAnchor.constraint(equalToConstant: 28),
            
            titleLabel.topAnchor.constraint(equalTo: creatorLabel.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12),
            titleLabel.heightAnchor.constraint(equalToConstant: 44),
            titleLabel.widthAnchor.constraint(equalToConstant: 160),
            
            creatorLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            creatorLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12),
            creatorLabel.heightAnchor.constraint(equalToConstant: 14),
            
            separateLineImageView.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            separateLineImageView.leadingAnchor.constraint(equalTo: creatorLabel.trailingAnchor, constant: 8),
            separateLineImageView.heightAnchor.constraint(equalToConstant: 12),
            separateLineImageView.widthAnchor.constraint(equalToConstant: 1),
            
            createDateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            createDateLabel.leadingAnchor.constraint(equalTo: separateLineImageView.trailingAnchor, constant: 8),
            createDateLabel.heightAnchor.constraint(equalToConstant: 14),
            
            categoryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            categoryLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8),
            categoryLabel.heightAnchor.constraint(equalToConstant: 22),
            categoryLabel.widthAnchor.constraint(equalToConstant: 49),
            
            contentImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
            contentImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            contentImageView.heightAnchor.constraint(equalToConstant: 78),
            contentImageView.widthAnchor.constraint(equalToConstant: 78)
            
        ])
        
    }
    
    
}


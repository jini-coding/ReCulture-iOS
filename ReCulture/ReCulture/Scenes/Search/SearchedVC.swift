//
//  SearchedVC.swift
//  ReCulture
//
//  Created by Jini on 8/3/24.
//

import UIKit

class SearchedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    private let viewModel = SearchViewModel()
    private let userViewModel = MypageViewModel()

    var selectedCategory: String = "전체"
    private var isFetching = false // 페이지네이션 로딩 상태
    var searchText: String?
    
    let underLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rcMain
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var leadingDistance: NSLayoutConstraint = {
      return underLineView.leadingAnchor.constraint(equalTo: segmentedControl.leadingAnchor)
    }()
    
    let contentsView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
    
    let segmentedControl = UISegmentedControl(items: ["기록", "유저"])
    
    let categoryScrollView: UIScrollView = {
        let scrollview = UIScrollView()
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        scrollview.showsHorizontalScrollIndicator = false
        return scrollview
    }()
    
    let categoryView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    
    let recordTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .singleLine
        tableView.showsVerticalScrollIndicator = false
        tableView.isHidden = false
        return tableView
    }()
    
    let userTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .singleLine
        tableView.showsVerticalScrollIndicator = false
        tableView.isHidden = true
        return tableView
    }()
    
    let emptyView: UIView = {
        let view = UIView()
        let label = UILabel()
        
        label.text = "검색된 내용이 없어요"
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
    
    let recordEmptyView: UIView = {
        let view = UIView()
        let label = UILabel()
        
        label.text = "검색된 내용이 없어요"
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
    
    let userEmptyView: UIView = {
        let view = UIView()
        let label = UILabel()
        
        label.text = "검색된 유저가 없어요"
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
        
        setupSearchField()
        setupBookmarkButton()
        setupContentsView()
        setupSegmentedControl()
        setupCategoryView()
        setupTableViews()
        
        hideKeyboard()
        
        searchTextField.delegate = self
        
        recordTableView.delegate = self
        recordTableView.dataSource = self
        
        userTableView.delegate = self
        userTableView.dataSource = self
        
        recordTableView.register(SearchedContentCell.self, forCellReuseIdentifier: SearchedContentCell.cellId)
        userTableView.register(FriendProfileCell.self, forCellReuseIdentifier: FriendProfileCell.cellId)
        
        // 전달받은 검색어가 있는지 확인 후 검색 실행
        if let searchText = searchText {
            performSearch(searchText: searchText)
        }
        
        bind()
        
        //setupEmptyView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: - Setup Views
    
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Dismiss the keyboard
        textField.resignFirstResponder()
        
        // Check if the searchTextField has text
        guard let searchString = textField.text, !searchString.isEmpty else {
            return false
        }
        
        // SearchedVC로 이동 및 검색어 전달
        let searchedVC = SearchedVC()
        searchedVC.searchText = searchString
        searchedVC.searchTextField.text = searchString
        
        navigationController?.pushViewController(searchedVC, animated: true)
        
        return true
    }
    
//    private func setupEmptyView() {
//        emptyView.translatesAutoresizingMaskIntoConstraints = false
//        contentsView.addSubview(emptyView)
//        
//        NSLayoutConstraint.activate([
//            emptyView.centerXAnchor.constraint(equalTo: contentsView.centerXAnchor),
//            emptyView.centerYAnchor.constraint(equalTo: contentsView.centerYAnchor),
//            emptyView.widthAnchor.constraint(equalTo: contentsView.widthAnchor),
//            emptyView.heightAnchor.constraint(equalTo: contentsView.heightAnchor)
//        ])
//    }
//    
//    private func setupUserEmptyView() {
//        userEmptyView.translatesAutoresizingMaskIntoConstraints = false
//        contentsView.addSubview(userEmptyView)
//        
//        NSLayoutConstraint.activate([
//            userEmptyView.centerXAnchor.constraint(equalTo: contentsView.centerXAnchor),
//            userEmptyView.centerYAnchor.constraint(equalTo: contentsView.centerYAnchor),
//            userEmptyView.widthAnchor.constraint(equalTo: contentsView.widthAnchor),
//            userEmptyView.heightAnchor.constraint(equalTo: contentsView.heightAnchor)
//        ])
//    }
    
    func setupContentsView() {
        view.addSubview(contentsView)
        
        NSLayoutConstraint.activate([
            contentsView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 8),
            contentsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentsView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
    
    func setupSegmentedControl() {
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedControlChanged), for: .valueChanged)
        segmentedControl.selectedSegmentTintColor = .clear
        segmentedControl.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        segmentedControl.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        contentsView.addSubview(segmentedControl)
        contentsView.addSubview(underLineView)

        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: contentsView.topAnchor, constant: 8),
            segmentedControl.leadingAnchor.constraint(equalTo: contentsView.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: contentsView.trailingAnchor),
            segmentedControl.heightAnchor.constraint(equalToConstant: 40),
            
            underLineView.bottomAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            underLineView.heightAnchor.constraint(equalToConstant: 3),
            leadingDistance,
            underLineView.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor, multiplier: 1 / CGFloat(segmentedControl.numberOfSegments))
        ])

        segmentedControl.backgroundColor = UIColor.white
        segmentedControl.selectedSegmentTintColor = UIColor.white

        let normalTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.rcGray200,
            .font: UIFont.rcFont14B()
        ]

        let selectedTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.rcMain,
            .font: UIFont.rcFont14B()
        ]

        segmentedControl.setTitleTextAttributes(normalTextAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(selectedTextAttributes, for: .selected)

        segmentedControl.addTarget(self, action: #selector(changeUnderLinePosition), for: .valueChanged)
    }
    
    @objc private func changeUnderLinePosition() {
        let segmentIndex = CGFloat(segmentedControl.selectedSegmentIndex)
        let segmentWidth = segmentedControl.frame.width / CGFloat(segmentedControl.numberOfSegments)
        let leadingDistanceValue = segmentWidth * segmentIndex
        UIView.animate(withDuration: 0.2) {
            self.leadingDistance.constant = leadingDistanceValue
            self.view.layoutIfNeeded()
        }
    }

    @objc func segmentedControlChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            categoryScrollView.isHidden = false
            recordTableView.isHidden = false
            userTableView.isHidden = true
            recordTableView.reloadData()
            
        } else {
            categoryScrollView.isHidden = true
            recordTableView.isHidden = true
            userTableView.isHidden = false
            userTableView.reloadData()
        }
        
        //updateEmptyView()
    }
    
    func textFieldShouldReturn2(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        guard let searchString = textField.text, !searchString.isEmpty else {
            return false
        }
        
        // 새로운 검색 실행
        performSearch(searchText: searchString)
        
        return true
    }
    
    func setupCategoryView() {
        contentsView.addSubview(categoryView)

        NSLayoutConstraint.activate([
            categoryView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 8),
            categoryView.leadingAnchor.constraint(equalTo: contentsView.leadingAnchor),
            categoryView.trailingAnchor.constraint(equalTo: contentsView.trailingAnchor),
            categoryView.heightAnchor.constraint(equalToConstant: 40)
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
                    button.leadingAnchor.constraint(equalTo: categoryScrollView.leadingAnchor, constant: 8)
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
    
    func updateCategoryButtonAppearance() {
        for case let button as UIButton in categoryScrollView.subviews {
            if let category = button.currentTitle {
                button.backgroundColor = category == selectedCategory ? UIColor.rcMain : UIColor.rcGray000
                button.setTitleColor(category == selectedCategory ? .white : .rcMain, for: .normal)
            }
        }
    }

    
    @objc func categoryButtonTapped(_ sender: UIButton) {
        if let selectedCategory = sender.currentTitle {
            self.selectedCategory = selectedCategory
            updateCategoryButtonAppearance()
            viewModel.filterRecords(by: selectedCategory)
        }
    }
    
    func setupTableViews() {
        contentsView.addSubview(recordTableView)
        contentsView.addSubview(userTableView)

        recordTableView.translatesAutoresizingMaskIntoConstraints = false
        userTableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            recordTableView.topAnchor.constraint(equalTo: categoryView.bottomAnchor, constant: 8),
            recordTableView.leadingAnchor.constraint(equalTo: contentsView.leadingAnchor),
            recordTableView.trailingAnchor.constraint(equalTo: contentsView.trailingAnchor),
            recordTableView.bottomAnchor.constraint(equalTo: contentsView.bottomAnchor),

            userTableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 8),
            userTableView.leadingAnchor.constraint(equalTo: contentsView.leadingAnchor),
            userTableView.trailingAnchor.constraint(equalTo: contentsView.trailingAnchor),
            userTableView.bottomAnchor.constraint(equalTo: contentsView.bottomAnchor)
        ])
    }

    // MARK: - Actions
    
    @objc func goToBookMark() {
        let vc = BookmarkListVC()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - TableView DataSource and Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == recordTableView {
            print("Records Count: \(viewModel.searchedRecordCount())")
            return viewModel.searchedRecordCount()
        } else if tableView == userTableView {
            print("Users Count: \(viewModel.userCount())")
            return viewModel.userCount()
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == recordTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchedContentCell.cellId, for: indexPath) as? SearchedContentCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            
            let model = viewModel.getSearchedRecord(at: indexPath.row)
            
            let authorId = model.authorId
            
            if let userProfile = viewModel.getUserProfileModel(for: authorId!) {
                    cell.creatorLabel.text = userProfile.nickname
                    if let profileImageUrl = userProfile.profilePhoto {
//                        let baseUrl = "http://34.64.120.187:8080"
//                        let imageUrlStr = baseUrl + profileImageUrl // Safely unwrap the URL
//                        imageUrlStr.loadAsyncImage(cell.profileImageView)
                        cell.profileImageView.loadImage(urlWithoutBaseURL: profileImageUrl)
                        
                    } else {
                        print("Profile image URL is nil")
                    }
                } else {
                    // Fetch user profile if not loaded yet
                    viewModel.getUserProfile(userId: authorId!) { userProfile in
                        DispatchQueue.main.async {
                            cell.creatorLabel.text = userProfile?.nickname
                            if let profileImageUrl = userProfile?.profilePhoto {
//                                let baseUrl = "http://34.64.120.187:8080"
//                                let imageUrlStr = baseUrl + profileImageUrl // Safely unwrap the URL
//                                imageUrlStr.loadAsyncImage(cell.profileImageView)
                                cell.profileImageView.loadImage(urlWithoutBaseURL: profileImageUrl)
                            } else {
                                print("Profile image URL is nil")
                            }
                        }
                    }
                }
            
            // Set cell content based on the model data
            cell.titleLabel.text = model.title
            if let date = model.createdAt?.toDate() {
                cell.createDateLabel.text = date.toString()
            } else {
                cell.createDateLabel.text = model.createdAt
            }
            
            let category: String
            switch model.categoryId {
            case 1: category = "영화"
            case 2: category = "뮤지컬"
            case 3: category = "연극"
            case 4: category = "스포츠"
            case 5: category = "콘서트"
            case 6: category = "드라마"
            case 7: category = "독서"
            case 8: category = "전시회"
            default: category = "기타"
            }
            cell.categoryLabel.text = category
            
            if let firstPhoto = model.photos?.first, let photoUrl = firstPhoto.url {
//                let baseUrl = "http://34.64.120.187:8080"
//                let imageUrlStr = "\(baseUrl)\(photoUrl)"
//                imageUrlStr.loadAsyncImage(cell.contentImageView)
                cell.contentImageView.loadImage(urlWithoutBaseURL: photoUrl)
            }
            
            return cell
        } else if tableView == userTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FriendProfileCell.cellId, for: indexPath) as? FriendProfileCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            
            let userModel = viewModel.getUser(at: indexPath.row)
            cell.nameLabel.text = userModel.nickname
            
            if let profilePhotoUrl = userModel.profilePhoto {
//                let baseUrl = "http://34.64.120.187:8080"
//                let imageUrlStr = "\(baseUrl)\(profilePhotoUrl)"
//                imageUrlStr.loadAsyncImage(cell.profileImageView)
                cell.profileImageView.loadImage(urlWithoutBaseURL: profilePhotoUrl)
            }
            
            cell.followAction = { [weak self] in
                guard let self = self else { return }
                
                // Create the DTO with receiverId from userModel.id
                let requestDTO = SendRequestDTO(receiverId: userModel.userId!)
                
                print("Sending follow request for user ID: \(userModel.userId)")
                self.userViewModel.sendRequest(requestDTO: requestDTO)
            }
            
            return cell
        }
        
        return UITableViewCell()
    }

    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchedContentCell.cellId, for: indexPath) as? SearchedContentCell else {
//            return UITableViewCell()
//        }
//        cell.selectionStyle = .none
//        
//        let model = viewModel.getRecord(at: indexPath.row)
//        
//        // Set cell content based on the model data (similar to SearchVC)
//        cell.titleLabel.text = model.title
//        if let date = model.createdAt?.toDate() {
//            cell.createDateLabel.text = date.toString()
//        } else {
//            cell.createDateLabel.text = model.createdAt
//        }
//        
//        let category: String
//        switch model.categoryId {
//        case 1: category = "영화"
//        case 2: category = "뮤지컬"
//        case 3: category = "연극"
//        case 4: category = "스포츠"
//        case 5: category = "콘서트"
//        case 6: category = "드라마"
//        case 7: category = "독서"
//        case 8: category = "전시회"
//        default: category = "기타"
//        }
//        cell.categoryLabel.text = category
//        
//        if let firstPhoto = model.photos?.first, let photoUrl = firstPhoto.url {
//            let baseUrl = "http://34.64.120.187:8080"
//            let imageUrlStr = "\(baseUrl)\(photoUrl)"
//            imageUrlStr.loadAsyncImage(cell.contentImageView)
//        }
//        
//        return cell
//    }
//    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == recordTableView {
            return 140
        } else if tableView == userTableView {
            return 90
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == recordTableView {
            let selectedRecord = viewModel.getSearchedRecord(at: indexPath.row)
            
            let detailVC = SearchRecordDetailVC()
            
            detailVC.recordId = selectedRecord.id ?? 0
            detailVC.titleText = selectedRecord.title ?? "No Title"
            detailVC.creator = viewModel.getUserProfileModel(for: selectedRecord.authorId ?? 0)?.nickname ?? "Unknown Creator"
            detailVC.createdAt = selectedRecord.createdAt ?? "Unknown Date"
            detailVC.contentImage = selectedRecord.photos?.compactMap { $0.url } ?? []

            detailVC.hidesBottomBarWhenPushed = true
            navigationController?.isNavigationBarHidden = false
            navigationController?.pushViewController(detailVC, animated: true)
        }
        
        else if tableView == userTableView {
            
            let selectedUser = viewModel.getUser(at: indexPath.row)
            let userProfileVC = UserProfileVC()
            //userProfileVC.userId = selectedFollowing.followingID
            userProfileVC.userId = selectedUser.userId!
            
            userProfileVC.hidesBottomBarWhenPushed = true
            navigationController?.isNavigationBarHidden = false
            navigationController?.pushViewController(userProfileVC, animated: true)
            
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height

        if position > (contentHeight - frameHeight - 100) && !isFetching {
            if segmentedControl.selectedSegmentIndex == 0 {
                // Record Pagination
                if viewModel.canLoadMoreSearchResultPages() {
//                    let previousContentHeight = recordTableView.contentSize.height
//                    let previousOffsetY = scrollView.contentOffset.y
                    isFetching = true
                    viewModel.getSearchedRecords(fromCurrentVC: self, searchString: searchText ?? "") // { [weak self] in
//                        guard let self = self else { return }
//                        DispatchQueue.main.async {
//                            self.recordTableView.reloadData()
//                            self.isFetching = false
//                            
//                            // Maintain the scroll position
//                            let newContentHeight = self.recordTableView.contentSize.height
//                            let offsetYAdjustment = newContentHeight - previousContentHeight
//                            self.recordTableView.setContentOffset(CGPoint(x: 0, y: previousOffsetY + offsetYAdjustment), animated: false)
//                        }
//                    }
                }
            } else if segmentedControl.selectedSegmentIndex == 1 {
                // User Pagination
                if viewModel.canLoadMoreUserPages() {
                    isFetching = true
//                    let previousContentHeight = userTableView.contentSize.height
//                    let previousOffsetY = scrollView.contentOffset.y

                    viewModel.getSearchedUsers(fromCurrentVC: self, nickname: searchText ?? "")  // { [weak self] in
//                        guard let self = self else { return }
//                        DispatchQueue.main.async {
//                            self.userTableView.reloadData()
//                            self.isFetching = false
//                            
//                            // Maintain the scroll position
//                            let newContentHeight = self.userTableView.contentSize.height
//                            let offsetYAdjustment = newContentHeight - previousContentHeight
//                            self.userTableView.setContentOffset(CGPoint(x: 0, y: previousOffsetY + offsetYAdjustment), animated: false)
//                        }
//                    }
                }
            }
        }
    }

    private func updateEmptyView() {
        let hasData = (segmentedControl.selectedSegmentIndex == 0)
            ? viewModel.searchedRecordCount() > 0
            : viewModel.userCount() > 0

        emptyView.isHidden = hasData
        recordTableView.isHidden = segmentedControl.selectedSegmentIndex == 0 ? !hasData : true
        userTableView.isHidden = segmentedControl.selectedSegmentIndex == 1 ? !hasData : true
    }


    private func bind() {
        viewModel.allSearchedModelsDidChange = { [weak self] in
            DispatchQueue.main.async {
                self?.isFetching = true
                //if self?.segmentedControl.selectedSegmentIndex == 0 {
                    self?.recordTableView.reloadData()
                    self?.isFetching = false
                //}
            }
        }
        
        viewModel.allUserSearchedModelsDidChange = { [weak self] in
            DispatchQueue.main.async {
                self?.isFetching = true
                //if self?.segmentedControl.selectedSegmentIndex == 1 {
                // 위의 if문 때문에 if문 안에 들어오지 못해서 isFetching이 계속 true임..
                    self?.userTableView.reloadData()
                    self?.isFetching = false
                //}
            }
        }
    }
    
//    private func performSearch(searchText: String) {
//        // Fetch searched records
//        viewModel.getSearchedRecords(fromCurrentVC: self, searchString: searchText) { [weak self] in
//            DispatchQueue.main.async {
//                if self?.segmentedControl.selectedSegmentIndex == 0 {
//                    self?.recordTableView.reloadData()
//                }
//            }
//        }
//        
//        // Fetch searched users
//        viewModel.getSearchedUsers(fromCurrentVC: self, nickname: searchText) { [weak self] in
//            DispatchQueue.main.async {
//                if self?.segmentedControl.selectedSegmentIndex == 1 {
//                    self?.userTableView.reloadData()
//                }
//            }
//        }
//    }
    
    private func performSearch(searchText: String) {
        self.searchText = searchText // 현재 검색어 업데이트

        // 검색된 기록 가져오기
        viewModel.getSearchedRecords(fromCurrentVC: self, searchString: searchText) // { [weak self] in
//            DispatchQueue.main.async {
//                if self?.segmentedControl.selectedSegmentIndex == 0 {
//                    self?.recordTableView.reloadData()
//                }
//            }
//        }
        
        // 검색된 유저 가져오기
        viewModel.getSearchedUsers(fromCurrentVC: self, nickname: searchText) // { [weak self] in
//            DispatchQueue.main.async {
//                if self?.segmentedControl.selectedSegmentIndex == 1 {
//                    self?.userTableView.reloadData()
//                }
//            }
//        }
    }
    
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
        
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}




class SearchedContentCell: UITableViewCell {
    
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

class FriendProfileCell: UITableViewCell {
    
    static let cellId = "CellId"
    
    var requestId: Int?
    var followAction: (() -> Void)?
    var acceptAction: (() -> Void)?
    var rejectAction: (() -> Void)?
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.rcGrayBg
        imageView.layer.cornerRadius = 20
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.rcFont16B()
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let idLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.rcFont14M()
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let acceptButton: UIButton = {
        let button = UIButton()
        button.setTitle("수락", for: .normal)
        button.backgroundColor = UIColor.rcMain
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.rcFont14M()
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        //button.addTarget(self, action: #selector(acceptRequest), for: .touchUpInside)
        
        return button
    }()
    
    let denyButton: UIButton = {
        let button = UIButton()
        button.setTitle("거절", for: .normal)
        button.backgroundColor = UIColor.rcGray000
        button.setTitleColor(UIColor.rcGray800, for: .normal)
        button.titleLabel?.font = UIFont.rcFont14M()
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        //button.addTarget(self, action: #selector(denyRequest), for: .touchUpInside)
        
        return button
    }()
    
    let followButton: UIButton = {
        let button = UIButton()
        button.setTitle("팔로우", for: .normal)
        button.backgroundColor = UIColor.rcMain
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.rcFont14M()
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
//    @objc func acceptRequest() {
//        self.viewModel.acceptRequest(requestId: Int)
//        print("요청 수락")
//    }
//
//    @objc func denyRequest() {
//        self.viewModel.rejectRequest(requestId: Int)
//        print("요청 거절")
//    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        
        followButton.addTarget(self, action: #selector(followTapped), for: .touchUpInside)
        acceptButton.addTarget(self, action: #selector(acceptTapped), for: .touchUpInside)
        denyButton.addTarget(self, action: #selector(rejectTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func acceptTapped() {
        acceptAction?()
        print("수락")
    }
    
    @objc private func rejectTapped() {
        rejectAction?()
        print("거절")
    }
    
    @objc private func followTapped() {
         followAction?()
         print("Follow button tapped")
        
         followButton.setTitle("요청중", for: .normal)
         followButton.backgroundColor = UIColor(hexCode: "#ECEFF7")
         followButton.setTitleColor(UIColor.black, for: .normal)
     }

    
    func setupLayout() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        //contentView.addSubview(idLabel)
        contentView.addSubview(followButton)

        NSLayoutConstraint.activate([
            profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            profileImageView.heightAnchor.constraint(equalToConstant: 40),
            profileImageView.widthAnchor.constraint(equalToConstant: 40),
            
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12),
            nameLabel.heightAnchor.constraint(equalToConstant: 24),
            nameLabel.widthAnchor.constraint(equalToConstant: 160),
            
//            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24),
//            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12),
//            nameLabel.heightAnchor.constraint(equalToConstant: 24),
//            nameLabel.widthAnchor.constraint(equalToConstant: 160),
            
//            idLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
//            idLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12),
//            idLabel.heightAnchor.constraint(equalToConstant: 14),
 
            followButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            followButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            followButton.heightAnchor.constraint(equalToConstant: 34),
            followButton.widthAnchor.constraint(equalToConstant: 84)
            
        ])
        
    }
    
    
}



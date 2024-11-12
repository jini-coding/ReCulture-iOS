//
//  UserProfileVC.swift
//  ReCulture
//
//  Created by Jini on 10/18/24.
//

import UIKit

class UserProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let viewModel = RecordViewModel()
    private let myviewModel = MypageViewModel()
    private let searchviewModel = SearchViewModel()
    
    var userId: Int = 0
    var isCurrentUserProfile: Bool = false
    
    let profileView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rcGrayBg
        
        return view
    }()
    
    let profileImg: UIImageView = {
        let imageview = UIImageView()
        imageview.backgroundColor = UIColor.rcGrayBg
        imageview.layer.cornerRadius = 30
        imageview.clipsToBounds = true
        
        return imageview
    }()
    
    let nickname: UILabel = {
        let label = UILabel()
        label.font = UIFont.rcFont20B()
        label.text = ""
        
        return label
    }()
    
    let level: UILabel = {
        let label = UILabel()
        label.font = UIFont.rcFont12SB()
        label.text = "Level 0"
        label.textColor = UIColor(hexCode: "#85888A")
        
        return label
    }()
    
    let separateLineImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "separate_line")
        
        return imageview
    }()
    
    let levelName: UILabel = {
        let label = UILabel()
        label.font = UIFont.rcFont12SB()
        label.text = ""
        label.textColor = UIColor(hexCode: "#85888A")
        
        return label
    }()
    
    let commentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.rcFont12SB()
        label.text = ""
        
        return label
    }()
    
    let interestName: UILabel = {
        let label = UILabel()
        label.font = UIFont.rcFont10SB()
        label.textColor = UIColor.rcMain
        label.backgroundColor = UIColor.white
        label.layer.borderColor = UIColor(hexCode: "#BEC4C6").cgColor
        label.layer.borderWidth = 1.0
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 6
        label.text = "관심분야"
        label.textAlignment = .center
        
        return label
    }()
    
    let interestLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.rcFont12SB()
        label.textColor = UIColor(hexCode: "#85888A")
        label.text = "에 관심이 많아요"
        
        return label
    }()
    
    let followButton: UIButton = {
        let button = UIButton()
        button.setTitle("팔로우", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.rcFont14M()
        button.backgroundColor = UIColor.rcMain
        button.layer.cornerRadius = 8
        
        return button
    }()
 
    let recordContentsView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray
        
        return view
    }()
    
    let contentTableView: UITableView = {
        let tableview = UITableView()
        tableview.separatorStyle = .singleLine
        tableview.showsVerticalScrollIndicator = false
        tableview.backgroundColor = UIColor.white
        
        return tableview
    }()
    
    let emptyView: UIView = {
        let view = UIView()
        let label = UILabel()
        
        label.text = "아직 작성된 기록이 없어요"
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
        
        view.backgroundColor = UIColor.white
        
        setupProfileView()
        setupContentView()
        
        view.addSubview(emptyView)
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emptyView.topAnchor.constraint(equalTo: recordContentsView.topAnchor),
            emptyView.leadingAnchor.constraint(equalTo: recordContentsView.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: recordContentsView.trailingAnchor),
            emptyView.bottomAnchor.constraint(equalTo: recordContentsView.bottomAnchor)
        ])
        
        contentTableView.delegate = self
        contentTableView.dataSource = self
        contentTableView.register(UserRecordContentCell.self, forCellReuseIdentifier: UserRecordContentCell.cellId)
                
        bind()
        loadUserProfile(userId: userId)
        //viewModel.getuserRecords(userId: userId, fromCurrentVC: self)
        
        if let currentUserId = getCurrentUserId() {
            if currentUserId == userId {
                isCurrentUserProfile = true
                viewModel.getmyRecords(fromCurrentVC: self)
                followButton.isHidden = true
            } else {
                isCurrentUserProfile = false
                viewModel.getuserRecords(userId: userId, fromCurrentVC: self)
                followButton.isHidden = false
            }
        } else {
            print("error")
        }
    }
    
    private func bind() {
        let currentUserId = getCurrentUserId()
        
        if currentUserId == userId {
            viewModel.allRecordModelDidChange = { [weak self] in
                 DispatchQueue.main.async {
                     self?.updateEmptyView()
                     self?.contentTableView.reloadData()
                 }
            }
        }
        else {
            viewModel.allUserRecordModelDidChange = { [weak self] in
                 DispatchQueue.main.async {
                     self?.updateEmptyView()
                     self?.contentTableView.reloadData()
                 }
            }
        }
        
        searchviewModel.userProfileDetailDidChange = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let userProfile = self.searchviewModel.getUserdDetail() {
                    self.updateUI(with: userProfile)
                }
            }
        }
    }
    
    private func getCurrentUserId() -> Int? {
        return UserDefaults.standard.integer(forKey: "userId")
    }
    
    private func loadUserProfile(userId: Int) {
        searchviewModel.getUserProfileDetails(userId: userId)
    }
    
    private func updateEmptyView() {
        let hasData = isCurrentUserProfile ? viewModel.recordCount() > 0 : viewModel.userrecordCount() > 0
        emptyView.isHidden = hasData
    }
    
    private func updateUI(with profile: UserProfileModel) {
        // Update each UI component with data from the profile
        nickname.text = profile.nickname
        level.text = "Level \(profile.levelId ?? 0)"
        levelName.text = profile.level
        commentLabel.text = profile.bio
        interestName.text = profile.interest
        
//        let imageUrlStr = "http://34.64.120.187:8080\()"
//        .loadAsyncImage(profileImg)
        profileImg.loadImage(urlWithoutBaseURL: searchviewModel.getProfileImage())
        
//        if let profileImageURL = profile.profilePhoto {
//            profileImageURL.loadAsyncImage(profileImg)
//        }
    }
    
    func setupProfileView() {
        profileView.translatesAutoresizingMaskIntoConstraints = false
        
        profileImg.translatesAutoresizingMaskIntoConstraints = false
        nickname.translatesAutoresizingMaskIntoConstraints = false
        level.translatesAutoresizingMaskIntoConstraints = false
        separateLineImageView.translatesAutoresizingMaskIntoConstraints = false
        levelName.translatesAutoresizingMaskIntoConstraints = false
        followButton.translatesAutoresizingMaskIntoConstraints = false
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        interestName.translatesAutoresizingMaskIntoConstraints = false
        interestLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(profileView)
        profileView.addSubview(profileImg)
        profileView.addSubview(nickname)
        profileView.addSubview(level)
        profileView.addSubview(separateLineImageView)
        profileView.addSubview(levelName)
        profileView.addSubview(followButton)
        profileView.addSubview(commentLabel)
        profileView.addSubview(interestName)
        profileView.addSubview(interestLabel)
        
        
        NSLayoutConstraint.activate([
            profileView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            profileView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            profileView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            profileView.heightAnchor.constraint(equalToConstant: 164),
            
            profileImg.topAnchor.constraint(equalTo: profileView.topAnchor, constant: 25),
            profileImg.leadingAnchor.constraint(equalTo: profileView.leadingAnchor, constant: 18),
            profileImg.widthAnchor.constraint(equalToConstant: 60),
            profileImg.heightAnchor.constraint(equalToConstant: 60),
            
            nickname.topAnchor.constraint(equalTo: profileView.topAnchor, constant: 29),
            nickname.leadingAnchor.constraint(equalTo: profileImg.trailingAnchor, constant: 18),
            nickname.widthAnchor.constraint(equalToConstant: 100),
            nickname.heightAnchor.constraint(equalToConstant: 28),
            
            level.topAnchor.constraint(equalTo: nickname.bottomAnchor, constant: 6),
            level.leadingAnchor.constraint(equalTo: profileImg.trailingAnchor, constant: 18),
            level.widthAnchor.constraint(equalToConstant: 38),
            level.heightAnchor.constraint(equalToConstant: 17),
            
            separateLineImageView.topAnchor.constraint(equalTo: nickname.bottomAnchor, constant: 8),
            separateLineImageView.leadingAnchor.constraint(equalTo: level.trailingAnchor, constant: 8),
            separateLineImageView.widthAnchor.constraint(equalToConstant: 1),
            separateLineImageView.heightAnchor.constraint(equalToConstant: 12),
            
            levelName.topAnchor.constraint(equalTo: nickname.bottomAnchor, constant: 6),
            levelName.leadingAnchor.constraint(equalTo: separateLineImageView.trailingAnchor, constant: 8),
            levelName.widthAnchor.constraint(equalToConstant: 60),
            levelName.heightAnchor.constraint(equalToConstant: 17),
            
            followButton.topAnchor.constraint(equalTo: profileView.topAnchor, constant: 38),
            followButton.trailingAnchor.constraint(equalTo: profileView.trailingAnchor, constant: -16),
            followButton.widthAnchor.constraint(equalToConstant: 84),
            followButton.heightAnchor.constraint(equalToConstant: 34),
            
            commentLabel.topAnchor.constraint(equalTo: profileImg.bottomAnchor, constant: 16),
            commentLabel.leadingAnchor.constraint(equalTo: profileView.leadingAnchor, constant: 36),
            commentLabel.heightAnchor.constraint(equalToConstant: 15),
            
            
            interestName.topAnchor.constraint(equalTo: commentLabel.bottomAnchor, constant: 9),
            interestName.leadingAnchor.constraint(equalTo: profileView.leadingAnchor, constant: 36),
            interestName.heightAnchor.constraint(equalToConstant: 15),
            interestName.widthAnchor.constraint(equalToConstant: 45),
            
            interestLabel.topAnchor.constraint(equalTo: commentLabel.bottomAnchor, constant: 9),
            interestLabel.leadingAnchor.constraint(equalTo: interestName.trailingAnchor, constant: 5),
            interestLabel.heightAnchor.constraint(equalToConstant: 15),
            interestLabel.widthAnchor.constraint(equalToConstant: 90)
            
        ])
    }


    func setupContentView() {
        recordContentsView.translatesAutoresizingMaskIntoConstraints = false
        contentTableView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(recordContentsView)
        recordContentsView.addSubview(contentTableView)
        
        NSLayoutConstraint.activate([
            recordContentsView.topAnchor.constraint(equalTo: profileView.bottomAnchor, constant: 10),
            recordContentsView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            recordContentsView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            recordContentsView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 20),
            
            contentTableView.topAnchor.constraint(equalTo: recordContentsView.topAnchor, constant: 0),
            contentTableView.leadingAnchor.constraint(equalTo: recordContentsView.leadingAnchor),
            contentTableView.trailingAnchor.constraint(equalTo: recordContentsView.trailingAnchor),
            contentTableView.bottomAnchor.constraint(equalTo: recordContentsView.bottomAnchor)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return viewModel.userrecordCount()
        return isCurrentUserProfile ? viewModel.recordCount() : viewModel.userrecordCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserRecordContentCell.cellId, for: indexPath) as! UserRecordContentCell
        cell.selectionStyle = .none
        
        //let model = viewModel.getUserRecord(at: indexPath.row)
        let model = isCurrentUserProfile ? viewModel.getRecord(at: indexPath.row) : viewModel.getUserRecord(at: indexPath.row)
        
        let authorId = model.culture.authorId
        let userProfile = searchviewModel.getUserProfileModel(for: authorId)
        
        if isCurrentUserProfile { // 현재 사용자의 프로필일 경우
            cell.titleLabel.text = model.culture.title
            cell.nameLabel.text = searchviewModel.getNickname()
            
    //        let imageUrlStr = "http://34.64.120.187:8080\(myviewModel.getProfileImage())"
    //        imageUrlStr.loadAsyncImage(cell.profileImageView)
            cell.profileImageView.loadImage(urlWithoutBaseURL: searchviewModel.getProfileImage())
            
            let category: String
            switch model.culture.categoryId {
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
            
            cell.createDateLabel.text = model.culture.date.toDate()?.toString()
            cell.commentLabel.text = model.culture.review
            
            // Configure the images using the new method
            let imageUrls = model.photoDocs.map { "\($0.url)" }
            cell.configureImages(imageUrls)
        }
        else { // 다른 사용자의 프로필일 경우
            cell.titleLabel.text = model.culture.title
            //cell.nameLabel.text = "\(myviewModel.getNickname())"

            if let userProfile = searchviewModel.getUserProfileModel(for: authorId) {
                cell.nameLabel.text = userProfile.nickname
                    if let profileImageUrl = userProfile.profilePhoto {
    //                    let baseUrl = "http://34.64.120.187:8080"
    //                    let imageUrlStr = baseUrl + profileImageUrl // Safely unwrap the URL
    //                    imageUrlStr.loadAsyncImage(cell.profileImageView)
                        cell.profileImageView.loadImage(urlWithoutBaseURL: profileImageUrl)
                    } else {
                        print("Profile image URL is nil")
                    }
                } else {
                    // Fetch user profile if not loaded yet
                    searchviewModel.getUserProfile(userId: authorId) { userProfile in
                        DispatchQueue.main.async {
                            cell.nameLabel.text = userProfile?.nickname
                            if let profileImageUrl = userProfile?.profilePhoto {
    //                            let baseUrl = "http://34.64.120.187:8080"
    //                            let imageUrlStr = baseUrl + profileImageUrl // Safely unwrap the URL
    //                            imageUrlStr.loadAsyncImage(cell.profileImageView)
                                cell.profileImageView.loadImage(urlWithoutBaseURL: profileImageUrl)
                            } else {
                                print("Profile image URL is nil")
                            }
                        }
                    }
                }
            
            cell.createDateLabel.text = model.culture.date.toDate()?.toString()
            
            let category: String
            switch model.culture.categoryId {
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
            
            cell.commentLabel.text = model.culture.review
            
            // Configure images
            let imageUrls = model.photoDocs.map { "\($0.url)" }
            cell.configureImages(imageUrls)
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = isCurrentUserProfile ? viewModel.getRecord(at: indexPath.row) : viewModel.getUserRecord(at: indexPath.row)
        let vc = SearchRecordDetailVC()
        
        if isCurrentUserProfile {
            vc.recordId = model.culture.id
            vc.titleText = model.culture.title
            vc.profileImageView.loadImage(urlWithoutBaseURL: searchviewModel.getProfileImage())
            vc.creator = searchviewModel.getNickname() // 현재 사용자의 닉네임 설정
            vc.createdAt = model.culture.date.toDate()?.toString() ?? model.culture.date
        }
        else {
            let authorId = model.culture.authorId
            let userProfile = searchviewModel.getUserProfileModel(for: authorId)
            
            vc.recordId = model.culture.id
            vc.titleText = model.culture.title
            vc.profileImageView.loadImage(urlWithoutBaseURL: userProfile?.profilePhoto ?? "no_img")
            vc.creator = userProfile?.nickname ?? "Unknown"
            vc.createdAt = model.culture.date.toDate()?.toString() ?? model.culture.date
        }

        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }

}

class UserRecordContentCell: UITableViewCell {
    
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
    
    let categoryLabelView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexCode: "#F5F6FA")
        view.layer.cornerRadius = 6
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.rcFont12SB()
        label.textColor = UIColor.rcMain
        label.textAlignment = .center
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
        contentView.addSubview(createDateLabel)
        contentView.addSubview(categoryLabelView)
        categoryLabelView.addSubview(categoryLabel)
        contentView.addSubview(commentLabel)
        
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
            
            createDateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 21),
            createDateLabel.leadingAnchor.constraint(equalTo: separateLineImageView.trailingAnchor, constant: 8),
            createDateLabel.heightAnchor.constraint(equalToConstant: 15),
            
            categoryLabelView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 19),
            categoryLabelView.leadingAnchor.constraint(equalTo: createDateLabel.trailingAnchor, constant: 15),
            categoryLabelView.widthAnchor.constraint(equalToConstant: 50),
            categoryLabelView.heightAnchor.constraint(equalToConstant: 17),
            
            categoryLabel.centerXAnchor.constraint(equalTo: categoryLabelView.centerXAnchor),
            categoryLabel.centerYAnchor.constraint(equalTo: categoryLabelView.centerYAnchor),
            
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

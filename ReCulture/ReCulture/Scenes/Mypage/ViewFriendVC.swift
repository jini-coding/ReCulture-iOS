//
//  ViewFriendVC.swift
//  ReCulture
//
//  Created by Jini on 5/17/24.
//

import UIKit

class ViewFriendVC: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    var pageViewController: UIPageViewController!
    var viewControllerList: [UIViewController] = []
    let segmentedControl = UISegmentedControl(items: ["팔로워", "팔로잉"])
    let containerView = UIView()
    
    let searchViewModel = SearchViewModel()
    
    let underLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rcMain
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var leadingDistance: NSLayoutConstraint = {
      return underLineView.leadingAnchor.constraint(equalTo: segmentedControl.leadingAnchor)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        setupNavigationBar()
        setupSegmentedControl()
        setupContainerView()
        
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        let followerVC = FollowerViewController()
        let followingVC = FollowingViewController()
        
        followerVC.title = "팔로워"
        followingVC.title = "팔로잉"
        
        viewControllerList = [followerVC, followingVC]
        
        if let firstViewController = viewControllerList.first {
            pageViewController.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
        
        addChild(pageViewController)
        containerView.addSubview(pageViewController.view)
        pageViewController.view.frame = containerView.bounds
        pageViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        pageViewController.didMove(toParent: self)
    }
    
    
    func setupNavigationBar() {
        self.navigationItem.title = "내 친구 목록"
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.rcFont18B()
        ]
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.layoutIfNeeded()
    }
    
    func setupSegmentedControl() {
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedControlChanged), for: .valueChanged)
        segmentedControl.selectedSegmentTintColor = .clear
        segmentedControl.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        segmentedControl.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        view.addSubview(underLineView)
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            segmentedControl.heightAnchor.constraint(equalToConstant: 44),
            
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
        
        segmentedControl.addTarget(self, action: #selector(changeUnderLinePosition), for: .valueChanged)

        segmentedControl.setTitleTextAttributes(normalTextAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        
    }
    
    @objc func segmentedControlChanged(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        guard let currentViewController = pageViewController.viewControllers?.first,
              let currentIndex = viewControllerList.firstIndex(of: currentViewController) else { return }
        let direction: UIPageViewController.NavigationDirection = index >= currentIndex ? .forward : .reverse
        pageViewController.setViewControllers([viewControllerList[index]], direction: direction, animated: true, completion: nil)
    }

    @objc private func changeUnderLinePosition() {
        let segmentIndex = CGFloat(segmentedControl.selectedSegmentIndex)
        let segmentWidth = segmentedControl.frame.width / CGFloat(segmentedControl.numberOfSegments)
        let leadingDistance = segmentWidth * segmentIndex
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.leadingDistance.constant = leadingDistance
            self?.view.layoutIfNeeded()
        })
    }
    
    func setupContainerView() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 800) // Set desired height
        ])
    }
    
    // MARK: - UIPageViewControllerDataSource

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = viewControllerList.firstIndex(of: viewController) else { return nil }
        let previousIndex = currentIndex - 1
        guard previousIndex >= 0 else { return nil }
        return viewControllerList[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = viewControllerList.firstIndex(of: viewController) else { return nil }
        let nextIndex = currentIndex + 1
        guard nextIndex < viewControllerList.count else { return nil }
        return viewControllerList[nextIndex]
    }

    // MARK: - UIPageViewControllerDelegate

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let currentViewController = pageViewController.viewControllers?.first,
           let index = viewControllerList.firstIndex(of: currentViewController) {
            segmentedControl.selectedSegmentIndex = index
            changeUnderLinePosition()
        }
    }
}

class FollowerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let viewModel = MypageViewModel()
    var followers: [FollowerModel] = []
    
    struct Friend {
        var profileImage: String
        var name: String
        var id: String
        var follower: Bool
        var following: Bool
        var follow: Bool
    }
    
    let friendData = [
        Friend(profileImage: "temp_img2", name: "수연", id: "@soohyun", follower: false, following: true, follow: false),
        Friend(profileImage: "temp_img", name: "수연", id: "@musicsoosoo", follower: true, following: true, follow: true),
        Friend(profileImage: "temp_img2", name: "수연", id: "@sooyeon1234", follower: false, following: true, follow: false),
        Friend(profileImage: "temp_img", name: "수연", id: "@happysoo", follower: false, following: true, follow: false),
        Friend(profileImage: "temp_img2", name: "수연", id: "@iulovesuyeon", follower: true, following: true, follow: true)
    ]

    let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "FriendRequestVC"
        label.textColor = UIColor.rcMain
        
        return label
    }()
    
    let followerTableView: UITableView = {
        let tableview = UITableView()
        tableview.separatorStyle = .singleLine
        
        return tableview
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        bind()
        viewModel.getFollowers()
        
        setupNavigationBar()
        setTableView()
        
        followerTableView.tableHeaderView = UIView(frame: .zero)
        followerTableView.register(FriendCell.self, forCellReuseIdentifier: FriendCell.cellId)
        
        followerTableView.delegate = self
        followerTableView.dataSource = self
    }
    
    private func bind() {
        viewModel.followersDidChange = { [weak self] in
            DispatchQueue.main.async {
                self?.followerTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.followers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = viewModel.followers[indexPath.row]  // Get the follower data
         
        let cell = tableView.dequeueReusableCell(withIdentifier: FriendCell.cellId, for: indexPath) as! FriendCell
        cell.selectionStyle = .none
        
        let authorId = data.followerID
        
        if let userProfile = viewModel.getUserProfileModel(for: authorId) {
                cell.nameLabel.text = userProfile.nickname
                if let profileImageUrl = userProfile.profilePhoto {
                    let baseUrl = "http://34.64.120.187:8080"
                    let imageUrlStr = baseUrl + profileImageUrl // Safely unwrap the URL
                    imageUrlStr.loadAsyncImage(cell.profileImageView)
                } else {
                    print("Profile image URL is nil")
                }
            } else {
                // Fetch user profile if not loaded yet
                viewModel.getUserProfile(userId: authorId) { userProfile in
                    DispatchQueue.main.async {
                        cell.nameLabel.text = userProfile?.nickname
                        if let profileImageUrl = userProfile?.profilePhoto {
                            let baseUrl = "http://34.64.120.187:8080"
                            let imageUrlStr = baseUrl + profileImageUrl // Safely unwrap the URL
                            imageUrlStr.loadAsyncImage(cell.profileImageView)
                        } else {
                            print("Profile image URL is nil")
                        }
                    }
                }
            }
        
//        // Populate the cell with follower data
//        cell.nameLabel.text = "\(data.follower.id)"  // You can use data like name if available
//        cell.idLabel.text = data.follower.email
        
        // Configure the follow button (this logic can be modified based on your use case)
        cell.followButton.setTitle("팔로우", for: .normal)
        cell.followButton.backgroundColor = UIColor.rcMain
        cell.followButton.setTitleColor(UIColor.white, for: .normal)
        cell.followButton.titleLabel?.font = UIFont.rcFont14M()
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let data = friendData[indexPath.row]
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: FriendCell.cellId, for: indexPath) as! FriendCell
//        cell.selectionStyle = .none
//         // Assuming you have images added in assets
//        cell.profileImageView.image = UIImage(named: data.profileImage)
//        cell.nameLabel.text = data.name
//        cell.idLabel.text = data.id
//
//        if (data.follow == true) {
//            cell.followButton.setTitle("팔로잉", for: .normal)
//            cell.followButton.backgroundColor = UIColor.rcGray000
//            cell.followButton.setTitleColor(UIColor.rcGray800, for: .normal)
//            cell.followButton.titleLabel?.font = UIFont.rcFont14M()
//        } else {
//            cell.followButton.setTitle("팔로우", for: .normal)
//            cell.followButton.backgroundColor = UIColor.rcMain
//            cell.followButton.setTitleColor(UIColor.white, for: .normal)
//            cell.followButton.titleLabel?.font = UIFont.rcFont14M()
//        }
//
//        return cell
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func setupTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = "친구 요청"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.rcFont18B()]
        self.navigationController?.navigationBar.setBackgroundImage(nil, for:.default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.layoutIfNeeded()
        
    }
    
    func setTableView() {
        followerTableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(followerTableView)
        
        NSLayoutConstraint.activate([
            followerTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            followerTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            followerTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            followerTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

class FollowingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let viewModel = MypageViewModel()
    var followings: [FollowingModel] = []
    
    struct Friend {
        var profileImage: String
        var name: String
        var id: String
        var follower: Bool
        var following: Bool
        var follow: Bool
    }
    
    let followingTableView: UITableView = {
        let tableview = UITableView()
        tableview.separatorStyle = .singleLine
        
        return tableview
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        bind()
        viewModel.getFollowings()
        
        setupNavigationBar()
        setTableView()
        
        followingTableView.tableHeaderView = UIView(frame: .zero)
        followingTableView.register(FriendCell.self, forCellReuseIdentifier: FriendCell.cellId)
        
        followingTableView.delegate = self
        followingTableView.dataSource = self
    }
    
    private func bind() {
        viewModel.followingsDidChange = { [weak self] in
            DispatchQueue.main.async {
                self?.followingTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.followings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = viewModel.followings[indexPath.row]
         
        let cell = tableView.dequeueReusableCell(withIdentifier: FriendCell.cellId, for: indexPath) as! FriendCell
        cell.selectionStyle = .none
        
        let authorId = data.followingID
        
        if let userProfile = viewModel.getUserProfileModel(for: authorId) {
                cell.nameLabel.text = userProfile.nickname
                if let profileImageUrl = userProfile.profilePhoto {
                    let baseUrl = "http://34.64.120.187:8080"
                    let imageUrlStr = baseUrl + profileImageUrl // Safely unwrap the URL
                    imageUrlStr.loadAsyncImage(cell.profileImageView)
                } else {
                    print("Profile image URL is nil")
                }
            } else {
                // Fetch user profile if not loaded yet
                viewModel.getUserProfile(userId: authorId) { userProfile in
                    DispatchQueue.main.async {
                        cell.nameLabel.text = userProfile?.nickname
                        if let profileImageUrl = userProfile?.profilePhoto {
                            let baseUrl = "http://34.64.120.187:8080"
                            let imageUrlStr = baseUrl + profileImageUrl // Safely unwrap the URL
                            imageUrlStr.loadAsyncImage(cell.profileImageView)
                        } else {
                            print("Profile image URL is nil")
                        }
                    }
                }
            }
        
//        cell.nameLabel.text = "\(data.following.id)"
//        cell.idLabel.text = data.following.email
        
        // 설정에 따라 팔로우 버튼 업데이트
        cell.followButton.setTitle("팔로잉", for: .normal)
        cell.followButton.backgroundColor = UIColor.rcGray000
        cell.followButton.setTitleColor(UIColor.rcGray800, for: .normal)
        cell.followButton.titleLabel?.font = UIFont.rcFont14M()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = "친구 요청"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.rcFont18B()]
        self.navigationController?.navigationBar.setBackgroundImage(nil, for:.default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.layoutIfNeeded()
        
    }
    
    func setTableView() {
        followingTableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(followingTableView)
        
        NSLayoutConstraint.activate([
            followingTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            followingTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            followingTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            followingTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

class FriendCell: UITableViewCell {
    
    static let cellId = "CellId"
    
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
//
//    let denyButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("거절", for: .normal)
//        button.backgroundColor = UIColor.rcGray000
//        button.setTitleColor(UIColor.rcGray800, for: .normal)
//        button.titleLabel?.font = UIFont.rcFont14M()
//        button.layer.cornerRadius = 8
//        button.clipsToBounds = true
//        button.translatesAutoresizingMaskIntoConstraints = false
//
//        return button
//    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        //contentView.addSubview(idLabel)
        contentView.addSubview(followButton)
        //contentView.addSubview(denyButton)

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
 
//            acceptButton.centerYAnchor.constraint(equalTo: centerYAnchor),
//            acceptButton.trailingAnchor.constraint(equalTo: denyButton.leadingAnchor, constant: -4),
//            acceptButton.heightAnchor.constraint(equalToConstant: 34),
//            acceptButton.widthAnchor.constraint(equalToConstant: 68),
            
            followButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            followButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            followButton.heightAnchor.constraint(equalToConstant: 34),
            followButton.widthAnchor.constraint(equalToConstant: 84)
            
        ])
        
    }
    
    
}

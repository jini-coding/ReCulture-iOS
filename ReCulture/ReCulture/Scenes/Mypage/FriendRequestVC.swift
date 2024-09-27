//
//  FriendRequestVC.swift
//  ReCulture
//
//  Created by Jini on 5/17/24.
//

import UIKit

class FriendRequestVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let viewModel = MypageViewModel()
    var pendings: [FollowStateDTO] = []
    
    struct Friend {
        var profileImage: String
        var name: String
        var id: String
        var isAccept: Bool
    }
    
    let friendData = [
        Friend(profileImage: "temp_img2", name: "수연", id: "@soohyun", isAccept: false),
        Friend(profileImage: "temp_img", name: "수연", id: "@musicsoosoo", isAccept: false),
        Friend(profileImage: "temp_img2", name: "수연", id: "@sooyeon1234", isAccept: false),
        Friend(profileImage: "temp_img", name: "수연", id: "@happysoo", isAccept: false),
        Friend(profileImage: "temp_img2", name: "수연", id: "@iulovesuyeon", isAccept: false)
    ]

    let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "FriendRequestVC"
        label.textColor = UIColor.rcMain
        
        return label
    }()
    
    let requestTableView: UITableView = {
        let tableview = UITableView()
        tableview.separatorStyle = .singleLine
        
        return tableview
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        bind()
        viewModel.getPendingRequest()
        
        setupNavigationBar()
        setTableView()
        
        requestTableView.tableHeaderView = UIView(frame: .zero)
        requestTableView.register(FriendRequestCell.self, forCellReuseIdentifier: FriendRequestCell.cellId)
        
        requestTableView.delegate = self
        requestTableView.dataSource = self
    }
    
    private func bind() {
        viewModel.pendingsDidChange = { [weak self] in
            DispatchQueue.main.async {
                self?.requestTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.pendings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = viewModel.pendings[indexPath.row] // 해당 인덱스의 pending 요청 데이터를 가져옴
        
        let cell = tableView.dequeueReusableCell(withIdentifier: FriendRequestCell.cellId, for: indexPath) as! FriendRequestCell
        cell.selectionStyle = .none
        
        cell.requestId = data.id
    
        let authorId = data.fromUserID // 요청을 보낸 유저 ID
        
        if let userProfile = viewModel.getUserProfileModel(for: authorId) {
            cell.nameLabel.text = userProfile.nickname
            cell.idLabel.text = "@\(authorId)"
            if let profileImageUrl = userProfile.profilePhoto {
                let imageUrlStr = "http://34.64.120.187:8080\(profileImageUrl)"
                imageUrlStr.loadAsyncImage(cell.profileImageView) // 프로필 이미지 비동기 로드
            }
        } else {
            // 아직 로드되지 않은 경우 비동기로 프로필 데이터를 가져옴
            viewModel.getUserProfile(userId: authorId) { userProfile in
                DispatchQueue.main.async {
                    cell.nameLabel.text = userProfile?.nickname
                    cell.idLabel.text = "@\(authorId)"
                    if let profileImageUrl = userProfile?.profilePhoto {
                        let imageUrlStr = "http://34.64.120.187:8080\(profileImageUrl)"
                        imageUrlStr.loadAsyncImage(cell.profileImageView)
                    }
                }
            }
        }
        
        cell.acceptAction = { [weak self] in
            self?.viewModel.acceptRequest(requestId: data.id)
        }
        
        cell.rejectAction = { [weak self] in
            self?.viewModel.rejectRequest(requestId: data.id)
        }
        
        return cell
    }
    
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
        requestTableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(requestTableView)
        
        NSLayoutConstraint.activate([
            requestTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            requestTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            requestTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            requestTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    
}

class FriendRequestCell: UITableViewCell {
    
    static let cellId = "CellId"
    
    var requestId: Int?
    
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
    
//    @objc func acceptRequest() {
//        self.viewModel.acceptRequest(requestId: Int)
//        print("요청 수락")
//    }
//    @objc func denyRequest() {
//        self.viewModel.rejectRequest(requestId: Int)
//        print("요청 거절")
//    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        
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
    
    func setupLayout() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        //contentView.addSubview(idLabel)
        contentView.addSubview(acceptButton)
        contentView.addSubview(denyButton)

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
 
            acceptButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            acceptButton.trailingAnchor.constraint(equalTo: denyButton.leadingAnchor, constant: -4),
            acceptButton.heightAnchor.constraint(equalToConstant: 34),
            acceptButton.widthAnchor.constraint(equalToConstant: 68),
            
            denyButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            denyButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            denyButton.heightAnchor.constraint(equalToConstant: 34),
            denyButton.widthAnchor.constraint(equalToConstant: 68)
            
        ])
        
    }
    
    
}



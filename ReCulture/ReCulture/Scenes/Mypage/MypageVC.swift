//
//  MypageVC.swift
//  ReCulture
//
//  Created by Jini on 5/3/24.
//

import UIKit

protocol LogoutModalDelegate: AnyObject {
    func popupChecked(view: String)
    func dismissLogoutModal()
}

extension MypageVC: LogoutModalDelegate {
    func popupChecked(view: String) {
        // Handle the delegate callback
    }
    
    func dismissLogoutModal() {
        // Dismiss the modal
        dismiss(animated: true)
        self.overlayView.removeFromSuperview()
    }
}

class MypageVC: UIViewController, UITableViewDelegate, UITableViewDataSource, EditProfileDelegate {
    
    private let viewModel = MypageViewModel()
    
    struct Section {
        var title: String
        var items: [String]
    }
    
    let myPageData = [
        Section(title: "프로필", items: ["프로필"]),
        Section(title: "친구 관리", items: ["친구 목록", "친구 요청"]),
        Section(title: "계정 설정", items: ["프로필 변경", "비밀번호 변경", "로그아웃", "계정 탈퇴"])
    ]
    
    let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "MypageVC"
        label.textColor = UIColor.blue
        
        return label
    }()
    
    lazy var mypageTableView: UITableView = {
        let tableview = UITableView()
        tableview.separatorStyle = .none
        
        return tableview
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.isNavigationBarHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(profileDidUpdate), name: NSNotification.Name("ProfileUpdated"), object: nil)
        
        bind()
        viewModel.getMyInfo(fromCurrentVC: self)
        
        setTableView()
        
        mypageTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        mypageTableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: "ProfileCell")
        
        mypageTableView.delegate = self
        mypageTableView.dataSource = self

        
    }
    
    func didUpdateProfile(nickname: String, bio: String) {
        // ViewModel의 데이터를 업데이트
        viewModel.setNickname(nickname)
        viewModel.setBio(bio)
        
        // UI 업데이트
        DispatchQueue.main.async {
            self.mypageTableView.reloadData()
        }
    }
    
    @objc func profileDidUpdate(notification: NSNotification) {
        
        viewModel.getMyInfo(fromCurrentVC: self)
        
        if let userInfo = notification.userInfo as? [String: String],
           let updatedNickname = userInfo["nickname"],
           let updatedBio = userInfo["bio"] {
            
            
            
            // Update the view model with the new profile data
            viewModel.setNickname(updatedNickname)
            viewModel.setBio(updatedBio)
            
            // Reload the table view to reflect the updated data
            DispatchQueue.main.async { [weak self] in
                self?.mypageTableView.reloadData()
            }
        }
    
        // Alternatively, you could re-fetch the profile data if needed
        viewModel.getMyInfo(fromCurrentVC: self)
//        viewModel.getMyInfo(fromCurrentVC: self)
//        
//        // Reload the entire table view to reflect updated data
//        DispatchQueue.main.async { [weak self] in
//            self?.mypageTableView.reloadData()
//        }
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
    
    private func bind(){
        viewModel.myPageModelDidChange = { [weak self] in
            
            DispatchQueue.main.async {
                //self?.setMyProfileInfo()
                self?.mypageTableView.reloadData()
            }
        }
    }
    
//    private func setMyProfileInfo() {
//
//    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return myPageData.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myPageData[section].items.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if myPageData[section].title == "프로필"{
            return nil
        }
        return myPageData[section].title
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = myPageData[indexPath.section].items[indexPath.row]
        if item == "프로필"{
            return 132

        }else{
            return 50
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 셀 선택 처리
        let selectedItem = myPageData[indexPath.section].items[indexPath.row]
        
        switch selectedItem {
        case "프로필":
            print("프로필 선택됨")
            //setProfile
            
        case "친구 목록":
            print("친구 목록 선택됨")
            let nextVC = ViewFriendVC()
            nextVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(nextVC, animated: true)
            
        case "친구 요청":
            print("친구 요청 선택됨")
            let nextVC = FriendRequestVC()
            nextVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(nextVC, animated: true)
            
        case "프로필 변경":
            print("프로필 변경 선택됨")
            let nextVC = EditProfileVC()
            nextVC.delegate = self
            
            let imageUrlStr = "http://34.64.120.187:8080\(viewModel.getProfileImage())"
            imageUrlStr.loadAsyncImage(nextVC.profileImage)
            nextVC.imageFileName = viewModel.getProfileImage()
//            nextVC.nicknameTextfield.text = viewModel.getNickname()
//            nextVC.introTextfield.text = viewModel.getBio()
//            nextVC.birthTextField.text = viewModel.getBirth().toDate()?.toString()
//            nextVC.interestRangeMenuBtn.setTitle(viewModel.getInterest(), for: .normal)
            
            nextVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(nextVC, animated: true)
            
        case "비밀번호 변경":
            print("비밀번호 변경 선택됨")
            let nextVC = EditPasswordVC()
            nextVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(nextVC, animated: true)
            
        case "로그아웃":
            print("로그아웃 선택됨")
            logout()
            //presentLogoutModal()
            
        case "계정 탈퇴":
            print("계정 탈퇴 선택됨")
            let nextVC = WithdrawalVC()
            nextVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(nextVC, animated: true)
            
            
        default:
            break
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = myPageData[indexPath.section]
        let item = section.items[indexPath.row]
        
        if section.title == "프로필" && item == "프로필" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileTableViewCell
            cell.selectionStyle = .none
            //cell.profileImageView.image = UIImage(named: "profile_image_placeholder") // 프로필 이미지
            print(viewModel.getProfileImage())
            if viewModel.getProfileImage() != "no_img" {
                cell.profileImageView.loadImage(urlWithoutBaseURL: viewModel.getProfileImage())
            }
            
            //cell.profileImageView.backgroundColor = UIColor.rcMain
            cell.nameLabel.text = "\(viewModel.getNickname())님"
            print(viewModel.getNickname())
            
            cell.commentLabel.text = "\(viewModel.getBio())"
            print(viewModel.getBio())
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.selectionStyle = .none
            cell.textLabel?.text = item
            let imageView = UIImageView(image: UIImage(named: "btn_arrow_small"))
            cell.accessoryView = imageView
            return cell
        }
    }
    
    func setTableView() {
        mypageTableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(mypageTableView)
        
        NSLayoutConstraint.activate([
            mypageTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            mypageTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            mypageTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            mypageTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
//    func presentLogoutModal() {
//        guard let tabBarController = tabBarController else { return }
//        
//        // Add the overlay view to the tab bar controller's view
//        tabBarController.view.addSubview(overlayView)
//        
//        NSLayoutConstraint.activate([
//            overlayView.topAnchor.constraint(equalTo: tabBarController.view.topAnchor),
//            overlayView.leadingAnchor.constraint(equalTo: tabBarController.view.leadingAnchor),
//            overlayView.trailingAnchor.constraint(equalTo: tabBarController.view.trailingAnchor),
//            overlayView.bottomAnchor.constraint(equalTo: tabBarController.view.bottomAnchor)
//        ])
//        
//        let vc = LogoutModal() // 로그아웃 완료 팝업 띄우기
//        vc.modalPresentationStyle = .overFullScreen
//        vc.delegate = self
//        present(vc, animated: true, completion: nil)
//    }
    
//    @objc func logout() {
//        let alertController = UIAlertController(
//            title: "로그아웃하시겠습니까?", message: nil,preferredStyle: .alert)
//        
//        let confirmAction = UIAlertAction(title: "로그아웃", style: .destructive) { [weak self] _ in
//            guard let self = self else { return }
//            //performLogout()
//            print("로그아웃 완료됨")
//            
//            self.navigationController?.popToRootViewController(animated: true)
//        }
//        
//        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
//
//        alertController.addAction(confirmAction)
//        alertController.addAction(cancelAction)
//
//        self.present(alertController, animated: true)
//    }
//    
//    func performLogout() {
//        
//    }
    
    @objc func logout() {
        let alertController = UIAlertController(
            title: "로그아웃하시겠습니까?", message: nil,preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "로그아웃", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            performLogout()
            print("로그아웃 완료됨")
            
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)

        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true)
    }
    
    func performLogout() {
        viewModel.logout(fromCurrentVC: self)
        
        //let accessTokenDeleted = KeychainManager.shared.deleteToken(type: .accessToken)
        let refreshTokenDeleted = KeychainManager.shared.deleteToken(type: .refreshToken)
        UserDefaults.standard.set(false, forKey: "isFirstLaunch")
    
//        if accessTokenDeleted && refreshTokenDeleted {
//            print("Both tokens were successfully deleted from the Keychain")
//        } else {
//            print("Failed to delete one or both tokens from the Keychain")
//        }
    }
}


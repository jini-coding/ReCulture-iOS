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

class MypageVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
    
    let mypageTableView: UITableView = {
        let tableview = UITableView()
        tableview.separatorStyle = .none
        
        return tableview
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.isNavigationBarHidden = true
        
        setTableView()
        
        mypageTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        mypageTableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: "ProfileCell")
        
        mypageTableView.delegate = self
        mypageTableView.dataSource = self
        
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
            self.navigationController?.pushViewController(nextVC, animated: true)
            
        case "친구 요청":
            print("친구 요청 선택됨")
            let nextVC = FriendRequestVC()
            self.navigationController?.pushViewController(nextVC, animated: true)
            
        case "프로필 변경":
            print("프로필 변경 선택됨")
            let nextVC = EditProfileVC()
            self.navigationController?.pushViewController(nextVC, animated: true)
            
        case "비밀번호 변경":
            print("비밀번호 변경 선택됨")
            let nextVC = EditPasswordVC()
            self.navigationController?.pushViewController(nextVC, animated: true)
            
        case "로그아웃":
            print("로그아웃 선택됨")
            presentLogoutModal()
            
        case "계정 탈퇴":
            print("계정 탈퇴 선택됨")
            let nextVC = WithdrawalVC()
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
            cell.profileImageView.backgroundColor = UIColor.rcMain
            cell.nameLabel.text = "조혜원님"
            cell.commentLabel.text = "나는 뮤지컬이 참 좋다"
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
    
    func presentLogoutModal() {
        guard let tabBarController = tabBarController else { return }
        
        // Add the overlay view to the tab bar controller's view
        tabBarController.view.addSubview(overlayView)
        
        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: tabBarController.view.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: tabBarController.view.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: tabBarController.view.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: tabBarController.view.bottomAnchor)
        ])
        
        let vc = LogoutModal() // 로그아웃 완료 팝업 띄우기
        vc.modalPresentationStyle = .overFullScreen  // Set the presentation style to overFullScreen
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
}


//
//  MypageViewModel.swift
//  ReCulture
//
//  Created by Jini on 6/13/24.
//

import UIKit

class MypageViewModel {
    // MARK: - Properties
        
    private var myProfileModel: MyProfileModel = MyProfileModel() {
        didSet {
            myPageModelDidChange?()
        }
    }
    
    private var userProfileModels: [Int: UserProfileModel] = [:] {
        didSet {
            userProfileModelsDidChange?()
        }
    }
    
    var followers: [FollowerModel] = [] {
        didSet {
            followersDidChange?()
        }
    }
    
    var followings: [FollowingModel] = [] {
        didSet {
            followingsDidChange?()
        }
    }
    
    var pendings: [FollowStateModel] = [] {
        didSet {
            pendingsDidChange?()
        }
    }
    
    private var requestState: FollowStateModel? {
        didSet {
            requestStateDidChange?()
        }
    }
    
    var userProfileModelsDidChange: (() -> Void)?
    var myPageModelDidChange: (() -> Void)?
    var followersDidChange: (() -> Void)?
    var followingsDidChange: (() -> Void)?
    var pendingsDidChange: (() -> Void)?
    var requestStateDidChange: (() -> Void)?
    
    // MARK: - Functions
    
    func getMyInfo(fromCurrentVC: UIViewController){
        NetworkManager.shared.getMyInfo() { result in
            switch result {
            case .success(let model):
                self.myProfileModel = model
                print("-- mypage view model --")
                print(model)
            case .failure(let error):
                print("-- mypage view model --")
                print(error)
                let networkAlertController = self.networkErrorAlert(error)

                DispatchQueue.main.async {
                    fromCurrentVC.present(networkAlertController, animated: true)
                }
            }
        }
    }
    
    func editMyProfile(requestDTO: EditMyProfileRequestDTO, profileImage: [ImageFile], fromCurrentVC: UIViewController){
        
        NetworkManager.shared.editMyProfile(requestDTO: requestDTO,
                                                 profileImage: profileImage) { result in
            switch result {
            case .success(let responseDTO):
                print(responseDTO)
                UserDefaults.standard.synchronize()
                //(fromCurrentVC as? NewUserProfileVC)?.newUserProfileSuccess = true
            case .failure(let error):
                let networkAlertController = self.networkErrorAlert(error)
                print(error.localizedDescription)
                print(error)
                DispatchQueue.main.async {
                    fromCurrentVC.present(networkAlertController, animated: true)
                }
            }
        }
    }
    
    func changePassword(curPassword: String, newPassword: String, fromCurrentVC: UIViewController) {
        let requestDTO = ChangePwRequestDTO(cur_password: curPassword, new_password: newPassword)
        
        NetworkManager.shared.changePw(requestDTO: requestDTO) { result in
            switch result {
            case .success(let responseDTO):
                print("Password changed successfully:", responseDTO)
                
                self.showChangePasswordSuccessAlert(fromCurrentVC: fromCurrentVC)
                
            case .failure(let error):
                let networkAlertController = self.networkErrorAlert(error)
                print("Failed to change password:", error)
                
                DispatchQueue.main.async {
                    fromCurrentVC.present(networkAlertController, animated: true)
                }
            }
        }
    }
    
    func showChangePasswordSuccessAlert(fromCurrentVC: UIViewController) {
        let alert = UIAlertController(title: "비밀번호 변경 완료", message: "비밀번호가 성공적으로 변경되었습니다.", preferredStyle: .alert)

        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            fromCurrentVC.navigationController?.popViewController(animated: true)
        }
        alert.addAction(confirmAction)
        
        DispatchQueue.main.async {
            fromCurrentVC.present(alert, animated: true)
        }
    }
    
    func logout(fromCurrentVC: UIViewController) {
        NetworkManager.shared.postUserLogout() { result in
            switch result {
            case .success(let responseDTO):
                print(responseDTO)

                self.logoutshowSuccessAlert(fromCurrentVC: fromCurrentVC)
                print("로그아웃완료")
                
            case .failure(let error):
                let networkAlertController = self.networkErrorAlert(error)
                print(error)
                print("로그아웃실패")
                DispatchQueue.main.async {
                    fromCurrentVC.present(networkAlertController, animated: true)
                }
            }
        }
    }
    

    func logoutshowSuccessAlert(fromCurrentVC: UIViewController) {
        let alert = UIAlertController(title: "로그아웃 성공", message: "로그아웃에 성공했습니다. \n첫 화면으로 돌아갑니다.", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            let root = LoginVC()
            let vc = UINavigationController(rootViewController: root) // 네비게이션 컨트롤러 추가
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(vc, animated: false)
        }
        alert.addAction(confirmAction)
        
        DispatchQueue.main.async {
            fromCurrentVC.present(alert, animated: true)
        }
    }
    
    func setUserDefaultsInitial() {
        UserDefaults.standard.set("", forKey: "accessToken")
        UserDefaults.standard.set("", forKey: "refreshToken")
        UserDefaults.standard.set("", forKey: "role")
        UserDefaults.standard.set("", forKey: "memberId")
    }
    
    func withdrawal(fromCurrentVC: UIViewController) {
        NetworkManager.shared.postUserWithdrawal() { result in
            switch result {
            case .success(let responseDTO):
                print(responseDTO)

                self.withdrawalshowSuccessAlert(fromCurrentVC: fromCurrentVC)
                print("탈퇴완료")
                
            case .failure(let error):
                let networkAlertController = self.networkErrorAlert(error)
                print(error)
                print("탈퇴실패")
                DispatchQueue.main.async {
                    fromCurrentVC.present(networkAlertController, animated: true)
                }
            }
        }
    }
    
    func withdrawalshowSuccessAlert(fromCurrentVC: UIViewController) {
        let alert = UIAlertController(title: "탈퇴 성공", message: "탈퇴하셨습니다. \n첫 화면으로 돌아갑니다.", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            let root = LoginVC()
            let vc = UINavigationController(rootViewController: root) // 네비게이션 컨트롤러 추가
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(vc, animated: false)
        }
        alert.addAction(confirmAction)
        
        DispatchQueue.main.async {
            fromCurrentVC.present(alert, animated: true)
        }
    }
    
    
//    func editProfile(requestDTO: NewUserProfileRequestDTO, profileImage: [ImageFile], fromCurrentVC: UIViewController) {
//
//        NetworkManager.shared.postNewUserProfile(newUserProfileRequestDTO: requestDTO,
//                                                 profileImage: profileImage) { result in
//            switch result {
//            case .success(let responseDTO):
//                print(responseDTO)
//                UserDefaults.standard.set(true, forKey: "isFirstLaunch")
//                UserDefaults.standard.set(responseDTO.nickname, forKey: "nickname")
//                UserDefaults.standard.synchronize()
//                UserDefaultsManager.shared.setData(value: requestDTO.nickname, key: .nickname)
//                
//                (fromCurrentVC as? NewUserProfileVC)?.newUserProfileSuccess = true
//            case .failure(let error):
//                let networkAlertController = self.networkErrorAlert(error)
//                print(error.localizedDescription)
//                print(error)
//                DispatchQueue.main.async {
//                    fromCurrentVC.present(networkAlertController, animated: true)
//                }
//            }
//        }
//    }
    
    func getFollowers() {
        NetworkManager.shared.getMyFollowers { [weak self] result in
            switch result {
            case .success(let followersDTOs):
                // Convert DTOs to Models
                let followersModels = FollowerDTO.convertFollowerDTOsToModels(DTOs: followersDTOs)
                self?.followers = followersModels  // Assign the converted models
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getFollowings() {
        NetworkManager.shared.getMyFollowings { [weak self] result in
            switch result {
            case .success(let followingsDTOs):
                // Convert DTOs to Models
                let followingsModels = FollowingDTO.convertFollowingDTOsToModels(DTOs: followingsDTOs)
                self?.followings = followingsModels  // Assign the converted models
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getPendingRequest() {
        NetworkManager.shared.getPendingRequest { [weak self] result in
            switch result {
            case .success(let pendings):
                self?.pendings = pendings
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getUserProfile(userId: Int, completion: @escaping (UserProfileModel?) -> Void) {
        NetworkManager.shared.getUserProfile(userId: userId) { result in
            switch result {
            case .success(let model):
                self.userProfileModels[userId] = model
                completion(model)
            case .failure(let error):
                print("-- record detail view model --")
                print(error)
                completion(nil)
            }
        }
    }
    
    func sendRequest(requestDTO: SendRequestDTO) {
        NetworkManager.shared.sendRequest(sendRequestDTO: requestDTO) { result in
            switch result {
            case .success(let model):
                self.requestState = model
                print("친구요청 발송 완료")
            case .failure(let error):
                print("-- send follow request --")
                print(error)
            }
        }
    }
    
    func acceptRequest(requestId: Int) {
        NetworkManager.shared.acceptRequest(requestId: requestId) { result in
            switch result {
            case .success(let model):
                self.requestState = model
            case .failure(let error):
                print("-- record detail view model --")
                print(error)
            }
        }
    }
    
    func rejectRequest(requestId: Int) {
        NetworkManager.shared.rejectRequest(requestId: requestId) { result in
            switch result {
            case .success(let model):
                self.requestState = model
            case .failure(let error):
                print("-- record detail view model --")
                print(error)
            }
        }
    }
    
    func getNickname() -> String {
        return myProfileModel.nickname ?? ""
    }
    
    func getBio() -> String {
        return myProfileModel.bio ?? ""
    }
    
    func getProfileImage() -> String {
        return myProfileModel.profilePhoto ?? "no_img"
    }
    
    func getBirth() -> String {
        return myProfileModel.birthdate ?? ""
    }
    
    func getInterest() -> String {
        return myProfileModel.interest ?? ""
    }
    
    func getUserProfileModel(for userId: Int) -> UserProfileModel? {
        return userProfileModels[userId]
    }
    
    func setNickname(_ nickname: String) {
        myProfileModel.nickname = nickname
        myPageModelDidChange?()  // 모델이 변경되었음을 알림
    }
    
    func setBio(_ bio: String) {
        myProfileModel.bio = bio
        myPageModelDidChange?()  // 모델이 변경되었음을 알림
    }
    
    
    private func networkErrorAlert(_ error: Error) -> UIAlertController{
        let alertController = UIAlertController(title: "네트워크 에러가 발생했습니다.", message: error.localizedDescription, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default)
        alertController.addAction(confirmAction)
        
        return alertController
    }
}

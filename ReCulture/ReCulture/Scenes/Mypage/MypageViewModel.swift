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
    
    func editMyProfile(requestDTO: NewUserProfileRequestDTO, profileImage: [ImageFile], fromCurrentVC: UIViewController){
        
        NetworkManager.shared.postNewUserProfile(newUserProfileRequestDTO: requestDTO,
                                                 profileImage: profileImage) { result in
            switch result {
            case .success(let responseDTO):
                print(responseDTO)
                UserDefaults.standard.set(true, forKey: "isFirstLaunch")
                UserDefaults.standard.synchronize()
                (fromCurrentVC as? NewUserProfileVC)?.newUserProfileSuccess = true
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
    
    
    
    private func networkErrorAlert(_ error: Error) -> UIAlertController{
        let alertController = UIAlertController(title: "네트워크 에러가 발생했습니다.", message: error.localizedDescription, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default)
        alertController.addAction(confirmAction)
        
        return alertController
    }
}

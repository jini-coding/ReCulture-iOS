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
    
    var followers: [FollowModel] = [] {
        didSet {
            followersDidChange?()
        }
    }
    
    var followings: [FollowModel] = [] {
        didSet {
            followingsDidChange?()
        }
    }
    
    var myPageModelDidChange: (() -> Void)?
    var followersDidChange: (() -> Void)?
    var followingsDidChange: (() -> Void)?
    
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
            case .success(let followers):
                self?.followers = followers
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getFollowings() {
        NetworkManager.shared.getMyFollowings { [weak self] result in
            switch result {
            case .success(let followings):
                self?.followings = followings
            case .failure(let error):
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
    
    
    
    private func networkErrorAlert(_ error: Error) -> UIAlertController{
        let alertController = UIAlertController(title: "네트워크 에러가 발생했습니다.", message: error.localizedDescription, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default)
        alertController.addAction(confirmAction)
        
        return alertController
    }
}

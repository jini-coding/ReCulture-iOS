//
//  HomeViewModel.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 6/7/24.
//

import UIKit

class MyProfileViewModel {
    // MARK: - Properties
        
    private var myProfileModel: MyProfileModel = MyProfileModel() {
        didSet {
            myProfileModelDidChange?()
        }
    }
    
    var myProfileModelDidChange: (() -> Void)?
    
    // MARK: - Functions
    
    func getMyProfile(fromCurrentVC: UIViewController){
        NetworkManager.shared.getMyProfile() { result in
            switch result {
            case .success(let model):
                self.myProfileModel = model
                print("-- home view model --")
                print(model)
            case .failure(let error):
                print("-- home view model --")
                print(error)
                let networkAlertController = self.networkErrorAlert(error)

                DispatchQueue.main.async {
                    fromCurrentVC.present(networkAlertController, animated: true)
                }
            }
        }
    }
    
    func getNickname() -> String {
        return myProfileModel.nickname!
    }
    
    func getLevelNum() -> Int {
        return myProfileModel.levelNum!
    }
    
    func getLevelName() -> String {
        return myProfileModel.levelName!
    }
    
    func getExp() -> Int {
        return myProfileModel.exp!
    }
    
    func getProfileImage() -> String {
        return myProfileModel.profilePhoto!
    }
    
    private func networkErrorAlert(_ error: Error) -> UIAlertController{
        let alertController = UIAlertController(title: "네트워크 에러가 발생했습니다.", message: error.localizedDescription, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default)
        alertController.addAction(confirmAction)
        
        return alertController
    }
}

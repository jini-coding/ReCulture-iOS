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
    
    var myPageModelDidChange: (() -> Void)?
    
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
    
    func getNickname() -> String {
        return myProfileModel.nickname ?? "닉네임"
    }
    
    func getBio() -> String {
        return myProfileModel.bio ?? "한줄 소개를 입력해주세요."
    }
    
    func getProfileImage() -> String {
        return myProfileModel.profilePhoto ?? "no_img"
    }
    
    private func networkErrorAlert(_ error: Error) -> UIAlertController{
        let alertController = UIAlertController(title: "네트워크 에러가 발생했습니다.", message: error.localizedDescription, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default)
        alertController.addAction(confirmAction)
        
        return alertController
    }
}

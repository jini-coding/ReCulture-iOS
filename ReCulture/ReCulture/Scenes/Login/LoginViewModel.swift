//
//  LoginViewModel.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 6/7/24.
//

import UIKit

class LoginViewModel {
    
    // MARK: - Functions
        
    func postUserLogin(requestDTO: LoginRequestDTO, fromCurrentVC: UIViewController){
        NetworkManager.shared.postUserLogin(loginRequestDTO: requestDTO) { result in
            switch result {
            case .success(let responseDTO):
                print("로그인 성공! 응답값은 아래")
                print(responseDTO)
                let accessToken = String(responseDTO.accessToken)
                let refreshToken = String(responseDTO.refreshToken)
                
                KeychainManager.shared.saveToken(type: .accessToken, token: accessToken)
                KeychainManager.shared.saveToken(type: .refreshToken, token: refreshToken)
                
                print("access token: \(KeychainManager.shared.getToken(type: .accessToken))")
                print("refresh token: \(KeychainManager.shared.getToken(type: .refreshToken))")
                
                UserDefaults.standard.set(true, forKey: "isFirstLaunch")
//                UserDefaults.standard.set(responseDTO.id, forKey: "userId")
//                UserDefaults.standard.synchronize()
                UserDefaultsManager.setData(value: responseDTO.id, key: .userId)
                
                (fromCurrentVC as? LoginVC)?.loginSuccess = true
            case .failure(let error):
                var networkAlertController: UIAlertController
                switch error {
                case .userAuthError:
                    networkAlertController = self.authErrorAlert(error)
                default:
                    networkAlertController = self.networkErrorAlert(error)
                }
                
                //let networkAlertController = self.networkErrorAlert(error)

                DispatchQueue.main.async {
                    fromCurrentVC.present(networkAlertController, animated: true)
                }
            }
        }
    }
    
    private func authErrorAlert(_ error: Error) -> UIAlertController{
        let alertController = UIAlertController(title: "로그인 정보가 틀렸습니다!",
                                                message: "다시 시도해주세요.",
                                                preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default)
        alertController.addAction(confirmAction)
        
        return alertController
    }
    
    private func networkErrorAlert(_ error: Error) -> UIAlertController{
        let alertController = UIAlertController(title: "네트워크 에러가 발생했습니다. 다시 시도해주세요", message: error.localizedDescription, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default)
        alertController.addAction(confirmAction)
        
        return alertController
    }
}

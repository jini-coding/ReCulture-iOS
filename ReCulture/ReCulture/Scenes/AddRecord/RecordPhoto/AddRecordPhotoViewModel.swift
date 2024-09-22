//
//  AddRecordPhotoViewModel.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 6/12/24.
//

import UIKit

final class AddRecordPhotoViewModel {
    
    // MARK: - Functions
        
    func postNewRecord(requestDTO: AddRecordRequestDTO, photos: [ImageFile], fromCurrentVC: UIViewController) {
        NetworkManager.shared.postNewRecord(addRecordRequestDTO: requestDTO, photos: photos) { result in
            switch result {
            case .success(let responseDTO):
                print("===AddRecordPhotoViewModel===")
                print("== POST 요청 성공!")
                print(responseDTO)
                (fromCurrentVC as? AddRecordPhotoVC)?.postNewRecordSuccess = true
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
    
    private func networkErrorAlert(_ error: Error) -> UIAlertController {
        let alertController = UIAlertController(title: "네트워크 에러가 발생했습니다. 다시 시도해주세요", message: error.localizedDescription, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default)
        alertController.addAction(confirmAction)
        
        return alertController
    }
}

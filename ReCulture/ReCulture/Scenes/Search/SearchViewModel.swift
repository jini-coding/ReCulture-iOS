//
//  SearchViewModel.swift
//  ReCulture
//
//  Created by Jini on 6/13/24.
//

import UIKit

class SearchViewModel {
    // MARK: - Properties
        
    private var allRecordModel: [RecordModel] = [] {
        didSet {
            allRecordModelDidChange?()
        }
    }
    
    private var userProfileModels: [Int: UserProfileModel] = [:] {
        didSet {
            userProfileModelsDidChange?()
        }
    }
    
    var allRecordModelDidChange: (() -> Void)?
    var userProfileModelsDidChange: (() -> Void)?
    
    // MARK: - Functions
    
    func getAllRecords(fromCurrentVC: UIViewController){
        NetworkManager.shared.getAllRecords() { result in
            switch result {
            case .success(let models):
                self.allRecordModel = models
                print("-- all record view model --")
                print(models)
            case .failure(let error):
                print("-- all record view model --")
                print(error)
                let networkAlertController = self.networkErrorAlert(error)

                DispatchQueue.main.async {
                    fromCurrentVC.present(networkAlertController, animated: true)
                }
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
    
    func recordCount() -> Int {
        return allRecordModel.count
    }
    
    func getRecord(at index: Int) -> RecordModel {
        return allRecordModel[index]
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



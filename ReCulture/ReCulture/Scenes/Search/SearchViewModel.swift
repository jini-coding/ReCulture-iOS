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
    
    private var allRecords: [RecordModel] = []
    
    var allRecordModelDidChange: (() -> Void)?
    var userProfileModelsDidChange: (() -> Void)?
    
    // MARK: - Functions
    
    func getAllRecords(fromCurrentVC: UIViewController){
        NetworkManager.shared.getAllRecords() { result in
            switch result {
            case .success(let models):
                self.allRecords = models
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

    func filterRecords(by category: String) {
        if category == "전체" {
            // 전체 카테고리인 경우 모든 레코드를 표시
            allRecordModel = allRecords
        } else {
            // 특정 카테고리에 해당하는 레코드만 필터링
            let categoryId = categoryId(from: category)
            allRecordModel = allRecords.filter { (record: RecordModel) -> Bool in
                return record.culture.categoryId == categoryId
            }
        }
    }

    private func categoryId(from category: String) -> Int {
        switch category {
        case "영화": return 1
        case "뮤지컬": return 2
        case "연극": return 3
        case "스포츠": return 4
        case "콘서트": return 5
        case "드라마": return 6
        case "독서": return 7
        case "전시회": return 8
        case "기타": return 9
        default: return 0
        }
    }
    
    
    private func networkErrorAlert(_ error: Error) -> UIAlertController{
        let alertController = UIAlertController(title: "네트워크 에러가 발생했습니다.", message: error.localizedDescription, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default)
        alertController.addAction(confirmAction)
        
        return alertController
    }
}



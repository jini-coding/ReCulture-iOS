//
//  SearchViewModel.swift
//  ReCulture
//
//  Created by Jini on 6/13/24.
//

import UIKit

class SearchViewModel {
    // MARK: - Properties
        
    private var allSearchModels: [SearchModel] = [] {
        didSet {
            allSearchModelsDidChange?()
        }
    }
    
    private var userProfileModels: [Int: UserProfileModel] = [:] {
        didSet {
            userProfileModelsDidChange?()
        }
    }
    
    private var allRecords: [SearchModel] = []
    private var pagination: SearchResponseDTO.Pagination?

    var allSearchModelsDidChange: (() -> Void)?
    var userProfileModelsDidChange: (() -> Void)?
    
    // MARK: - Functions
    
//    func getAllRecords(fromCurrentVC: UIViewController) {
//        NetworkManager.shared.getAllRecords() { result in
//            switch result {
//            case .success(let (models, pagination)):
//                self.allRecords = models
//                self.allSearchModels = models
//                self.pagination = pagination
//                print("-- all search view model --")
//                print(models)
//                print("Pagination info: \(pagination)")
//            case .failure(let error):
//                print("-- all search view model --")
//                print(error)
//                let networkAlertController = self.networkErrorAlert(error)
//
//                DispatchQueue.main.async {
//                    fromCurrentVC.present(networkAlertController, animated: true)
//                }
//            }
//        }
//    }
    func getAllRecords(fromCurrentVC: UIViewController) {
        let currentPage = pagination?.currentPage ?? 1
        let pageSize = pagination?.pageSize ?? 10
        
        NetworkManager.shared.getAllRecords(page: currentPage, pageSize: pageSize) { result in
            switch result {
            case .success(let responseDTO):
                let models = self.convertToSearchModels(DTOs: responseDTO.data)
                self.allRecords.append(contentsOf: models) 
                self.pagination = responseDTO.pagination
                self.allSearchModels = self.allRecords 
            case .failure(let error):
                print("Error:", error)
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
                print("-- search view model --")
                print(error)
                completion(nil)
            }
        }
    }
    
    private func convertToSearchModels(DTOs: [SearchResponseDTO.SearchRecordDTO]) -> [SearchModel] {
        return DTOs.map { dto in
            SearchModel(
                id: dto.id,
                title: dto.title,
                emoji: dto.emoji,
                date: dto.date,
                categoryId: dto.categoryId,
                authorId: dto.authorId,
                disclosure: dto.disclosure,
                review: dto.review,
                detail1: dto.detail1,
                detail2: dto.detail2,
                detail3: dto.detail3,
                detail4: dto.detail4,
                photos: dto.photos?.map { photoDTO in
                    SearchModel.PhotoModel(
                        id: photoDTO.id,
                        url: photoDTO.url,
                        culturePostId: photoDTO.culturePostId
                    )
                } ?? []
            )
        }
    }
    
    func recordCount() -> Int {
        return allSearchModels.count
    }
    
    func getRecord(at index: Int) -> SearchModel {
        return allSearchModels[index]
    }
    
    func getUserProfileModel(for userId: Int) -> UserProfileModel? {
        return userProfileModels[userId]
    }

    func filterRecords(by category: String) {
        if category == "전체" {
            allSearchModels = allRecords
        } else {
            let categoryId = categoryId(from: category)
            allSearchModels = allRecords.filter { (record: SearchModel) -> Bool in
                return record.categoryId == categoryId
            }
        }
    }
    
    func canLoadMorePages() -> Bool {
        guard let pagination = pagination else { return false }
        return pagination.currentPage < pagination.totalPages
    }
    
    var currentPage: Int? {
        return pagination?.currentPage
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
    
    private func networkErrorAlert(_ error: Error) -> UIAlertController {
        let alertController = UIAlertController(title: "네트워크 에러가 발생했습니다.", message: error.localizedDescription, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default)
        alertController.addAction(confirmAction)
        return alertController
    }
}

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
    
    private var allRecommendModels: [SearchModel] = [] {
        didSet {
            allRecommendModelsDidChange?()
        }
    }
    
    private var allSearchedModels: [SearchModel] = [] {
        didSet {
            allSearchedModelsDidChange?()
        }
    }
    
    private var allUserSearchedModels: [UserSearchModel] = [] {
        didSet {
            allUserSearchedModelsDidChange?()
        }
    }
    
    private var userProfileModels: [Int: UserProfileModel] = [:] {
        didSet {
            userProfileModelsDidChange?()
        }
    }
    
    private var allRecords: [SearchModel] = []
    private var pagination: SearchResponseDTO.Pagination?
    private var userpagination: UserSearchResponseDTO.UserPagination?
    
    private var allRecommendRecords: [SearchModel] = []
    private var allSearchedRecords: [SearchModel] = []
    private var allUserSearchedRecords: [UserSearchModel] = []

    var allSearchModelsDidChange: (() -> Void)?
    var allRecommendModelsDidChange: (() -> Void)?
    var allSearchedModelsDidChange: (() -> Void)?
    var userProfileModelsDidChange: (() -> Void)?
    var allUserSearchedModelsDidChange: (() -> Void)?
    
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
    func getAllRecords(fromCurrentVC: UIViewController, completion: @escaping () -> Void) {
        // If pagination already exists, increment the currentPage
        let currentPage = (pagination?.currentPage ?? 0) + 1
        let pageSize = pagination?.pageSize ?? 10

        NetworkManager.shared.getAllRecords(page: currentPage, pageSize: pageSize) { result in
            switch result {
            case .success(let responseDTO):
                let models = self.convertToSearchModels(DTOs: responseDTO.data)

                // Append new records to the existing ones
                self.allRecords.append(contentsOf: models)
                self.allSearchModels = self.allRecords // Update the displayed records
                self.pagination = responseDTO.pagination

                print("Pagination info: \(String(describing: self.pagination))")
                completion()
            case .failure(let error):
                print("Error:", error)
                let networkAlertController = self.networkErrorAlert(error)
                DispatchQueue.main.async {
                    fromCurrentVC.present(networkAlertController, animated: true)
                }
                completion()
            }
        }
    }

    
    func getRecommendRecords(fromCurrentVC: UIViewController, completion: @escaping () -> Void) {
        // Use default values of 1 for `currentPage` and 10 for `pageSize` if they are nil
        let currentPage = pagination?.currentPage ?? 1
        let pageSize = pagination?.pageSize ?? 10
        
        NetworkManager.shared.getRecommendRecords(page: currentPage, pageSize: pageSize) { result in
            switch result {
            case .success(let responseDTO):
                let models = self.convertToSearchModels(DTOs: responseDTO.data)
                self.allRecommendRecords = models
                self.pagination = responseDTO.pagination
                self.allSearchModels = self.allRecommendRecords
                completion()
                
            case .failure(let error):
                print("추천실패 Error:", error)
                completion()
            }
        }
    }

    
    func getSearchedRecords(fromCurrentVC: UIViewController, searchString: String, completion: @escaping () -> Void) {
        
        let searchString = searchString
        print("searchString : \(searchString)")
        let currentPage = pagination?.currentPage ?? 1
        let pageSize = pagination?.pageSize ?? 10
        
        NetworkManager.shared.getSearchedRecords(searchString: searchString, page: currentPage, pageSize: pageSize) { result in
            switch result {
            case .success(let responseDTO):
                let models = self.convertToSearchModels(DTOs: responseDTO.data)
                self.allSearchedRecords = models
                self.pagination = responseDTO.pagination
                self.allSearchedModels = self.allSearchedRecords
                print("=== 검색 성공 ===")
                print(models)
                print("===")
                completion()
            case .failure(let error):
                print("검색 실패: \(error)")
                completion()
            }
        }
    }
    
    func getSearchedUsers(fromCurrentVC: UIViewController, nickname: String, completion: @escaping () -> Void) {
        
        let nickname = nickname
        print("nickname : \(nickname)")
        let currentPage = userpagination?.currentPage ?? 1
        let pageSize = userpagination?.pageSize ?? 10
        
        NetworkManager.shared.getSearchedUsers(nickname: nickname, page: currentPage, pageSize: pageSize) { result in
            switch result {
            case .success(let responseDTO):
                let models = self.convertToUserSearchModels(DTOs: responseDTO.data)
                self.allUserSearchedRecords = models
                self.userpagination = responseDTO.pagination
                self.allUserSearchedModels = self.allUserSearchedRecords
                print("=== 유저 검색 성공 ===")
                print(models)
                print("===")
                completion()
            case .failure(let error):
                print("검색 실패: \(error)")
                completion()
            }
        }
    }
    
    func clearRecords() {
        allRecords.removeAll()           // Clear all records
        allRecommendRecords.removeAll()   // Clear recommended records
        allSearchedRecords.removeAll()    // Clear searched records
        allSearchModels.removeAll()       // Clear current displayed records (this will immediately affect the UI)
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
                createdAt: dto.createdAt,
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
    
    private func convertToUserSearchModels(DTOs: [UserSearchResponseDTO.UserSearchRecordDTO]) -> [UserSearchModel] {
        return DTOs.map { dto in
            UserSearchModel(
                id: dto.id,
                userId: dto.userId,
                nickname: dto.nickname,
                bio: dto.bio,
                birthdate: dto.birthdate,
                interest: dto.interest,
                profilePhoto: dto.profilePhoto,
                exp: dto.exp,
                levelId: dto.levelId,
                level: dto.level
            )
        }
    }
    
    func recordCount() -> Int {
        return allSearchModels.count
    }
    
    func searchedRecordCount() -> Int {
        return allSearchedModels.count
    }
    
    func userCount() -> Int {
        return allUserSearchedModels.count
    }
    
    func getRecord(at index: Int) -> SearchModel {
        return allSearchModels[index]
    }
    
    func getSearchedRecord(at index: Int) -> SearchModel {
        return allSearchedModels[index]
    }
    
    func getUser(at index: Int) -> UserSearchModel {
        return allUserSearchedModels[index]
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
    
    func canLoadMoreUserPages() -> Bool {
        guard let pagination = userpagination else { return false }
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

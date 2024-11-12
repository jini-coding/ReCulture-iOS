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
    
    private var userProfileDetail: UserProfileModel? {
        didSet {
            userProfileDetailDidChange?()
        }
    }
    
    private var allRecords: [SearchModel] = []
    private var paginationForAll: SearchResponseDTO.Pagination?
    private var paginationForRecommend: SearchResponseDTO.Pagination?
    private var paginationForSearchResult: SearchResponseDTO.Pagination?
    private var userpagination: UserSearchResponseDTO.UserPagination?
    
    private var allRecommendRecords: [SearchModel] = []
    private var allSearchedRecords: [SearchModel] = []
    private var allUserSearchedRecords: [UserSearchModel] = []

    var allSearchModelsDidChange: (() -> Void)?
    var allRecommendModelsDidChange: (() -> Void)?
    var allSearchedModelsDidChange: (() -> Void)?
    var userProfileModelsDidChange: (() -> Void)?
    var allUserSearchedModelsDidChange: (() -> Void)?
    var userProfileDetailDidChange: (() -> Void)?
    
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
        // If pagination already exists, increment the currentPage
        let currentPage = (paginationForAll?.currentPage ?? 0) + 1
        let pageSize = paginationForAll?.pageSize ?? 10

        NetworkManager.shared.getAllRecords(page: currentPage, pageSize: pageSize) { result in
            switch result {
            case .success(let responseDTO):
                let models = self.convertToSearchModels(DTOs: responseDTO.data)

                // Append new records to the existing ones
                self.allRecords.append(contentsOf: models)
                self.allSearchModels = self.allRecords // Update the displayed records
                self.paginationForAll = responseDTO.pagination

                print("Pagination info: \(String(describing: self.paginationForAll))")
            case .failure(let error):
                print("Error:", error)
                let networkAlertController = self.networkErrorAlert(error)
                DispatchQueue.main.async {
                    fromCurrentVC.present(networkAlertController, animated: true)
                }
            }
        }
    }

    
    func getRecommendRecords(fromCurrentVC: UIViewController) {
        // Use default values of 1 for `currentPage` and 10 for `pageSize` if they are nil
        let currentPage = (paginationForRecommend?.currentPage ?? 0) + 1
        let pageSize = paginationForRecommend?.pageSize ?? 10
        
        NetworkManager.shared.getRecommendRecords(page: currentPage, pageSize: pageSize) { result in
            switch result {
            case .success(let responseDTO):
                let models = self.convertToSearchModels(DTOs: responseDTO.data)
                // Append new records to the existing ones
                self.allRecommendRecords.append(contentsOf: models)
                self.allSearchModels = self.allRecommendRecords
                self.paginationForRecommend = responseDTO.pagination
                
                print("Pagination info (Recommend): \(String(describing: self.paginationForRecommend))")
            case .failure(let error):
                print("추천실패 Error:", error)
            }
        }
    }

    
    func getSearchedRecords(fromCurrentVC: UIViewController, searchString: String) {
        
        let searchString = searchString
        print("searchString : \(searchString)")
        let currentPage = (paginationForSearchResult?.currentPage ?? 0) + 1
        let pageSize = paginationForSearchResult?.pageSize ?? 10
        
        NetworkManager.shared.getSearchedRecords(searchString: searchString, page: currentPage, pageSize: pageSize) { result in
            switch result {
            case .success(let responseDTO):
                let models = self.convertToSearchModels(DTOs: responseDTO.data)
                self.allSearchedRecords.append(contentsOf: models)
                self.paginationForSearchResult = responseDTO.pagination
                self.allSearchedModels = self.allSearchedRecords
                print("=== 검색 성공 ===")
                print(models)
                print("===")
                print("Pagination info (SEARCH RECORD): \(String(describing: self.paginationForSearchResult))")
            case .failure(let error):
                print("검색 실패: \(error)")
            }
        }
    }
    
    func getSearchedUsers(fromCurrentVC: UIViewController, nickname: String) {
        
        let nickname = nickname
        print("nickname : \(nickname)")
        let currentPage = (userpagination?.currentPage ?? 0) + 1
        let pageSize = userpagination?.pageSize ?? 10
        
        NetworkManager.shared.getSearchedUsers(nickname: nickname, page: currentPage, pageSize: pageSize) { result in
            switch result {
            case .success(let responseDTO):
                let models = self.convertToUserSearchModels(DTOs: responseDTO.data)
                self.allUserSearchedRecords.append(contentsOf: models)
                self.userpagination = responseDTO.pagination
                self.allUserSearchedModels = self.allUserSearchedRecords
                print("=== 유저 검색 성공 ===")
                print(models)
                print("===")
                print("Pagination info (SEARCH USER): \(String(describing: self.userpagination))")
            case .failure(let error):
                print("검색 실패: \(error)")
            }
        }
    }
    
    func clearRecords() {
        allRecords.removeAll()           // Clear all records
        allRecommendRecords.removeAll()   // Clear recommended records
        allSearchedRecords.removeAll()    // Clear searched records
        allSearchModels.removeAll()       // Clear current displayed records (this will immediately affect the UI)
        
        clearPaginationDatas()
    }
    
    func clearPaginationDatas() {
        paginationForAll = nil
        paginationForRecommend = nil
        paginationForSearchResult = nil
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
    
    func getUserProfileDetails(userId: Int) {
        NetworkManager.shared.getUserProfileDetails(userId: userId) { result in
            switch result {
            case .success(let model):
                self.userProfileDetail = model
            case .failure(let error):
                print("-- record detail view model --")
                print(error)
            }
        }
    }
    
    func getUserdDetail() -> UserProfileModel? {
        return userProfileDetail
    }
    
    func getProfileImage() -> String {
        return userProfileDetail?.profilePhoto ?? "no_img"
    }
    
    func getNickname() -> String {
        return userProfileDetail?.nickname ?? "Unknown user"
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
    
    func canLoadMorePages(isRecommendMode: Bool) -> Bool {
        if isRecommendMode {
            guard let pagination = paginationForRecommend else { return false }
            return pagination.currentPage < pagination.totalPages
        }
        else {
            guard let pagination = paginationForAll else { return false }
            return pagination.currentPage < pagination.totalPages
        }
    }
    
    func canLoadMoreSearchResultPages() -> Bool {
        guard let pagination = paginationForSearchResult else { return false }
        return pagination.currentPage < pagination.totalPages
    }
    
    func canLoadMoreUserPages() -> Bool {
        guard let pagination = userpagination else { return false }
        return pagination.currentPage < pagination.totalPages
    }
    
//    var currentPage: Int? {
//        return pagination?.currentPage
//    }

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

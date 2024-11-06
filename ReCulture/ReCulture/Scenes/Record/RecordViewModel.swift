//
//  RecordViewModel.swift
//  ReCulture
//
//  Created by Jini on 6/13/24.
//

import UIKit

class RecordViewModel {
    // MARK: - Properties
        
    /// 기록이 리스트로 여러개 올 때의 각 기록 내용
    private var myRecordModel: [AllRecordsModel] = [] {
        didSet {
            allRecordModelDidChange?()
        }
    }
    
    /// 기록이 리스트로 여러개 올 때의 각 기록 내용
    private var allRecordDetail: AllRecordsModel? {
        didSet {
            allRecordModelDidChange?()
        }
    }
    
    /// 특정 기록 '하나'의 상세 내용
    private var recordDetail: RecordModel? {
        didSet {
            recordDetailDidChange?()
        }
    }
    
    /// 특정 유저의 기록들 내용
    private var userRecordModel: [AllRecordsModel] = [] {
        didSet {
            allUserRecordModelDidChange?()
        }
    }
    
    /// 특정 유저의 기록이 리스트로 여러개 올 때의 각 기록 내용
    private var allUserRecordDetail: AllRecordsModel? {
        didSet {
            allUserRecordModelDidChange?()
        }
    }
    
    
    /// 특정 유저 기록 하나의 상세 내용
    private var userrecordDetail: RecordModel? {
        didSet {
            userrecordDetailDidChange?()
        }
    }
    
    private var allRecords: [AllRecordsModel] = []  // Holds all records fetched from the server
    private var filteredRecords: [AllRecordsModel] = []
    private var userRecords: [AllRecordsModel] = [] // 특정 유저 기록
    
    var allRecordModelDidChange: (() -> Void)?
    var recordDetailDidChange: (() -> Void)?
    var allUserRecordModelDidChange: (() -> Void)?
    var userrecordDetailDidChange: (() -> Void)?
    
    // MARK: - Functions
    
    /// 내 기록탭에서 사용되는, 모든 기록 가져오는 함수
    func getmyRecords(fromCurrentVC: UIViewController){
        NetworkManager.shared.getMyRecords() { result in
            switch result {
            case .success(let models):
                self.allRecords = models // 모든 레코드를 allRecords에 저장
                self.myRecordModel = models
                print("-- my record view model --")
                print(models)
            case .failure(let error):
                print("-- my record view model --")
                print(error)
                let networkAlertController = self.networkErrorAlert(error)

                DispatchQueue.main.async {
                    fromCurrentVC.present(networkAlertController, animated: true)
                }
            }
        }
    }
    
    func getRecordDetail(at index: Int) -> AllRecordsModel {
        return myRecordModel[index]
    }

    /// 기록 아이디로 특정 기록 상세 내용 가져오기
    func getRecordDetails(recordId: Int) {
        NetworkManager.shared.getRecordDetails(recordId: recordId) { result in
            switch result {
            case .success(let model):
                self.recordDetail = model
            case .failure(let error):
                print("-- record detail view model --")
                print(error)
            }
        }
    }
    
    func getRecordDetail() -> RecordModel? {
        return recordDetail
    }
    
    func recordCount() -> Int {
        return myRecordModel.count
    }
    
    func getUserRecordDetail(at index: Int) -> AllRecordsModel {
        return userRecordModel[index]
    }
    
    func getUserRecordDetail() -> RecordModel? {
        return recordDetail
    }
    
    func userrecordCount() -> Int {
        return userRecordModel.count
    }
    
    func deleteRecord(postId: Int) {
        NetworkManager.shared.deleteRecord(postId: postId) { result in
            switch result {
            case .success(let model):
                self.allRecordDetail = model
            case .failure(let error):
                print("-- record detail view model --")
                print(error)
            }
        }
    }
    
    func filterRecords(by category: String) {
        if category == "전체" {
            // 전체 카테고리인 경우 모든 레코드를 표시
            myRecordModel = allRecords
        } else {
            // 특정 카테고리에 해당하는 레코드만 필터링
            let categoryId = categoryId(from: category)
            myRecordModel = allRecords.filter { (record: AllRecordsModel) -> Bool in
                return record.culture.categoryId == categoryId
            }
        }
    }
    
    /// 특정 유저의 기록 가져오는 함수
    func getuserRecords(userId: Int, fromCurrentVC: UIViewController){
        NetworkManager.shared.getUserRecords(userId: userId) { result in
            switch result {
            case .success(let models):
                self.userRecords = models
                self.userRecordModel = models
                print("-- user record view model --")
                print(models)
            case .failure(let error):
                print("-- user record view model --")
                print(error)
                let networkAlertController = self.networkErrorAlert(error)

                DispatchQueue.main.async {
                    fromCurrentVC.present(networkAlertController, animated: true)
                }
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
    
//    func getNickname() -> String {
//        return myRecordModel.title!
//    }
//    
//    func getEmoji() -> String {
//        return myRecordModel.emoji!
//    }
//    
//    func getDate() -> String {
//        return myRecordModel.date!
//    }
//    
//    func getCategoryId() -> Int {
//        return myRecordModel.categoryId!
//    }
//    
//    func getAuthorId() -> Int {
//        return myRecordModel.authorId!
//    }
//    
//    func getDisclosure() -> String {
//        return myRecordModel.disclosure!
//    }
//    
//    func getReview() -> String {
//        return myRecordModel.review!
//    }
//    
//    func getDetail1() -> String {
//        return myRecordModel.detail1!
//    }
//    
//    func getDetail2() -> String {
//        return myRecordModel.detail2!
//    }
//    
//    func getDetail3() -> String {
//        return myRecordModel.detail3!
//    }
//    
//    func getDetail4() -> String {
//        return myRecordModel.detail4!
//    }
//
    
    func getRecord(at index: Int) -> AllRecordsModel {
        return myRecordModel[index]
    }
    
    func getUserRecord(at index: Int) -> AllRecordsModel {
        return userRecordModel[index]
    }
    
    
    private func networkErrorAlert(_ error: Error) -> UIAlertController{
        let alertController = UIAlertController(title: "네트워크 에러가 발생했습니다.", message: error.localizedDescription, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default)
        alertController.addAction(confirmAction)
        
        return alertController
    }
}

